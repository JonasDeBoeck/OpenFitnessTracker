import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';
import '../providers/browse_foods_providers.dart';
import '../providers/favorite_toggle_notifier.dart';
import '../widgets/food_list_row.dart';

/// Every food in the catalog, sectioned alphabetically by first letter.
class BrowseFoodsScreen extends ConsumerWidget {
  const BrowseFoodsScreen({super.key, this.mealType});

  final MealType? mealType;

  void _openFood(BuildContext context, Food food) {
    context.push('/log-food/food/${food.id}', extra: mealType);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(foodsGroupedAlphabeticallyProvider);

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All foods', style: DashboardTextStyles.topbarTitle.copyWith(fontSize: 20)),
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
                error: (error, _) => Center(child: Text('Could not load foods: $error')),
                data: (grouped) {
                  if (grouped.isEmpty) {
                    return Center(
                      child: Text(
                        'No foods yet — add one from Log food.',
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
                        for (final food in grouped[letter]!) ...[
                          FoodListRow(
                            food: food,
                            onTap: () => _openFood(context, food),
                            onToggleFavorite: () =>
                                ref.read(favoriteToggleProvider.notifier).toggle(food.id!),
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
