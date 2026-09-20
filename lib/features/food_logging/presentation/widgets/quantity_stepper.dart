import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';

/// Grams-quantity control shared by the food detail screen. There is no
/// serving-size concept in this app — every food is per-100g, so this just
/// adjusts how many grams of it are being logged.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.grams,
    required this.onChanged,
  });

  final double grams;
  final ValueChanged<double> onChanged;

  static const double _stepGrams = 25;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quantity', style: DashboardTextStyles.macroName),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove,
                onTap: () => onChanged((grams - _stepGrams).clamp(0, double.infinity)),
              ),
              SizedBox(
                width: 64,
                child: Text(
                  '${grams.toStringAsFixed(0)} g',
                  textAlign: TextAlign.center,
                  style: DashboardTextStyles.macroName,
                ),
              ),
              _StepButton(icon: Icons.add, onTap: () => onChanged(grams + _stepGrams)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(side: BorderSide(color: DashboardColors.primary, width: 1.5)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: DashboardColors.primary),
        ),
      ),
    );
  }
}
