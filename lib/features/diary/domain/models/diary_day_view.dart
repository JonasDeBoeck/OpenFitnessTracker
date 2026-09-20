import 'package:flutter/material.dart';

import '../../../../core/models/meal_type.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../onboarding/domain/models/goal.dart';

/// One macro's progress against its daily target.
class MacroProgress {
  const MacroProgress({
    required this.name,
    required this.color,
    required this.consumedGrams,
    required this.targetGrams,
  });

  final String name;
  final Color color;
  final double consumedGrams;
  final double targetGrams;

  double get percent =>
      targetGrams <= 0 ? 0 : (consumedGrams / targetGrams).clamp(0, 1);
}

/// A single logged food item within a meal.
class MealFoodItem {
  const MealFoodItem({required this.name, required this.calories});

  final String name;
  final double calories;
}

/// One meal's section of a day overview.
class MealSection {
  const MealSection({
    required this.type,
    required this.consumedCalories,
    required this.items,
  });

  final MealType type;
  final double consumedCalories;
  final List<MealFoodItem> items;
}

/// Fully derived view-model for a single day's diary: the user's targets
/// (from their [UserProfile]) plus that day's logged entries, grouped by
/// meal. Used for both the Diary screen (any date) and the Home dashboard
/// (today only).
class DiaryDayView {
  const DiaryDayView({
    required this.goal,
    required this.targetCalories,
    required this.consumedCalories,
    required this.macros,
    required this.meals,
  });

  final Goal goal;
  final double targetCalories;
  final double consumedCalories;
  final List<MacroProgress> macros;
  final List<MealSection> meals;

  double get remainingCalories => targetCalories - consumedCalories;

  double get calorieProgress =>
      targetCalories <= 0 ? 0 : (consumedCalories / targetCalories).clamp(0, 1);

  static List<MacroProgress> macrosFor({
    required double proteinGrams,
    required double fatGrams,
    required double carbGrams,
    required double consumedProteinGrams,
    required double consumedFatGrams,
    required double consumedCarbGrams,
  }) => [
    MacroProgress(
      name: 'Protein',
      color: DashboardColors.macroProtein,
      consumedGrams: consumedProteinGrams,
      targetGrams: proteinGrams,
    ),
    MacroProgress(
      name: 'Fat',
      color: DashboardColors.macroFat,
      consumedGrams: consumedFatGrams,
      targetGrams: fatGrams,
    ),
    MacroProgress(
      name: 'Carbs',
      color: DashboardColors.macroCarb,
      consumedGrams: consumedCarbGrams,
      targetGrams: carbGrams,
    ),
  ];
}
