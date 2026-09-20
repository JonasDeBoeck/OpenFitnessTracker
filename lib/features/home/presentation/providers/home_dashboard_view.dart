import 'package:flutter/material.dart';

import '../../../../core/models/meal_type.dart';
import '../../../onboarding/domain/models/goal.dart';
import '../theme/dashboard_colors.dart';

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

/// A single logged food item within a meal. Nothing populates this yet —
/// the shape is here so a future food-logging feature can slot in.
class MealFoodItem {
  const MealFoodItem({required this.name, required this.calories});

  final String name;
  final double calories;
}

/// One meal's section of the dashboard.
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

/// Fully derived view-model for the home dashboard, built from the user's
/// [UserProfile] targets. Consumed values are 0 until a food-logging
/// feature exists to populate them.
class HomeDashboardView {
  const HomeDashboardView({
    required this.greeting,
    required this.name,
    required this.dateLabel,
    required this.goal,
    required this.targetCalories,
    required this.consumedCalories,
    required this.macros,
    required this.meals,
  });

  final String greeting;
  final String name;
  final String dateLabel;
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
