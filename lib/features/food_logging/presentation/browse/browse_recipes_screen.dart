import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/recipe.dart';
import '../providers/browse_recipes_providers.dart';
import '../providers/recipe_favorite_toggle_notifier.dart';
import '../widgets/recipe_list_row.dart';

/// Every recipe in the catalog, sectioned alphabetically by first letter —
/// the recipe counterpart of [BrowseFoodsScreen].
class BrowseRecipesScreen extends ConsumerWidget {
  const BrowseRecipesScreen({super.key, this.mealType});

  final MealType? mealType;

  void _openRecipe(BuildContext context, Recipe recipe) {
    context.push('/log-food/recipe/${recipe.id}', extra: mealType);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(recipesGroupedAlphabeticallyProvider);

    return Scaffold(
      backgroundColor: DashboardColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 24, 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All recipes', style: DashboardTextStyles.topbarTitle.copyWith(fontSize: 20)),
                      groupedAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (error, _) => const SizedBox.shrink(),
                        data: (grouped) {
                          final count = grouped.values.fold<int>(0, (sum, items) => sum + items.length);
                          return Text('$count items · A–Z', style: DashboardTextStyles.mealKcal);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: groupedAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Could not load recipes: $error')),
                data: (grouped) {
                  if (grouped.isEmpty) {
                    return Center(
                      child: Text(
                        'No recipes yet — create one from Log food.',
                        style: DashboardTextStyles.mealEmpty,
                      ),
                    );
                  }
                  final letters = grouped.keys.toList()..sort();
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    children: [
                      for (final letter in letters) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 10, 4, 2),
                          child: Text(
                            letter,
                            style: DashboardTextStyles.sectionTitle.copyWith(
                              fontSize: 13,
                              color: DashboardColors.primary,
                            ),
                          ),
                        ),
                        for (final recipe in grouped[letter]!) ...[
                          RecipeListRow(
                            recipe: recipe,
                            onTap: () => _openRecipe(context, recipe),
                            onToggleFavorite: () =>
                                ref.read(recipeFavoriteToggleProvider.notifier).toggle(recipe.id!),
                            borderRadius: 14,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
