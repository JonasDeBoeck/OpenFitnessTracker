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
}
