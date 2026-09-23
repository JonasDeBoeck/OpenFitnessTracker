import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';
import '../add_product/add_product_launch_args.dart';
import '../providers/diary_providers.dart';
import '../providers/favorite_toggle_notifier.dart';
import '../providers/food_detail_providers.dart';
import '../widgets/food_thumbnail.dart';
import '../widgets/meal_type_picker.dart';
import '../widgets/quantity_stepper.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  const FoodDetailScreen({super.key, required this.foodId, this.mealType});

  final int foodId;
  final MealType? mealType;

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  late MealType _selectedMeal = widget.mealType ?? MealType.breakfast;

  Future<void> _addToMeal(Food food, double grams) async {
    await ref.read(logFoodProvider.notifier).logFood(
          food: food,
          quantityGrams: grams,
          mealType: _selectedMeal,
        );
    final error = ref.read(logFoodProvider).error;
    if (!mounted) return;
    if (error == null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not log this food: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foodAsync = ref.watch(foodByIdProvider(widget.foodId));
    final grams = ref.watch(foodQuantityProvider);
    final isLogging = ref.watch(logFoodProvider).isLoading;

    return Scaffold(
      backgroundColor: DashboardColors.surface,
      body: SafeArea(
        child: foodAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Could not load this food: $error')),
          data: (food) {
            if (food == null) {
              return const Center(child: Text('This food could not be found.'));
            }
            final nutrition = food.scaledTo(grams);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 14, 24, 6),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                      ),
                      Expanded(
                        child: Text('Food details', style: DashboardTextStyles.topbarTitle),
                      ),
                      IconButton(
                        onPressed: () => context.push(
                          AppRoutes.addProductPath,
                          extra: AddProductLaunchArgs(editingFood: food),
                        ),
                        icon: const Icon(Icons.edit_outlined, color: DashboardColors.textPrimary),
                        tooltip: 'Edit food',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FoodThumbnail(photoPath: food.photoPath, size: 84),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        food.name,
                                        style: DashboardTextStyles.sectionTitle.copyWith(fontSize: 21),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    _FavoriteToggleButton(
                                      isFavorite: food.isFavorite,
                                      onPressed: () =>
                                          ref.read(favoriteToggleProvider.notifier).toggle(food.id!),
                                    ),
                                  ],
                                ),
                                if (food.brand != null || food.store != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      [food.brand, food.store].where((v) => v != null).join(' · '),
                                      style: DashboardTextStyles.mealKcal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      QuantityStepper(
                        grams: grams,
                        onChanged: (value) =>
                            ref.read(foodQuantityProvider.notifier).setGrams(value),
                        label: 'Serving size',
                        minGrams: 25,
                        maxGrams: 400,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: DashboardColors.gaugeCardBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              nutrition.calories.toStringAsFixed(0),
                              style: DashboardTextStyles.gaugeValue.copyWith(fontSize: 34),
                            ),
                            Text('kcal', style: DashboardTextStyles.gaugeSub),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: DashboardColors.card,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            _MacroRow(label: 'Protein', value: nutrition.protein, color: DashboardColors.macroProtein),
                            _MacroRow(label: 'Fat', value: nutrition.fat, color: DashboardColors.macroFat),
                            _MacroRow(label: 'Carbs', value: nutrition.carbs, color: DashboardColors.macroCarb),
                            if (nutrition.fiber != null) _MacroRow(label: 'Fiber', value: nutrition.fiber!, color: DashboardColors.textMuted),
                            if (nutrition.sugar != null) _MacroRow(label: 'Sugar', value: nutrition.sugar!, color: DashboardColors.textMuted),
                            if (nutrition.sodiumMg != null) _MacroRow(label: 'Sodium', value: nutrition.sodiumMg!, unit: 'mg', color: DashboardColors.textMuted),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Add to meal'.toUpperCase(), style: DashboardTextStyles.listHeading),
                      const SizedBox(height: 10),
                      MealTypePicker(
                        selected: _selectedMeal,
                        onSelected: (value) => setState(() => _selectedMeal = value),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: DashboardColors.border)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLogging ? null : () => _addToMeal(food, grams),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DashboardColors.primary,
                          foregroundColor: DashboardColors.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(isLogging ? 'Adding…' : 'Add to ${_selectedMeal.label}'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FavoriteToggleButton extends StatelessWidget {
  const _FavoriteToggleButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      child: Material(
        color: isFavorite ? DashboardColors.favoriteActiveBackground : DashboardColors.surface,
        shape: CircleBorder(
          side: BorderSide(
            color: isFavorite ? DashboardColors.macroFat : DashboardColors.border,
            width: 1.5,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              size: 18,
              color: isFavorite ? DashboardColors.macroFat : DashboardColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.label, required this.value, required this.color, this.unit = 'g'});

  final String label;
  final double value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(label, style: DashboardTextStyles.macroName),
            ],
          ),
          Text('${value.toStringAsFixed(1)} $unit', style: DashboardTextStyles.macroNums),
        ],
      ),
    );
  }
}
