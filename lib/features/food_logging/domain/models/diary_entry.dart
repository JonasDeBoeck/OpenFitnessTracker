import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/models/meal_type.dart';
import 'food.dart';

part 'diary_entry.freezed.dart';
part 'diary_entry.g.dart';

@freezed
abstract class DiaryEntry with _$DiaryEntry {
  const DiaryEntry._();

  const factory DiaryEntry({
    int? id,
    required int foodId,
    required String foodName,
    required MealType mealType,
    required DateTime loggedAt,
    required double quantityGrams,
    required double calories,
    required double protein,
    required double fat,
    required double carbs,
    double? fiber,
    double? sugar,
    double? sodiumMg,
    double? cholesterolMg,
    double? potassiumMg,
    double? calciumMg,
    double? ironMg,
    double? vitaminCMg,
    double? vitaminDMcg,
  }) = _DiaryEntry;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryFromJson(json);

  /// The single place per-100g values get scaled and snapshotted into a
  /// diary entry — both this factory and any live "scaled preview" UI
  /// should go through [Food.scaledTo] so the formula is defined once.
  factory DiaryEntry.snapshotFrom({
    required Food food,
    required double quantityGrams,
    required MealType mealType,
    required DateTime loggedAt,
  }) {
    final nutrition = food.scaledTo(quantityGrams);
    return DiaryEntry(
      foodId: food.id!,
      foodName: food.name,
      mealType: mealType,
      loggedAt: loggedAt,
      quantityGrams: quantityGrams,
      calories: nutrition.calories,
      protein: nutrition.protein,
      fat: nutrition.fat,
      carbs: nutrition.carbs,
      fiber: nutrition.fiber,
      sugar: nutrition.sugar,
      sodiumMg: nutrition.sodiumMg,
      cholesterolMg: nutrition.cholesterolMg,
      potassiumMg: nutrition.potassiumMg,
      calciumMg: nutrition.calciumMg,
      ironMg: nutrition.ironMg,
      vitaminCMg: nutrition.vitaminCMg,
      vitaminDMcg: nutrition.vitaminDMcg,
    );
  }
}
