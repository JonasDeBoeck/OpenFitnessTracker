import 'package:flutter/material.dart';

import '../../../../core/models/meal_type.dart';
import '../providers/home_dashboard_view.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_text_styles.dart';

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
  });

  final MealSection meal;
  final VoidCallback onAddFood;

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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hasItems)
            Column(
              children: [
                for (final item in meal.items)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: DashboardColors.border),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name, style: DashboardTextStyles.mealItemName),
                        Text(
                          '${item.calories.toStringAsFixed(0)} kcal',
                          style: DashboardTextStyles.mealItemKcal,
                        ),
                      ],
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
