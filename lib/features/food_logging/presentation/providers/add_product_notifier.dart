import 'package:flutter/material.dart' show Rect;
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/meal_type.dart';
import '../../data/food_repository.dart';
import '../../data/services/food_photo_service.dart';
import '../../data/services/image_crop_service.dart';
import '../../data/services/nutrition_label_ocr_service.dart';
import '../../domain/exceptions/duplicate_barcode_exception.dart';
import '../../domain/models/food.dart';
import '../../domain/validation/macro_calorie_validator.dart';
import 'add_product_form_state.dart';
import 'browse_foods_providers.dart';
import 'food_search_providers.dart';

part 'add_product_notifier.g.dart';

/// The quantity the food-search "quick add" shortcut logs an already-known
/// food at, with no prompt. A brand-new food (Add Product's own "Add to
/// meal") is never logged at this fixed amount — see AddProductScreen,
/// which sends the user to FoodDetailScreen's quantity stepper instead.
const double kDefaultLoggedQuantityGrams = 100.0;

@riverpod
class AddProductNotifier extends _$AddProductNotifier {
  @override
  AddProductFormState build({String? prefillBarcode, MealType? presetMealType}) {
    return AddProductFormState(
      barcode: prefillBarcode,
      mealType: presetMealType ?? MealType.breakfast,
    );
  }

  void setName(String value) => state = state.copyWith(name: value);
  void setBrand(String? value) => state = state.copyWith(brand: value);
  void setStore(String? value) => state = state.copyWith(store: value);
  void setBarcode(String? value) => state = state.copyWith(barcode: value);
  void setMealType(MealType value) => state = state.copyWith(mealType: value);
  void setLogToMealEnabled(bool value) =>
      state = state.copyWith(logToMealEnabled: value);
  void toggleFavorite() => state = state.copyWith(isFavorite: !state.isFavorite);
  void toggleShowMoreMicronutrients() =>
      state = state.copyWith(showMoreMicronutrients: !state.showMoreMicronutrients);

  void setCalories(double? value) => state = state.copyWith(caloriesPer100g: value);
  void setProtein(double? value) => state = state.copyWith(proteinPer100g: value);
  void setFat(double? value) => state = state.copyWith(fatPer100g: value);
  void setCarbs(double? value) => state = state.copyWith(carbsPer100g: value);
  void setFiber(double? value) => state = state.copyWith(fiberPer100g: value);
  void setSugar(double? value) => state = state.copyWith(sugarPer100g: value);
  void setSodium(double? value) => state = state.copyWith(sodiumMgPer100g: value);
  void setCholesterol(double? value) =>
      state = state.copyWith(cholesterolMgPer100g: value);
  void setPotassium(double? value) =>
      state = state.copyWith(potassiumMgPer100g: value);
  void setCalcium(double? value) => state = state.copyWith(calciumMgPer100g: value);
  void setIron(double? value) => state = state.copyWith(ironMgPer100g: value);
  void setVitaminC(double? value) =>
      state = state.copyWith(vitaminCMgPer100g: value);
  void setVitaminD(double? value) =>
      state = state.copyWith(vitaminDMcgPer100g: value);

  void clearPhoto() => state = state.copyWith(photoPath: null);

  Future<void> pickPhoto(ImageSource source) async {
    state = state.copyWith(isPickingPhoto: true, photoError: null);
    try {
      final path = await ref.read(foodPhotoServiceProvider).pickPhoto(source: source);
      state = state.copyWith(isPickingPhoto: false, photoPath: path ?? state.photoPath);
    } catch (e) {
      state = state.copyWith(isPickingPhoto: false, photoError: 'Could not use that photo: $e');
    }
  }

  /// Picks the raw label photo, before cropping. Returns null if the user
  /// cancels the picker.
  Future<String?> pickLabelPhoto(ImageSource source) {
    return ref.read(nutritionLabelOcrServiceProvider).pickPhoto(source: source);
  }

