import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/food_logging/food_logging.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/providers/profile_providers.dart';
import '../../features/onboarding/presentation/wizard/onboarding_wizard_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../models/meal_type.dart';
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
      GoRoute(
        path: AppRoutes.profilePath,
        name: AppRoutes.profileName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.foodSearchPath,
        name: AppRoutes.foodSearchName,
        builder: (context, state) => FoodSearchScreen(mealType: state.extra as MealType?),
      ),
      GoRoute(
        path: AppRoutes.foodDetailPath,
        name: AppRoutes.foodDetailName,
        builder: (context, state) => FoodDetailScreen(
          foodId: int.parse(state.pathParameters['foodId']!),
          mealType: state.extra as MealType?,
        ),
      ),
      GoRoute(
        path: AppRoutes.browseFoodsPath,
        name: AppRoutes.browseFoodsName,
        builder: (context, state) => BrowseFoodsScreen(mealType: state.extra as MealType?),
      ),
      GoRoute(
        path: AppRoutes.addProductPath,
        name: AppRoutes.addProductName,
        builder: (context, state) => AddProductScreen(args: state.extra as AddProductLaunchArgs?),
      ),
      GoRoute(
        path: AppRoutes.scanBarcodePath,
        name: AppRoutes.scanBarcodeName,
        builder: (context, state) => const BarcodeScannerScreen(),
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
