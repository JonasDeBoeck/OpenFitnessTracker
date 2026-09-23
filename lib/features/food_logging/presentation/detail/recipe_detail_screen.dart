import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/recipe.dart';
import '../../domain/quantity/logged_quantity_display.dart';
import '../providers/diary_providers.dart';
import '../providers/recipe_detail_providers.dart';
import '../providers/recipe_favorite_toggle_notifier.dart';
import '../widgets/meal_type_picker.dart';

enum _AmountUnit { grams, servings }

/// Recipe counterpart of [FoodDetailScreen]. The amount can always be
/// dialed in as an exact gram figure (so "300 g of this" works even with
/// no servings set); when the recipe does have a servings count, a
/// grams/servings toggle lets it be logged by serving instead.
class RecipeDetailScreen extends ConsumerStatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId, this.mealType});

  final int recipeId;
  final MealType? mealType;

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late MealType _selectedMeal = widget.mealType ?? MealType.breakfast;
  _AmountUnit _unit = _AmountUnit.grams;
  bool _showIngredients = false;
  final _amountController = TextEditingController(text: '100');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amountValue => double.tryParse(_amountController.text.trim()) ?? 0;

  void _setAmount(double value) {
    setState(() => _amountController.text = _formatAmount(value));
  }

  String _formatAmount(double value) =>
      _unit == _AmountUnit.grams ? value.toStringAsFixed(0) : _trimTrailingZero(value);

  String _trimTrailingZero(double value) {
    final text = value.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  void _pickUnit(_AmountUnit unit, Recipe recipe) {
    if (unit == _unit) return;
    setState(() {
      _unit = unit;
      _amountController.text = unit == _AmountUnit.grams
          ? (recipe.gramsPerServing ?? 100).toStringAsFixed(0)
          : '1';
    });
  }

  void _incAmount() =>
      _setAmount(_unit == _AmountUnit.grams ? _amountValue + 25 : _amountValue + 0.5);

  void _decAmount() => _setAmount(
        _unit == _AmountUnit.grams
            ? (_amountValue - 25).clamp(5, double.infinity)
            : (_amountValue - 0.5).clamp(0.5, double.infinity),
      );

  double _effectiveGrams(Recipe recipe) {
    if (_unit == _AmountUnit.servings && recipe.gramsPerServing != null) {
      return _amountValue * recipe.gramsPerServing!;
    }
    return _amountValue;
  }

  Future<void> _addToMeal(Recipe recipe, double grams) async {
    await ref.read(logRecipeProvider.notifier).logRecipe(
          recipe: recipe,
          quantityGrams: grams,
          mealType: _selectedMeal,
        );
    final error = ref.read(logRecipeProvider).error;
    if (!mounted) return;
    if (error == null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not log this recipe: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeByIdProvider(widget.recipeId));
    final isLogging = ref.watch(logRecipeProvider).isLoading;

    return Scaffold(
      backgroundColor: DashboardColors.surface,
      body: SafeArea(
        child: recipeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Could not load this recipe: $error')),
          data: (recipe) {
            if (recipe == null) {
              return const Center(child: Text('This recipe could not be found.'));
            }
            final grams = _effectiveGrams(recipe);
            final nutrition = recipe.scaledTo(grams);
            final hasServings = recipe.servings != null;

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
                        child: Text('Recipe details', style: DashboardTextStyles.topbarTitle),
                      ),
                      IconButton(
                        onPressed: () => context.push(AppRoutes.createRecipePath, extra: recipe),
                        icon: const Icon(Icons.edit_outlined, color: DashboardColors.textPrimary),
                        tooltip: 'Edit recipe',
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
                          Expanded(
                            child: Text(recipe.name, style: DashboardTextStyles.sectionTitle),
                          ),
                          Material(
                            color: recipe.isFavorite
                                ? DashboardColors.favoriteActiveBackground
                                : Colors.transparent,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: recipe.isFavorite
                                    ? DashboardColors.macroFat
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () =>
                                  ref.read(recipeFavoriteToggleProvider.notifier).toggle(recipe.id!),
                              child: Tooltip(
                                message: recipe.isFavorite
                                    ? 'Remove from favorites'
                                    : 'Add to favorites',
                                child: SizedBox(
                                  width: 38,
                                  height: 38,
                                  child: Icon(
                                    recipe.isFavorite ? Icons.star : Icons.star_border,
                                    size: 20,
                                    color: recipe.isFavorite
                                        ? DashboardColors.macroFat
                                        : DashboardColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (recipe.labels.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final label in recipe.labels)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: DashboardColors.gaugeCardBackground,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    label,
                                    style: DashboardTextStyles.macroNums.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: DashboardColors.primaryDark,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => setState(() => _showIngredients = !_showIngredients),
                        style: TextButton.styleFrom(
                          foregroundColor: DashboardColors.primary,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          _showIngredients
                              ? 'Hide ingredients'
                              : 'See ${recipe.ingredients.length} ingredients',
                        ),
                      ),
                      if (_showIngredients)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: DashboardColors.card,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              for (final ingredient in recipe.ingredients)
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFE3DFCF))),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ingredient.foodName,
                                          style: DashboardTextStyles.mealItemName,
                                        ),
                                      ),
                                      Text(
                                        formatLoggedQuantity(
                                          grams: ingredient.grams,
                                          unitLabel: ingredient.unitLabel,
                                          unitCount: ingredient.unitCount,
                                        ),
                                        style: DashboardTextStyles.mealItemKcal,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: DashboardColors.card,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            if (hasServings)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _UnitButton(
                                        label: 'Grams',
                                        active: _unit == _AmountUnit.grams,
                                        onTap: () => _pickUnit(_AmountUnit.grams, recipe),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: _UnitButton(
                                        label: 'Servings',
                                        active: _unit == _AmountUnit.servings,
                                        onTap: () => _pickUnit(_AmountUnit.servings, recipe),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Amount', style: DashboardTextStyles.macroName),
                                Row(
                                  children: [
                                    _StepButton(icon: Icons.remove, onTap: _decAmount),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 52,
                                      child: TextField(
                                        controller: _amountController,
                                        textAlign: TextAlign.center,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        onChanged: (_) => setState(() {}),
                                        style: DashboardTextStyles.macroName,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _unit == _AmountUnit.grams
                                          ? 'g'
                                          : (_amountValue == 1 ? 'serving' : 'servings'),
                                      style: DashboardTextStyles.mealKcal,
                                    ),
                                    const SizedBox(width: 10),
                                    _StepButton(icon: Icons.add, onTap: _incAmount),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Add to meal', style: DashboardTextStyles.sectionTitle.copyWith(fontSize: 13)),
                      const SizedBox(height: 10),
                      MealTypePicker(
                        selected: _selectedMeal,
                        onSelected: (value) => setState(() => _selectedMeal = value),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLogging ? null : () => _addToMeal(recipe, grams),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DashboardColors.primary,
                        foregroundColor: DashboardColors.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(isLogging ? 'Adding…' : 'Add to ${_selectedMeal.label}'),
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

class _UnitButton extends StatelessWidget {
  const _UnitButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? DashboardColors.primary : DashboardColors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.macroNums.copyWith(
              fontWeight: FontWeight.w600,
              color: active ? DashboardColors.surface : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(side: BorderSide(color: DashboardColors.primary, width: 1.5)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: DashboardColors.primary),
        ),
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({required this.label, required this.value, required this.color});

  final String label;
  final double value;
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
          Text('${value.toStringAsFixed(1)} g', style: DashboardTextStyles.macroNums),
        ],
      ),
    );
  }
}
