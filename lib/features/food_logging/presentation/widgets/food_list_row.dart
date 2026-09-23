import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';
import 'food_thumbnail.dart';

/// One food in a list — used by search results, Recent, Favorites, and
/// Browse all foods. Shows the name, per-100g calories, a toggleable
/// favorite star, and (when [onQuickAdd] is given) a quick-add button that
/// logs the food directly without opening its detail screen.
class FoodListRow extends StatelessWidget {
  const FoodListRow({
    super.key,
    required this.food,
    required this.onTap,
    required this.onToggleFavorite,
    this.onQuickAdd,
    this.borderRadius = 16,
  });

  final Food food;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onQuickAdd;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final kcalLabel = food.caloriesPer100g == null
        ? '— kcal/100g'
        : '${food.caloriesPer100g!.toStringAsFixed(0)} kcal/100g';
    final subtitle = [food.brand, food.store].whereType<String>().join(' · ');

    return Material(
      color: DashboardColors.card,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              FoodThumbnail(photoPath: food.photoPath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: DashboardTextStyles.mealTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle.isNotEmpty)
                      Text(subtitle, style: DashboardTextStyles.mealKcal, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Text(kcalLabel, style: DashboardTextStyles.mealItemKcal),
              IconButton(
                icon: Icon(
                  food.isFavorite ? Icons.star : Icons.star_border,
                  color: food.isFavorite
                      ? DashboardColors.macroFat
                      : DashboardColors.textMuted,
                ),
                tooltip: food.isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                onPressed: onToggleFavorite,
              ),
              if (onQuickAdd != null) ...[
                const SizedBox(width: 4),
                _QuickAddButton(onTap: onQuickAdd!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The 28px green "+" quick-add button shown alongside the favorite star.
class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add to log',
      child: Material(
        color: DashboardColors.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 28,
            height: 28,
            child: Icon(Icons.add, size: 14, color: DashboardColors.surface),
          ),
        ),
      ),
    );
  }
}
