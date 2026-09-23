import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/meal_type.dart';
import '../../domain/models/food.dart';

part 'add_product_form_state.freezed.dart';

@freezed
abstract class AddProductFormState with _$AddProductFormState {
  const factory AddProductFormState({
    String? photoPath,
    String? barcode,
    @Default('') String name,
    String? brand,
    String? store,
    String? pieceLabel,
    double? pieceWeightGrams,
    @Default(false) bool isFavorite,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? fatPer100g,
    double? carbsPer100g,
    double? fiberPer100g,
    double? sugarPer100g,
    double? sodiumMgPer100g,
    @Default(false) bool showMoreMicronutrients,
    double? cholesterolMgPer100g,
    double? potassiumMgPer100g,
    double? calciumMgPer100g,
    double? ironMgPer100g,
    double? vitaminCMgPer100g,
    double? vitaminDMcgPer100g,
    @Default(true) bool logToMealEnabled,
    @Default(MealType.breakfast) MealType mealType,
    @Default(false) bool isSaving,
    @Default(false) bool isPickingPhoto,
    @Default(false) bool isScanningLabel,
    // null = not attempted yet; false = OCR ran but found no per-100g column.
    bool? ocrPer100gColumnFound,
    String? photoError,
    String? ocrError,
    String? saveError,
    // Set alongside a successful save; never blocks the save itself, but
    // AddProductScreen keeps the form open (instead of popping) while this
    // is non-null, so the user has a way to actually fix the value.
    String? macroMismatchWarning,
    Food? savedFood,
  }) = _AddProductFormState;
}
