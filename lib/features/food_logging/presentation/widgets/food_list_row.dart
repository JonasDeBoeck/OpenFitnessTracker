import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';

/// One food in a list — used by search results, Recent, Favorites, and
/// Browse all foods. Shows the name, per-100g calories, and a toggleable
/// favorite star.
class FoodListRow extends StatelessWidget {
  const FoodListRow({
    super.key,
    required this.food,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Food food;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final kcalLabel = food.caloriesPer100g == null
        ? '— kcal/100g'
        : '${food.caloriesPer100g!.toStringAsFixed(0)} kcal/100g';

    return Material(
      color: DashboardColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: DashboardTextStyles.mealTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (food.brand != null)
                      Text(food.brand!, style: DashboardTextStyles.mealKcal),
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
            ],
          ),
        ),
      ),
    );
  }
}
