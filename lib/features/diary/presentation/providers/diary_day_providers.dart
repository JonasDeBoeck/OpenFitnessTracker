import 'package:flutter/material.dart' show DateTimeRange, DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/meal_type.dart';
import '../../../food_logging/data/diary_repository.dart';
import '../../../food_logging/domain/models/diary_entry.dart';
import '../../../food_logging/food_logging.dart';
import '../../../onboarding/onboarding.dart';
import '../../domain/models/diary_day_view.dart';

part 'diary_day_providers.g.dart';

/// Derives a single day's diary view-model from the persisted [UserProfile]
/// plus that day's diary entries. [date] is normalized to day-only before
/// being used as a cache key, so callers don't need to pre-normalize it.
/// Returns null while there is no profile yet.
@riverpod
Future<DiaryDayView?> diaryDay(Ref ref, DateTime date) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final entries = await ref.watch(
    diaryEntriesForDateProvider(DateUtils.dateOnly(date)).future,
  );

  double sumCalories(Iterable<DiaryEntry> es) =>
      es.fold(0, (sum, e) => sum + e.calories);
  double sumBy(Iterable<DiaryEntry> es, double Function(DiaryEntry) selector) =>
      es.fold(0, (sum, e) => sum + selector(e));

  return DiaryDayView(
    goal: profile.goal,
    targetCalories: profile.targetCalories,
    consumedCalories: sumCalories(entries),
    macros: DiaryDayView.macrosFor(
      proteinGrams: profile.proteinGrams,
      fatGrams: profile.fatGrams,
      carbGrams: profile.carbGrams,
      consumedProteinGrams: entries.fold(0, (sum, e) => sum + e.protein),
      consumedFatGrams: entries.fold(0, (sum, e) => sum + e.fat),
      consumedCarbGrams: entries.fold(0, (sum, e) => sum + e.carbs),
    ),
    meals: MealType.values.map((type) {
      final mealEntries = entries.where((e) => e.mealType == type).toList();
      return MealSection(
        type: type,
        consumedCalories: sumCalories(mealEntries),
        proteinGrams: sumBy(mealEntries, (e) => e.protein),
        fatGrams: sumBy(mealEntries, (e) => e.fat),
        carbGrams: sumBy(mealEntries, (e) => e.carbs),
        items: [
          for (final entry in mealEntries)
            MealFoodItem(name: entry.displayName, calories: entry.calories),
        ],
      );
    }).toList(),
  );
}

/// The distinct dates within [range] that have at least one logged entry —
/// backs the "has entries" dots on the diary calendar.
@riverpod
Future<Set<DateTime>> loggedDatesInRange(Ref ref, DateTimeRange range) {
  return ref
      .watch(diaryRepositoryProvider)
      .getLoggedDatesInRange(range.start, range.end);
}
