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
      backgroundColor: DashboardColors.pageBackground,
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
                  Text('All recipes', style: DashboardTextStyles.greeting),
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(letter, style: DashboardTextStyles.sectionTitle),
                        ),
                        for (final recipe in grouped[letter]!) ...[
                          RecipeListRow(
                            recipe: recipe,
                            onTap: () => _openRecipe(context, recipe),
                            onToggleFavorite: () =>
                                ref.read(recipeFavoriteToggleProvider.notifier).toggle(recipe.id!),
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
