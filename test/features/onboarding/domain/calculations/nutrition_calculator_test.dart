import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/onboarding/domain/calculations/nutrition_calculator.dart';
import 'package:open_fitness_tracker/features/onboarding/domain/models/activity_level.dart';
import 'package:open_fitness_tracker/features/onboarding/domain/models/goal.dart';
import 'package:open_fitness_tracker/features/onboarding/domain/models/sex.dart';

void main() {
  group('buildUserProfile', () {
    test('maintain: male, 30y, 180cm, 80kg, moderate activity', () {
      final profile = buildUserProfile(
        name: 'Alex',
        sex: Sex.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
      );

      expect(profile.name, 'Alex');
      expect(profile.bmr, closeTo(1780, 0.01));
      expect(profile.tdee, closeTo(2759, 0.01));
      expect(profile.targetCalories, closeTo(2759, 0.01));
      expect(profile.proteinGrams, closeTo(160, 0.01));
      expect(profile.fatGrams, closeTo(80, 0.01));
      expect(profile.carbGrams, closeTo(349.75, 0.01));
      expect(profile.waterTargetMl, closeTo(2700, 0.01));
    });

    test('bulk: male, 22y, 175cm, 65kg, active', () {
      final profile = buildUserProfile(
        name: 'Sam',
        sex: Sex.male,
        age: 22,
        heightCm: 175,
        weightKg: 65,
        activityLevel: ActivityLevel.active,
        goal: Goal.bulk,
      );

      expect(profile.bmr, closeTo(1638.75, 0.01));
      expect(profile.tdee, closeTo(2826.84, 0.01));
      expect(profile.targetCalories, closeTo(3126.84, 0.01));
      expect(profile.proteinGrams, closeTo(117, 0.01));
      expect(profile.fatGrams, closeTo(65, 0.01));
      expect(profile.carbGrams, closeTo(518.46, 0.01));
      expect(profile.waterTargetMl, closeTo(2400, 0.01));
    });

    test('female BMR uses the -161 offset', () {
      final bmr = calculateBmr(
        sex: Sex.female,
        age: 25,
        heightCm: 165,
        weightKg: 60,
      );

      expect(bmr, closeTo(1345.25, 0.01));
    });

    test('cut applies a 500 kcal deficit to TDEE', () {
      final target = calculateTargetCalories(tdee: 2500, goal: Goal.cut);
      expect(target, 2000);
    });
  });

  group('buildUserProfile custom overrides', () {
    test('a custom target calories value takes precedence over TDEE + adjustment', () {
      final profile = buildUserProfile(
        name: 'Alex',
        sex: Sex.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
        customTargetCalories: 2500,
      );

      // Calculated maintain target would be 2759 (tdee, no adjustment); the
      // custom value overrides it, and carbs fill against the custom value.
      expect(profile.targetCalories, 2500);
      expect(profile.customTargetCalories, 2500);
      expect(profile.proteinGrams, closeTo(160, 0.01)); // default 2.0 g/kg
      expect(profile.fatGrams, closeTo(80, 0.01)); // default 1.0 g/kg
      expect(profile.carbGrams, closeTo(285, 0.01)); // (2500-640-720)/4
    });

    test('custom protein/fat rates take precedence over the goal defaults', () {
      final profile = buildUserProfile(
        name: 'Alex',
        sex: Sex.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
        customProteinPerKg: 2.5,
        customFatPerKg: 0.8,
      );

      expect(profile.customProteinPerKg, 2.5);
      expect(profile.customFatPerKg, 0.8);
      expect(profile.proteinGrams, closeTo(200, 0.01)); // 2.5 * 80
      expect(profile.fatGrams, closeTo(64, 0.01)); // 0.8 * 80
      // Carbs still fill whatever calories remain against the (calculated)
      // target: (2759 - 800 - 576) / 4.
      expect(profile.carbGrams, closeTo(345.75, 0.01));
    });

    test('a custom water target takes precedence over Holliday-Segar', () {
      final profile = buildUserProfile(
        name: 'Alex',
        sex: Sex.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
        customWaterTargetMl: 3000,
      );

      // Calculated Holliday-Segar for 80kg would be 2700.
      expect(profile.waterTargetMl, 3000);
      expect(profile.customWaterTargetMl, 3000);
    });

    test('custom calories and custom rates combine, carbs still fill correctly', () {
      final profile = buildUserProfile(
        name: 'Alex',
        sex: Sex.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
        customTargetCalories: 2500,
        customProteinPerKg: 2.5,
        customFatPerKg: 0.8,
        customWaterTargetMl: 3000,
      );

      expect(profile.targetCalories, 2500);
      expect(profile.proteinGrams, closeTo(200, 0.01)); // 2.5 * 80
      expect(profile.fatGrams, closeTo(64, 0.01)); // 0.8 * 80
      // (2500 - 800 - 576) / 4
      expect(profile.carbGrams, closeTo(281, 0.01));
      expect(profile.waterTargetMl, 3000);
    });

    test('leaving overrides null keeps every field fully calculated', () {
      final profile = buildUserProfile(
        name: 'Alex',
        sex: Sex.male,
        age: 30,
        heightCm: 180,
        weightKg: 80,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
      );

      expect(profile.customTargetCalories, isNull);
      expect(profile.customProteinPerKg, isNull);
      expect(profile.customFatPerKg, isNull);
      expect(profile.customWaterTargetMl, isNull);
    });
  });

  group('calculateWaterTargetMl', () {
    test('weight at or under 10kg uses only the 100 mL/kg tier', () {
      expect(calculateWaterTargetMl(weightKg: 8), closeTo(800, 0.01));
      expect(calculateWaterTargetMl(weightKg: 10), closeTo(1000, 0.01));
    });

    test('weight between 10 and 20kg adds the 50 mL/kg tier', () {
      expect(calculateWaterTargetMl(weightKg: 15), closeTo(1250, 0.01));
      expect(calculateWaterTargetMl(weightKg: 20), closeTo(1500, 0.01));
    });

    test('weight above 20kg adds 20 mL/kg for the remainder', () {
      // 10*100 + 10*50 + 54*20 = 2580, the persona used across the app's
      // design canvas and onboarding screens.
      expect(calculateWaterTargetMl(weightKg: 74), closeTo(2580, 0.01));
    });
  });
}
