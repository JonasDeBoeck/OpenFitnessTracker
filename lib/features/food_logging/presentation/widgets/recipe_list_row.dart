import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/recipe.dart';

/// One recipe in a list — used by the Log Food screen's Recipes mode,
/// Recent/Favorites, and Browse all recipes. The recipe counterpart of
/// [FoodListRow], showing up to two label chips and a servings/weight
/// summary instead of a per-100g calorie line.
class RecipeListRow extends StatelessWidget {
  const RecipeListRow({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  String get _meta {
    final grams = '${recipe.totalGrams.toStringAsFixed(0)} g total';
    return recipe.servings == null ? grams : '${recipe.servings} servings · $grams';
  }

  @override
  Widget build(BuildContext context) {
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
                      recipe.name,
                      style: DashboardTextStyles.mealTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (recipe.labels.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 2),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (final label in recipe.labels.take(2)) _LabelChip(label),
                          ],
                        ),
                      ),
                    Text(_meta, style: DashboardTextStyles.mealKcal),
                  ],
                ),
              ),
              Text(
                '${recipe.totalCalories.toStringAsFixed(0)} kcal',
                style: DashboardTextStyles.mealItemKcal,
              ),
              IconButton(
                icon: Icon(
                  recipe.isFavorite ? Icons.star : Icons.star_border,
                  color: recipe.isFavorite
                      ? DashboardColors.macroFat
                      : DashboardColors.textMuted,
                ),
                tooltip: recipe.isFavorite
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

class _LabelChip extends StatelessWidget {
  const _LabelChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: DashboardColors.gaugeCardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: DashboardTextStyles.macroNums.copyWith(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: DashboardColors.primaryDark,
        ),
      ),
    );
  }
}
