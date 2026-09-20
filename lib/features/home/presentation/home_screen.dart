import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/meal_type.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../diary/diary.dart';
import '../../water/water.dart';
import 'providers/home_dashboard_providers.dart';
import 'theme/dashboard_colors.dart';
import 'theme/dashboard_text_styles.dart';
import 'widgets/dashboard_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final today = DateUtils.dateOnly(DateTime.now());
    final waterDayAsync = ref.watch(waterDayProvider(today));

    return Scaffold(
      backgroundColor: DashboardColors.pageBackground,
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Could not load your dashboard: $error')),
          data: (dashboard) {
            if (dashboard == null) {
              return const Center(child: Text('No profile yet.'));
            }
            return Column(
              children: [
                DashboardHeader(
                  greeting: dashboard.greeting,
                  name: dashboard.name,
                  dateLabel: dashboard.dateLabel,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Today', style: DashboardTextStyles.sectionTitle),
                        const SizedBox(height: 14),
                        CalorieGaugeCard(
                          consumedCalories: dashboard.consumedCalories,
                          targetCalories: dashboard.targetCalories,
                          progress: dashboard.calorieProgress,
                        ),
                        const SizedBox(height: 20),
                        MacroProgressCard(macros: dashboard.macros),
                        const SizedBox(height: 20),
                        if (waterDayAsync.value case final waterDay?) ...[
                          WaterProgressCard(day: waterDay),
                          const SizedBox(height: 20),
                          WaterLogCard(
                            entries: waterDay.entries,
                            onQuickAdd: (ml) => ref
                                .read(waterLogControllerProvider.notifier)
                                .add(today, ml),
                            onCustomAdd: (ml) => ref
                                .read(waterLogControllerProvider.notifier)
                                .add(today, ml),
                            onDelete: (id) => ref
                                .read(waterLogControllerProvider.notifier)
                                .delete(today, id),
                          ),
                          const SizedBox(height: 20),
                        ],
                        for (var i = 0; i < dashboard.meals.length; i++) ...[
                          if (i > 0) const SizedBox(height: 20),
                          MealSectionCard(
                            meal: dashboard.meals[i],
                            onAddFood: () => _openAddFood(
                              context,
                              dashboard.meals[i].type,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const AppBottomNavBar(currentTab: AppNavTab.goals),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openAddFood(BuildContext context, MealType mealType) {
    context.push(AppRoutes.foodSearchPath, extra: mealType);
  }
}
