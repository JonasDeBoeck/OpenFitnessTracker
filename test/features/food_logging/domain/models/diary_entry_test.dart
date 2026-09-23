import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/core/models/meal_type.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/diary_entry.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/food.dart';

void main() {
  group('DiaryEntry.snapshotFrom', () {
    const food = Food(id: 1, name: 'Carrot', caloriesPer100g: 41);
    final loggedAt = DateTime(2026, 1, 1);

    test('leaves loggedUnitLabel and loggedUnitCount null when not provided', () {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: 60,
        mealType: MealType.breakfast,
        loggedAt: loggedAt,
      );
      expect(entry.loggedUnitLabel, isNull);
      expect(entry.loggedUnitCount, isNull);
    });

    test('snapshots the unit and count actually logged', () {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: 120,
        mealType: MealType.breakfast,
        loggedAt: loggedAt,
        unitLabel: 'carrot',
        unitCount: 2,
      );
      expect(entry.loggedUnitLabel, 'carrot');
      expect(entry.loggedUnitCount, 2);
    });
  });
}
