import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/food.dart';

void main() {
  group('Food.scaledTo', () {
    test('scales per-100g values proportionally to the given grams', () {
      const food = Food(
        name: 'Test food',
        caloriesPer100g: 200,
        proteinPer100g: 20,
        fatPer100g: 10,
        carbsPer100g: 30,
        fiberPer100g: 5,
      );

      final nutrition = food.scaledTo(150);

      expect(nutrition.calories, 300);
      expect(nutrition.protein, 30);
      expect(nutrition.fat, 15);
      expect(nutrition.carbs, 45);
      expect(nutrition.fiber, 7.5);
    });

    test('coalesces missing macros to zero but leaves micronutrients null', () {
      const food = Food(name: 'Unknown macros');

      final nutrition = food.scaledTo(200);

      expect(nutrition.calories, 0);
      expect(nutrition.protein, 0);
      expect(nutrition.fat, 0);
      expect(nutrition.carbs, 0);
      expect(nutrition.fiber, isNull);
      expect(nutrition.sodiumMg, isNull);
    });

    test('scaling to 0 grams gives 0 for every macro', () {
      const food = Food(name: 'Anything', caloriesPer100g: 500);

      expect(food.scaledTo(0).calories, 0);
    });
  });
}
