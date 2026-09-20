import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../diary/diary.dart';
import '../../../onboarding/onboarding.dart';
import '../../domain/greeting.dart';
import 'home_dashboard_view.dart';

part 'home_dashboard_providers.g.dart';

/// Derives the home dashboard's view-model: today's [DiaryDayView] (shared
/// with the Diary screen) plus a time-of-day greeting and formatted date.
/// Returns null while there is no profile yet (the router redirects to
/// onboarding in that case, so this is mostly defensive).
@riverpod
Future<HomeDashboardView?> homeDashboard(Ref ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final now = DateTime.now();
  final day = await ref.watch(
    diaryDayProvider(DateUtils.dateOnly(now)).future,
  );
  if (day == null) return null;

  return HomeDashboardView(
    greeting: greetingForHour(now.hour),
    name: profile.name,
    dateLabel: formatFriendlyDate(now),
    goal: day.goal,
    targetCalories: day.targetCalories,
    consumedCalories: day.consumedCalories,
    macros: day.macros,
    meals: day.meals,
  );
}
