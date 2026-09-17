import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../onboarding/onboarding.dart';
import '../../domain/greeting.dart';
import 'home_dashboard_view.dart';

part 'home_dashboard_providers.g.dart';

/// Derives the home dashboard's view-model from the persisted [UserProfile].
/// Returns null while there is no profile yet (the router redirects to
/// onboarding in that case, so this is mostly defensive).
@riverpod
Future<HomeDashboardView?> homeDashboard(Ref ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final now = DateTime.now();

  return HomeDashboardView(
    greeting: greetingForHour(now.hour),
    name: profile.name,
    dateLabel: formatFriendlyDate(now),
    goal: profile.goal,
    targetCalories: profile.targetCalories,
    consumedCalories: 0,
    macros: HomeDashboardView.macrosFor(
      proteinGrams: profile.proteinGrams,
      fatGrams: profile.fatGrams,
      carbGrams: profile.carbGrams,
    ),
    meals: HomeDashboardView.emptyMeals(),
  );
}
