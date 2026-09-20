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

/// The flat kcal/day adjustment applied to TDEE for a [goal] (negative for
/// a deficit). Exposed publicly so UI explaining the calculation (e.g. the
/// home dashboard's targets tooltip) can display the real figure instead of
/// duplicating it.
double calorieAdjustmentFor(Goal goal) => switch (goal) {
  Goal.cut => -500,
  Goal.bulk => 300,
  Goal.maintain => 0,
};

double calculateTargetCalories({
  required double tdee,
  required Goal goal,
}) {
  return tdee + calorieAdjustmentFor(goal);
}

typedef Macros = ({double proteinGrams, double fatGrams, double carbGrams});

typedef MacroRates = ({double proteinPerKg, double fatPerKg});

/// Protein/fat targets per kg of bodyweight for a [goal]; carbs fill
/// whatever calories remain. Exposed publicly for the same reason as
/// [calorieAdjustmentFor].
MacroRates macroRatesFor(Goal goal) => switch (goal) {
  Goal.cut => (proteinPerKg: 2.2, fatPerKg: 0.9),
  Goal.bulk => (proteinPerKg: 1.8, fatPerKg: 1.0),
  Goal.maintain => (proteinPerKg: 2.0, fatPerKg: 1.0),
};

Macros calculateMacros({
  required double weightKg,
  required double targetCalories,
  required Goal goal,
}) {
  final rates = macroRatesFor(goal);

  final proteinGrams = rates.proteinPerKg * weightKg;
  final fatGrams = rates.fatPerKg * weightKg;
  final proteinCalories = proteinGrams * _kcalPerGramProtein;
  final fatCalories = fatGrams * _kcalPerGramFat;
  final carbCalories = targetCalories - proteinCalories - fatCalories;
  final carbGrams = carbCalories / _kcalPerGramCarb;

  return (proteinGrams: proteinGrams, fatGrams: fatGrams, carbGrams: carbGrams);
}

/// Daily water target via the Holliday-Segar formula: 100 mL/kg for the
/// first 10 kg, 50 mL/kg for the next 10 kg, and 20 mL/kg for every kg
/// above 20 kg.
double calculateWaterTargetMl({required double weightKg}) {
  if (weightKg <= 10) return weightKg * 100;
  if (weightKg <= 20) return 1000 + (weightKg - 10) * 50;
  return 1500 + (weightKg - 20) * 20;
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
  final waterTargetMl = calculateWaterTargetMl(weightKg: weightKg);

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
    waterTargetMl: waterTargetMl,
  );
}
