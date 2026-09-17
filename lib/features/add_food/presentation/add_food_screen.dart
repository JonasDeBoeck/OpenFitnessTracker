import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/domain/models/meal_type.dart';
import '../../home/presentation/theme/dashboard_colors.dart';
import '../../home/presentation/theme/dashboard_text_styles.dart';

/// Visual shell for adding food to a meal. Matches the design's search bar
/// and empty state, but has no food database or persistence yet — it's a
/// placeholder destination so the "Add food" buttons/FAB have somewhere to
/// go.
class AddFoodScreen extends StatelessWidget {
  const AddFoodScreen({super.key, this.mealType});

  final MealType? mealType;

  @override
  Widget build(BuildContext context) {
    final title = mealType == null
        ? 'Add food'
        : 'Add food to ${mealType!.label}';

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
                    icon: const Icon(
                      Icons.arrow_back,
                      color: DashboardColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: DashboardTextStyles.greeting,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: DashboardColors.card,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 19,
                      color: DashboardColors.textMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search foods',
                        style: DashboardTextStyles.mealKcal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: DashboardColors.card,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 30,
                        color: DashboardColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Search for a food',
                      style: DashboardTextStyles.mealTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start typing a name, scan a barcode, or browse your '
                      'recent items to add something to this meal.',
                      textAlign: TextAlign.center,
                      style: DashboardTextStyles.mealItemName.copyWith(
                        color: DashboardColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
