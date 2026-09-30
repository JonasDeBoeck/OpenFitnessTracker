import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/food.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/quantity/alternate_unit.dart';

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

  group('Food.hasPieceUnit', () {
    test('is true when both pieceLabel and pieceWeightGrams are set', () {
      const food = Food(name: 'Carrot', pieceLabel: 'carrot', pieceWeightGrams: 60);
      expect(food.hasPieceUnit, isTrue);
    });

    test('is false when neither is set', () {
      const food = Food(name: 'Rice');
      expect(food.hasPieceUnit, isFalse);
    });

    test('is false when only the label is set', () {
      const food = Food(name: 'Carrot', pieceLabel: 'carrot');
      expect(food.hasPieceUnit, isFalse);
    });

    test('is false when only the weight is set', () {
      const food = Food(name: 'Carrot', pieceWeightGrams: 60);
      expect(food.hasPieceUnit, isFalse);
    });
  });

  group('Food.hasVolumeUnit', () {
    test('is true when mlDensityGramsPerMl is set', () {
      const food = Food(name: 'Milk', mlDensityGramsPerMl: 1.03);
      expect(food.hasVolumeUnit, isTrue);
    });

    test('is false when unset', () {
      const food = Food(name: 'Rice');
      expect(food.hasVolumeUnit, isFalse);
    });
  });

  group('Food.alternateUnit', () {
    test('returns the piece flavor when only piece fields are set', () {
      const food = Food(name: 'Carrot', pieceLabel: 'carrot', pieceWeightGrams: 60);
      final unit = food.alternateUnit;
      expect(unit, isNotNull);
      expect(unit!.label, 'carrot');
      expect(unit.weightPerUnitGrams, 60);
      expect(unit.step, 1);
      expect(unit.pluralize, isTrue);
    });

    test('returns the volume flavor when only mlDensityGramsPerMl is set', () {
      const food = Food(name: 'Milk', mlDensityGramsPerMl: 1.03);
      final unit = food.alternateUnit;
      expect(unit, isNotNull);
      expect(unit!.label, mlUnitLabel);
      expect(unit.weightPerUnitGrams, 1.03);
      expect(unit.step, 50);
      expect(unit.pluralize, isFalse);
    });

    test('is null when neither is set', () {
      const food = Food(name: 'Rice');
      expect(food.alternateUnit, isNull);
    });

    test('prefers the piece flavor when both are somehow set', () {
      const food = Food(
        name: 'Weird',
        pieceLabel: 'carrot',
        pieceWeightGrams: 60,
        mlDensityGramsPerMl: 1.03,
      );
      expect(food.alternateUnit!.label, 'carrot');
    });
  });
}
