import 'package:freezed_annotation/freezed_annotation.dart';

import 'food.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

/// One ingredient of a [Recipe] — a quantity of an existing [Food], with
/// that food's per-100g macros snapshotted at the time it was added (like
/// [DiaryEntry] snapshots a food's nutrition at log time), so a recipe's
/// totals stay stable even if the underlying food is edited later.
@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  const RecipeIngredient._();

  const factory RecipeIngredient({
    int? id,
    required int foodId,
    required String foodName,
    required double grams,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double fatPer100g,
    required double carbsPer100g,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);

  factory RecipeIngredient.fromFood({required Food food, required double grams}) {
    return RecipeIngredient(
      foodId: food.id!,
      foodName: food.name,
      grams: grams,
      caloriesPer100g: food.caloriesPer100g ?? 0,
      proteinPer100g: food.proteinPer100g ?? 0,
      fatPer100g: food.fatPer100g ?? 0,
      carbsPer100g: food.carbsPer100g ?? 0,
    );
  }

  double get calories => caloriesPer100g * grams / 100;
  double get protein => proteinPer100g * grams / 100;
  double get fat => fatPer100g * grams / 100;
  double get carbs => carbsPer100g * grams / 100;
}

/// A combination of foods logged as one item — name, optional metadata
/// (labels, servings, prep/cook time, instructions, photo) and a list of
/// [RecipeIngredient]s that its aggregate nutrition is summed from.
///
/// Unlike [Food], a recipe has no stored per-100g macros of its own:
/// [caloriesPer100g] and friends are always derived from [ingredients], so
/// the aggregate is exposed with the same shape as a [Food] ([scaledTo])
/// and can be logged to the diary exactly like one — by weight — even when
/// [servings] is null.
@freezed
abstract class Recipe with _$Recipe {
  const Recipe._();

  const factory Recipe({
    int? id,
    required String name,
    @Default(<String>[]) List<String> labels,
    int? servings,
    String? prepTime,
    String? cookTime,
    @Default(<String>[]) List<String> instructions,
    String? photoPath,
    @Default(false) bool isFavorite,
    DateTime? createdAt,
    @Default(<RecipeIngredient>[]) List<RecipeIngredient> ingredients,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  double get totalGrams => ingredients.fold(0.0, (sum, i) => sum + i.grams);
  double get totalCalories => ingredients.fold(0.0, (sum, i) => sum + i.calories);
  double get totalProtein => ingredients.fold(0.0, (sum, i) => sum + i.protein);
  double get totalFat => ingredients.fold(0.0, (sum, i) => sum + i.fat);
  double get totalCarbs => ingredients.fold(0.0, (sum, i) => sum + i.carbs);

  double get caloriesPer100g => totalGrams == 0 ? 0 : totalCalories / totalGrams * 100;
  double get proteinPer100g => totalGrams == 0 ? 0 : totalProtein / totalGrams * 100;
  double get fatPer100g => totalGrams == 0 ? 0 : totalFat / totalGrams * 100;
  double get carbsPer100g => totalGrams == 0 ? 0 : totalCarbs / totalGrams * 100;

  /// Grams per serving, or null when [servings] hasn't been set — the one
  /// place that division happens, so screens never do it inline.
  double? get gramsPerServing => servings == null || servings == 0 ? null : totalGrams / servings!;

  /// Scales this recipe's aggregate per-100g profile to an arbitrary gram
  /// amount, mirroring [Food.scaledTo] so a recipe can be logged and
  /// displayed exactly like a food regardless of whether it has servings.
  FoodNutrition scaledTo(double grams) {
    final factor = grams / 100;
    return FoodNutrition(
      calories: caloriesPer100g * factor,
      protein: proteinPer100g * factor,
      fat: fatPer100g * factor,
      carbs: carbsPer100g * factor,
    );
  }
}
