import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../theme/dashboard_colors.dart';
import '../theme/dashboard_text_styles.dart';

/// Circular calorie gauge: consumed-of-target ring with the remaining
/// calories called out below.
class CalorieGaugeCard extends StatelessWidget {
  const CalorieGaugeCard({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    required this.progress,
  });

  final double consumedCalories;
  final double targetCalories;

  /// 0.0-1.0
  final double progress;

  @override
  Widget build(BuildContext context) {
    final remaining = targetCalories - consumedCalories;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
      decoration: BoxDecoration(
        color: DashboardColors.gaugeCardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 14,
            percent: progress,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: DashboardColors.gaugeTrack,
            progressColor: DashboardColors.primary,
            animation: true,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  consumedCalories.toStringAsFixed(0),
                  style: DashboardTextStyles.gaugeValue,
                ),
                const SizedBox(height: 5),
                Text(
                  'of ${targetCalories.toStringAsFixed(0)} kcal',
                  style: DashboardTextStyles.gaugeSub,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${remaining.toStringAsFixed(0)} kcal left today',
            style: DashboardTextStyles.gaugeRemaining,
          ),
        ],
      ),
    );
  }
}