  /// Crops the picked photo to [cropRect] (chosen by the user dragging the
  /// crop screen's corner handles, in the photo's own pixel coordinates)
  /// and runs OCR on the result.
  Future<void> scanCroppedLabel({
    required String imagePath,
    required Rect cropRect,
  }) async {
    state = state.copyWith(isScanningLabel: true, ocrError: null);
    try {
      final croppedPath = await ref.read(imageCropServiceProvider).cropToFile(
            sourcePath: imagePath,
            cropRect: cropRect,
          );
      final parsed = await ref
          .read(nutritionLabelOcrServiceProvider)
          .recognizeLabel(imagePath: croppedPath);
      state = state.copyWith(
        isScanningLabel: false,
        ocrPer100gColumnFound: parsed.matchedPer100gColumn,
        caloriesPer100g: parsed.caloriesPer100g ?? state.caloriesPer100g,
        proteinPer100g: parsed.proteinPer100g ?? state.proteinPer100g,
        fatPer100g: parsed.fatPer100g ?? state.fatPer100g,
        carbsPer100g: parsed.carbsPer100g ?? state.carbsPer100g,
        fiberPer100g: parsed.fiberPer100g ?? state.fiberPer100g,
        sugarPer100g: parsed.sugarPer100g ?? state.sugarPer100g,
        sodiumMgPer100g: parsed.sodiumMgPer100g ?? state.sodiumMgPer100g,
        cholesterolMgPer100g: parsed.cholesterolMgPer100g ?? state.cholesterolMgPer100g,
        potassiumMgPer100g: parsed.potassiumMgPer100g ?? state.potassiumMgPer100g,
        calciumMgPer100g: parsed.calciumMgPer100g ?? state.calciumMgPer100g,
        ironMgPer100g: parsed.ironMgPer100g ?? state.ironMgPer100g,
        vitaminCMgPer100g: parsed.vitaminCMgPer100g ?? state.vitaminCMgPer100g,
        vitaminDMcgPer100g: parsed.vitaminDMcgPer100g ?? state.vitaminDMcgPer100g,
      );
    } catch (e) {
      state = state.copyWith(isScanningLabel: false, ocrError: 'Could not read the label: $e');
    }
  }

  /// Saves the current form as a food. When the entered macros don't
  /// roughly account for the entered calories, nothing is persisted and
  /// [AddProductFormState.macroMismatchWarning] is set instead — unless
  /// [ignoreMismatch] is true, which saves anyway (the warning banner's
  /// "Save anyway" action).
  Future<void> save({bool ignoreMismatch = false}) async {
    // A previous attempt already saved this food (the user chose "Save
    // anyway" and came back to edit further) — update that same row
    // instead of creating a duplicate.
    final previouslySavedId = state.savedFood?.id;

    state = state.copyWith(isSaving: true, saveError: null, macroMismatchWarning: null);
    try {
      final macrosMatch = macrosRoughlyMatchCalories(
        calories: state.caloriesPer100g,
        protein: state.proteinPer100g,
        fat: state.fatPer100g,
        carbs: state.carbsPer100g,
      );
      if (!macrosMatch && !ignoreMismatch) {
        // macrosRoughlyMatchCalories only returns false once all four
        // values are known, so they're safe to read unconditionally here.
        final mismatchWarning =
            '${_fmtGrams(state.proteinPer100g!)} g protein × 4 + '
            '${_fmtGrams(state.carbsPer100g!)} g carbs × 4 + '
            '${_fmtGrams(state.fatPer100g!)} g fat × 9 = '
            '${expectedCaloriesFromMacros(
              protein: state.proteinPer100g!,
              fat: state.fatPer100g!,
              carbs: state.carbsPer100g!,
            ).round()} kcal, but you entered ${state.caloriesPer100g!.round()} kcal per '
            '100 g. Please check and edit them, or save anyway.';
        state = state.copyWith(isSaving: false, macroMismatchWarning: mismatchWarning);
        return;
      }

      final food = Food(
        id: previouslySavedId,
        name: state.name,
        brand: state.brand,
        store: state.store,
        barcode: state.barcode,
        photoPath: state.photoPath,
        isFavorite: state.isFavorite,
        caloriesPer100g: state.caloriesPer100g,
        proteinPer100g: state.proteinPer100g,
        fatPer100g: state.fatPer100g,
        carbsPer100g: state.carbsPer100g,
        fiberPer100g: state.fiberPer100g,
        sugarPer100g: state.sugarPer100g,
        sodiumMgPer100g: state.sodiumMgPer100g,
        cholesterolMgPer100g: state.cholesterolMgPer100g,
        potassiumMgPer100g: state.potassiumMgPer100g,
        calciumMgPer100g: state.calciumMgPer100g,
        ironMgPer100g: state.ironMgPer100g,
        vitaminCMgPer100g: state.vitaminCMgPer100g,
        vitaminDMcgPer100g: state.vitaminDMcgPer100g,
      );

      final Food saved;
      if (previouslySavedId == null) {
        saved = await ref.read(foodRepositoryProvider).create(food);
      } else {
        await ref.read(foodRepositoryProvider).update(food);
        saved = food;
      }

      ref.invalidate(recentFoodsProvider);
      ref.invalidate(foodsGroupedAlphabeticallyProvider);
      if (saved.isFavorite) ref.invalidate(favoriteFoodsProvider);

      state = state.copyWith(isSaving: false, savedFood: saved);
    } catch (e) {
      final message = e is DuplicateBarcodeException ? e.toString() : 'Could not save this food: $e';
      state = state.copyWith(isSaving: false, saveError: message);
    }
  }
}

String _fmtGrams(double value) {
  final text = value.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
