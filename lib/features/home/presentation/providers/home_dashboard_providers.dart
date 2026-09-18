import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/meal_type.dart';
import '../../../food_logging/domain/models/diary_entry.dart';
import '../../../food_logging/food_logging.dart';
import '../../../onboarding/onboarding.dart';
import '../../domain/greeting.dart';
import 'home_dashboard_view.dart';

part 'home_dashboard_providers.g.dart';

/// Derives the home dashboard's view-model from the persisted [UserProfile]
/// plus today's diary entries. Returns null while there is no profile yet
/// (the router redirects to onboarding in that case, so this is mostly
/// defensive).
@riverpod
Future<HomeDashboardView?> homeDashboard(Ref ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final now = DateTime.now();
  final entries = await ref.watch(
    diaryEntriesForDateProvider(DateUtils.dateOnly(now)).future,
  );

  double sumCalories(Iterable<DiaryEntry> es) =>
      es.fold(0, (sum, e) => sum + e.calories);

  return HomeDashboardView(
    greeting: greetingForHour(now.hour),
    name: profile.name,
    dateLabel: formatFriendlyDate(now),
    goal: profile.goal,
    targetCalories: profile.targetCalories,
    consumedCalories: sumCalories(entries),
    macros: HomeDashboardView.macrosFor(
      proteinGrams: profile.proteinGrams,
      fatGrams: profile.fatGrams,
      carbGrams: profile.carbGrams,
      consumedProteinGrams: entries.fold(0, (sum, e) => sum + e.protein),
      consumedFatGrams: entries.fold(0, (sum, e) => sum + e.fat),
      consumedCarbGrams: entries.fold(0, (sum, e) => sum + e.carbs),
    ),
    meals: [
      for (final type in MealType.values)
        MealSection(
          type: type,
          consumedCalories: sumCalories(entries.where((e) => e.mealType == type)),
          items: [
            for (final entry in entries.where((e) => e.mealType == type))
              MealFoodItem(name: entry.foodName, calories: entry.calories),
          ],
        ),
    ],
  );
}
