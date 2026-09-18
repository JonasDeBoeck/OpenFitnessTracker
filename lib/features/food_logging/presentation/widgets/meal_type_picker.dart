import 'package:flutter/material.dart';

import '../../../../core/models/meal_type.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';

/// Row of meal-type pills shared by the food detail and add-product
/// screens.
class MealTypePicker extends StatelessWidget {
  const MealTypePicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MealType selected;
  final ValueChanged<MealType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final type in MealType.values)
          _MealPill(
            label: type.label,
            active: type == selected,
            onTap: () => onSelected(type),
          ),
      ],
    );
  }
}

class _MealPill extends StatelessWidget {
  const _MealPill({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: active ? DashboardColors.primary : DashboardColors.border,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.addFoodButton.copyWith(
              color: active ? DashboardColors.surface : DashboardColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
