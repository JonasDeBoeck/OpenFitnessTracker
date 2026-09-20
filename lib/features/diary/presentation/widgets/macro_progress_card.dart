import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/diary_day_view.dart';

/// Protein/fat/carb progress bars against their daily targets.
class MacroProgressCard extends StatelessWidget {
  const MacroProgressCard({super.key, required this.macros});

  final List<MacroProgress> macros;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (var i = 0; i < macros.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            _MacroBar(macro: macros[i]),
          ],
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({required this.macro});

  final MacroProgress macro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: macro.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(macro.name, style: DashboardTextStyles.macroName),
              ],
            ),
            Text(
              '${macro.consumedGrams.toStringAsFixed(0)} / ${macro.targetGrams.toStringAsFixed(1)} g',
              style: DashboardTextStyles.macroNums,
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: macro.percent.toDouble(),
            minHeight: 8,
            backgroundColor: const Color(0xFFE4E0D0),
            valueColor: AlwaysStoppedAnimation(macro.color),
          ),
        ),
      ],
    );
  }
}
