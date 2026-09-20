import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../food_logging/data/diary_repository.dart';
import '../../../onboarding/onboarding.dart';
import '../../../water/data/water_repository.dart';
import '../../domain/aggregate_daily_totals.dart';
import '../../domain/models/trends_range.dart';
import '../../domain/models/trends_view.dart';

part 'trends_providers.g.dart';

/// Which range the Trends screen is currently showing. Defaults to 7 days.
@riverpod
class SelectedTrendsRange extends _$SelectedTrendsRange {
  @override
  TrendsRange build() => TrendsRange.sevenDays;

  void select(TrendsRange range) => state = range;
}

/// Derives the Trends view-model for [range] from the persisted
/// [UserProfile]'s targets plus the diary entries logged within it. Returns
/// null while there is no profile yet.
@riverpod
Future<TrendsView?> trends(Ref ref, TrendsRange range) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final today = DateUtils.dateOnly(DateTime.now());
  final lookback = range.lookback;
  final start = lookback == null
      ? DateUtils.dateOnly(profile.createdAt ?? today)
      : today.subtract(lookback);

  final entries = await ref
      .watch(diaryRepositoryProvider)
      .getEntriesInRange(start, today);
  final waterEntries = await ref
      .watch(waterRepositoryProvider)
      .getEntriesInRange(start, today);

  final dailyTotals = aggregateDailyTotals(
    entries: entries,
    waterEntries: waterEntries,
    start: start,
    end: today,
  );

  return TrendsView(
    range: range,
    targetCalories: profile.targetCalories,
    targetProtein: profile.proteinGrams,
    targetFat: profile.fatGrams,
    targetCarbs: profile.carbGrams,
    targetWaterMl: profile.waterTargetMl,
    dailyTotals: dailyTotals,
  );
}
