import 'package:freezed_annotation/freezed_annotation.dart';

part 'food.freezed.dart';
part 'food.g.dart';

@freezed
abstract class Food with _$Food {
  const Food._();

  const factory Food({
    int? id,
    required String name,
    String? brand,
    String? store,
    String? barcode,
    String? photoPath,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? fatPer100g,
    double? carbsPer100g,
    double? fiberPer100g,
    double? sugarPer100g,
    double? sodiumMgPer100g,
    double? cholesterolMgPer100g,
    double? potassiumMgPer100g,
    double? calciumMgPer100g,
    double? ironMgPer100g,
    double? vitaminCMgPer100g,
    double? vitaminDMcgPer100g,
    @Default(false) bool isFavorite,
    DateTime? createdAt,
  }) = _Food;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  /// Scales every per-100g value by `grams / 100`. Calories/protein/fat/carbs
  /// coalesce a missing value to 0 so a diary entry always has real numbers
  /// to sum; micronutrients stay nullable (null means "no data", not zero).
  FoodNutrition scaledTo(double grams) {
    final factor = grams / 100;
    double? scaleNullable(double? value) => value == null ? null : value * factor;
    return FoodNutrition(
      calories: (caloriesPer100g ?? 0) * factor,
      protein: (proteinPer100g ?? 0) * factor,
      fat: (fatPer100g ?? 0) * factor,
      carbs: (carbsPer100g ?? 0) * factor,
      fiber: scaleNullable(fiberPer100g),
      sugar: scaleNullable(sugarPer100g),
      sodiumMg: scaleNullable(sodiumMgPer100g),
      cholesterolMg: scaleNullable(cholesterolMgPer100g),
      potassiumMg: scaleNullable(potassiumMgPer100g),
      calciumMg: scaleNullable(calciumMgPer100g),
      ironMg: scaleNullable(ironMgPer100g),
      vitaminCMg: scaleNullable(vitaminCMgPer100g),
      vitaminDMcg: scaleNullable(vitaminDMcgPer100g),
    );
  }
}

/// A food's nutrition values scaled to a specific quantity in grams.
class FoodNutrition {
  const FoodNutrition({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.fiber,
    this.sugar,
    this.sodiumMg,
    this.cholesterolMg,
    this.potassiumMg,
    this.calciumMg,
    this.ironMg,
    this.vitaminCMg,
    this.vitaminDMcg,
  });

  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double? fiber;
  final double? sugar;
  final double? sodiumMg;
  final double? cholesterolMg;
  final double? potassiumMg;
  final double? calciumMg;
  final double? ironMg;
  final double? vitaminCMg;
  final double? vitaminDMcg;
}
