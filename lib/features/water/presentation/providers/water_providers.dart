import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../onboarding/onboarding.dart';
import '../../data/water_repository.dart';
import '../../domain/models/water_day_view.dart';
import '../../domain/models/water_entry.dart';

part 'water_providers.g.dart';

@riverpod
Future<List<WaterEntry>> waterEntriesForDate(Ref ref, DateTime date) {
  return ref.watch(waterRepositoryProvider).getEntriesForDate(date);
}

/// Derives a single day's water view-model from the persisted
/// [UserProfile]'s target plus that day's logged entries. [date] is
/// normalized to day-only before being used as a cache key. Returns null
/// while there is no profile yet.
@riverpod
Future<WaterDayView?> waterDay(Ref ref, DateTime date) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final day = DateUtils.dateOnly(date);
  final entries = await ref.watch(waterEntriesForDateProvider(day).future);

  return WaterDayView(
    date: day,
    targetMl: profile.waterTargetMl,
    consumedMl: entries.fold(0, (sum, e) => sum + e.milliliters),
    entries: entries,
  );
}

/// Logs and deletes water entries for a given date, invalidating
/// [waterEntriesForDateProvider] (and therefore [waterDayProvider], which
/// watches it) so the UI reflects the change.
@riverpod
class WaterLogController extends _$WaterLogController {
  @override
  Future<void> build() async {}

  Future<void> add(DateTime date, double milliliters) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(waterRepositoryProvider)
          .insertEntry(WaterEntry(loggedAt: DateTime.now(), milliliters: milliliters));
      ref.invalidate(waterEntriesForDateProvider(DateUtils.dateOnly(date)));
    });
  }

  Future<void> delete(DateTime date, int entryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(waterRepositoryProvider).deleteEntry(entryId);
      ref.invalidate(waterEntriesForDateProvider(DateUtils.dateOnly(date)));
    });
  }
}
