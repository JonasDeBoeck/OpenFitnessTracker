import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/exit_confirmation_scope.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../providers/trends_providers.dart';
import '../widgets/trends_line_chart_card.dart';
import '../widgets/trends_range_selector.dart';

class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(selectedTrendsRangeProvider);
    final trendsAsync = ref.watch(trendsProvider(range));

    return ExitConfirmationScope(
      child: Scaffold(
        backgroundColor: DashboardColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Trends', style: DashboardTextStyles.greeting),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TrendsRangeSelector(
                        value: range,
                        onChanged: (r) => ref
                            .read(selectedTrendsRangeProvider.notifier)
                            .select(r),
                      ),
                      const SizedBox(height: 20),
                      trendsAsync.when(
                        loading: () => const _CenteredLoading(),
                        error: (error, stackTrace) =>
                            _CenteredMessage('Could not load trends: $error'),
                        data: (trends) {
                          if (trends == null) {
                            return const _CenteredMessage('No profile yet.');
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TrendsLineChartCard(
                                title: 'Calories',
                                color: DashboardColors.textPrimary,
                                dailyTotals: trends.dailyTotals,
                                valueOf: (d) => d.calories,
                                target: trends.targetCalories,
                                average: trends.avgCalories,
                                unit: ' kcal',
                              ),
                              const SizedBox(height: 20),
                              TrendsLineChartCard(
                                title: 'Protein',
                                color: DashboardColors.macroProtein,
                                dailyTotals: trends.dailyTotals,
                                valueOf: (d) => d.protein,
                                target: trends.targetProtein,
                                average: trends.avgProtein,
                                unit: 'g',
                              ),
                              const SizedBox(height: 20),
                              TrendsLineChartCard(
                                title: 'Fat',
                                color: DashboardColors.macroFat,
                                dailyTotals: trends.dailyTotals,
                                valueOf: (d) => d.fat,
                                target: trends.targetFat,
                                average: trends.avgFat,
                                unit: 'g',
                              ),
                              const SizedBox(height: 20),
                              TrendsLineChartCard(
                                title: 'Carbs',
                                color: DashboardColors.macroCarb,
                                dailyTotals: trends.dailyTotals,
                                valueOf: (d) => d.carbs,
                                target: trends.targetCarbs,
                                average: trends.avgCarbs,
                                unit: 'g',
                              ),
                              const SizedBox(height: 20),
                              TrendsLineChartCard(
                                title: 'Water',
                                color: DashboardColors.water,
                                dailyTotals: trends.dailyTotals,
                                valueOf: (d) => d.waterMl,
                                target: trends.targetWaterMl,
                                average: trends.avgWaterMl,
                                unit: ' mL',
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const AppBottomNavBar(currentTab: AppNavTab.trends),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenteredLoading extends StatelessWidget {
  const _CenteredLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(child: Text(message)),
    );
  }
}
