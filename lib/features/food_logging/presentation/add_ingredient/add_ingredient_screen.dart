import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';
import '../providers/food_search_providers.dart';
import '../widgets/food_thumbnail.dart';
import '../widgets/quantity_stepper.dart';
import 'ingredient_pick_result.dart';

/// Two-step ingredient picker pushed from Create Recipe: search/pick a food,
/// then set its gram quantity, then pop an [IngredientPickResult] back.
class AddIngredientScreen extends ConsumerStatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  ConsumerState<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends ConsumerState<AddIngredientScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  Food? _selected;
  double _grams = 100;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _pick(Food food) {
    setState(() {
      _selected = food;
      _grams = 100;
    });
  }

  void _backToList() => setState(() => _selected = null);

  void _confirm() {
    context.pop(IngredientPickResult(food: _selected!, grams: _grams));
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
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
                    onPressed: selected == null ? () => context.pop() : _backToList,
                    icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      'Add ingredient',
                      style: DashboardTextStyles.topbarTitle.copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: selected == null ? _buildList() : _buildQuantity(selected),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final hasQuery = _query.trim().isNotEmpty;
    final asyncFoods = hasQuery
        ? ref.watch(foodSearchResultsProvider(_query.trim()))
        : ref.watch(allFoodsSortedProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: DashboardColors.card,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 19, color: DashboardColors.textMuted),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Search foods',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: DashboardTextStyles.mealItemName,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: asyncFoods.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Could not load foods: $error')),
              data: (foods) {
                if (foods.isEmpty) {
                  return Center(
                    child: Text(
                      hasQuery
                          ? 'No foods match "${_query.trim()}".'
                          : 'No foods yet — add one from Log food.',
                      style: DashboardTextStyles.mealEmpty,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: foods.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    final kcalLabel = food.caloriesPer100g == null
                        ? '— kcal/100g'
                        : '${food.caloriesPer100g!.toStringAsFixed(0)} kcal/100g';
                    final subtitle = [food.brand, food.store].whereType<String>().join(' · ');
                    return Material(
                      color: DashboardColors.card,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _pick(food),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                                      Text(
                                        subtitle,
                                        style: DashboardTextStyles.mealKcal,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              Text(kcalLabel, style: DashboardTextStyles.mealItemKcal),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantity(Food food) {
    final kcal = (food.caloriesPer100g ?? 0) * _grams / 100;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(food.name, style: DashboardTextStyles.sectionTitle),
              const SizedBox(height: 16),
              QuantityStepper(grams: _grams, onChanged: (v) => setState(() => _grams = v)),
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
                      '≈ ${kcal.toStringAsFixed(0)}',
                      style: DashboardTextStyles.gaugeValue.copyWith(fontSize: 34),
                    ),
                    Text('kcal for this ingredient', style: DashboardTextStyles.gaugeSub),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: DashboardColors.primary,
                foregroundColor: DashboardColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Add ingredient'),
            ),
          ),
        ),
      ],
    );
  }
}
