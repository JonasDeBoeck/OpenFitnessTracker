import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/providers/profile_providers.dart';
import '../../features/onboarding/presentation/wizard/onboarding_wizard_screen.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.homePath,
    routes: [
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPath,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingWizardScreen(),
      ),
    ],
    redirect: (context, state) async {
      final hasProfile =
          await ref.read(currentProfileProvider.future) != null;
      final atOnboarding = state.matchedLocation == AppRoutes.onboardingPath;

      if (!hasProfile && !atOnboarding) return AppRoutes.onboardingPath;
      if (hasProfile && atOnboarding) return AppRoutes.homePath;
      return null;
    },
  );
}
