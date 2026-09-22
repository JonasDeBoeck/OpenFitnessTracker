import 'package:flutter/material.dart';

import '../../../../core/utils/number_format.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/water_day_view.dart';

/// Read-only droplet + "consumed / target mL" + progress bar, reused on
/// Home and Diary wherever the day's water is shown.
class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({super.key, required this.day});

  final WaterDayView day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: DashboardColors.waterCardBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 16,
                  color: DashboardColors.water,
                ),
              ),
              const SizedBox(width: 10),
              Text('Water', style: DashboardTextStyles.macroName),
              const Spacer(),
              Text(
                '${groupedInt(day.consumedMl)} / ${groupedInt(day.targetMl)} mL',
                style: DashboardTextStyles.macroNums,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: day.progress.toDouble(),
              minHeight: 8,
              backgroundColor: const Color(0xFFE4E0D0),
              valueColor: const AlwaysStoppedAnimation(DashboardColors.water),
            ),
          ),
        ],
      ),
    );
  }
}
