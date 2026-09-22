import 'package:flutter/material.dart';

import '../../../../core/models/meal_type.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../food_logging/domain/models/diary_entry.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/diary_day_view.dart';

IconData _iconFor(MealType type) => switch (type) {
  MealType.breakfast => Icons.wb_sunny_outlined,
  MealType.lunch => Icons.lunch_dining_outlined,
  MealType.dinner => Icons.nightlight_outlined,
  MealType.snacks => Icons.eco_outlined,
};

/// One meal's card: icon + title + kcal summary, its logged items (or an
/// empty state), and a button to add food to it.
class MealSectionCard extends StatelessWidget {
  const MealSectionCard({
    super.key,
    required this.meal,
    required this.onAddFood,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  final MealSection meal;
  final VoidCallback onAddFood;
  final ValueChanged<int> onDeleteItem;
  final ValueChanged<DiaryEntry> onEditItem;

  @override
  Widget build(BuildContext context) {
    final hasItems = meal.items.isNotEmpty;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: DashboardColors.surface,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  _iconFor(meal.type),
                  size: 19,
                  color: DashboardColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.type.label, style: DashboardTextStyles.mealTitle),
                    Text(
                      hasItems
                          ? '${meal.consumedCalories.toStringAsFixed(0)} kcal'
                          : '0 kcal logged',
                      style: DashboardTextStyles.mealKcal,
                    ),
                    if (hasItems) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          _MealMacroChip(
                            color: DashboardColors.macroProtein,
                            grams: meal.proteinGrams,
                          ),
                          const SizedBox(width: 10),
                          _MealMacroChip(
                            color: DashboardColors.macroFat,
                            grams: meal.fatGrams,
                          ),
                          const SizedBox(width: 10),
                          _MealMacroChip(
                            color: DashboardColors.macroCarb,
                            grams: meal.carbGrams,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasItems)
            Column(
              spacing: 8,
              children: [
                for (final item in meal.items)
                  Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 14),
                      decoration: BoxDecoration(
                        color: DashboardColors.destructive,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    confirmDismiss: (_) => showConfirmDeleteDialog(
                      context,
                      title: 'Delete this item?',
                      message: '${item.displayName} will be removed from your log.',
                    ),
                    onDismissed: (_) => onDeleteItem(item.id!),
                    child: Material(
                      color: DashboardColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => onEditItem(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.displayName,
                                    style: DashboardTextStyles.mealItemName,
                                  ),
                                  Text(
                                    '${item.quantityGrams.toStringAsFixed(0)} g',
                                    style: DashboardTextStyles.mealItemGrams,
                                  ),
                                ],
                              ),
                              Text(
                                '${item.calories.toStringAsFixed(0)} kcal',
                                style: DashboardTextStyles.mealItemKcal,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          else
            Text('Nothing logged yet', style: DashboardTextStyles.mealEmpty),
          const SizedBox(height: 12),
          _AddFoodButton(onTap: onAddFood),
        ],
      ),
    );
  }
}

class _MealMacroChip extends StatelessWidget {
  const _MealMacroChip({required this.color, required this.grams});

  final Color color;
  final double grams;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text('${grams.toStringAsFixed(0)}g', style: DashboardTextStyles.mealMacroChip),
      ],
    );
  }
}

class _AddFoodButton extends StatelessWidget {
  const _AddFoodButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: CustomPaint(
          painter: _DashedRoundedBorderPainter(
            color: const Color(0xFFC7C2AC),
            radius: 12,
          ),
          child: SizedBox(
            height: 40,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, size: 15, color: DashboardColors.primary),
                const SizedBox(width: 6),
                Text('Add food', style: DashboardTextStyles.addFoodButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _strokeWidth = 1.5;
  static const double _dashWidth = 5;
  static const double _dashGap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
