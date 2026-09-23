import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/food.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/recipe.dart';

void main() {
  group('RecipeIngredient.fromFood', () {
    const food = Food(id: 1, name: 'Carrot', caloriesPer100g: 41);

    test('leaves unitLabel and unitCount null when not provided', () {
      final ingredient = RecipeIngredient.fromFood(food: food, grams: 60);
      expect(ingredient.unitLabel, isNull);
      expect(ingredient.unitCount, isNull);
    });

    test('snapshots the unit and count actually used', () {
      final ingredient = RecipeIngredient.fromFood(
        food: food,
        grams: 120,
        unitLabel: 'carrot',
        unitCount: 2,
      );
      expect(ingredient.unitLabel, 'carrot');
      expect(ingredient.unitCount, 2);
      expect(ingredient.grams, 120);
    });
  });
}
