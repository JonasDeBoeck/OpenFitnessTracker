import '../models/activity_level.dart';
import '../models/goal.dart';
import '../models/sex.dart';
import '../models/user_profile.dart';

const double _kcalPerGramProtein = 4;
const double _kcalPerGramFat = 9;
const double _kcalPerGramCarb = 4;

/// BMR via the Mifflin-St Jeor equation.
double calculateBmr({
  required Sex sex,
  required int age,
  required double heightCm,
  required double weightKg,
}) {
  final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
  return switch (sex) {
    Sex.male => base + 5,
    Sex.female => base - 161,
  };
}

double calculateTdee({
  required double bmr,
  required ActivityLevel activityLevel,
}) {
  return bmr * activityLevel.multiplier;
}

double calculateTargetCalories({
  required double tdee,
  required Goal goal,
}) {
  return switch (goal) {
    Goal.cut => tdee - 500,
    Goal.bulk => tdee + 300,
    Goal.maintain => tdee,
  };
}

typedef Macros = ({double proteinGrams, double fatGrams, double carbGrams});

Macros calculateMacros({
  required double weightKg,
  required double targetCalories,
  required Goal goal,
}) {
  final (proteinPerKg, fatPerKg) = switch (goal) {
    Goal.cut => (2.2, 0.9),
    Goal.bulk => (1.8, 1.0),
    Goal.maintain => (2.0, 1.0),
  };

  final proteinGrams = proteinPerKg * weightKg;
  final fatGrams = fatPerKg * weightKg;
  final proteinCalories = proteinGrams * _kcalPerGramProtein;
  final fatCalories = fatGrams * _kcalPerGramFat;
  final carbCalories = targetCalories - proteinCalories - fatCalories;
  final carbGrams = carbCalories / _kcalPerGramCarb;

  return (proteinGrams: proteinGrams, fatGrams: fatGrams, carbGrams: carbGrams);
}

/// Orchestrates BMR, TDEE, target calories and macros into a fully
/// populated [UserProfile]. Pure and deterministic: [id] and [createdAt]
/// are left null, as those are assigned by persistence.
UserProfile buildUserProfile({
  required String name,
  required Sex sex,
  required int age,
  required double heightCm,
  required double weightKg,
  required ActivityLevel activityLevel,
  required Goal goal,
}) {
  final bmr = calculateBmr(
    sex: sex,
    age: age,
    heightCm: heightCm,
    weightKg: weightKg,
  );
  final tdee = calculateTdee(bmr: bmr, activityLevel: activityLevel);
  final targetCalories = calculateTargetCalories(tdee: tdee, goal: goal);
  final macros = calculateMacros(
    weightKg: weightKg,
    targetCalories: targetCalories,
    goal: goal,
  );

  return UserProfile(
    name: name,
    sex: sex,
    age: age,
    heightCm: heightCm,
    weightKg: weightKg,
    activityLevel: activityLevel,
    goal: goal,
    bmr: bmr,
    tdee: tdee,
    targetCalories: targetCalories,
    proteinGrams: macros.proteinGrams,
    fatGrams: macros.fatGrams,
    carbGrams: macros.carbGrams,
  );
}
