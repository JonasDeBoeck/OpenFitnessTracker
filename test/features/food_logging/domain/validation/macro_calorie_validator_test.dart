import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/validation/macro_calorie_validator.dart';

void main() {
  group('macrosRoughlyMatchCalories', () {
    test('matches when macros account for calories within 20%', () {
      // 20p*4 + 20c*4 + 5f*9 = 80+80+45 = 205, close to 200 stated.
      expect(
        macrosRoughlyMatchCalories(calories: 200, protein: 20, fat: 5, carbs: 20),
        isTrue,
      );
    });

    test('flags a mismatch beyond 20% variance', () {
      // 0p*4 + 0c*4 + 5f*9 = 45, vs. a stated 500 kcal — way off.
      expect(
        macrosRoughlyMatchCalories(calories: 500, protein: 0, fat: 5, carbs: 0),
        isFalse,
      );
    });

    test('is exactly on the 20% boundary (inclusive)', () {
      // 30p*4 + 0c*4 + 0f*9 = 120, vs. a stated 100 kcal -> variance exactly 0.20
      expect(
        macrosRoughlyMatchCalories(calories: 100, protein: 30, fat: 0, carbs: 0),
        isTrue,
      );
    });

    test('skips the check when any value is null', () {
      expect(
        macrosRoughlyMatchCalories(calories: null, protein: 10, fat: 5, carbs: 20),
        isTrue,
      );
      expect(
        macrosRoughlyMatchCalories(calories: 500, protein: null, fat: 5, carbs: 20),
        isTrue,
      );
    });

    test('skips the check when calories is zero', () {
      expect(
        macrosRoughlyMatchCalories(calories: 0, protein: 10, fat: 5, carbs: 20),
        isTrue,
      );
    });
  });
}
