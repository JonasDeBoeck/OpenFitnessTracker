import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';
import '../add_product/add_product_launch_args.dart';
import '../providers/favorite_toggle_notifier.dart';
import '../providers/food_search_providers.dart';
import '../widgets/food_list_row.dart';

enum _RecentTab { recent, favorites }

/// Search screen for adding food to a meal (or, from the bottom-nav FAB,
/// with no meal preset). Shows Recent/Favorites when the search box is
/// empty, live search results otherwise, plus entry points to barcode
/// scanning, manual entry, and browsing the whole catalog A-Z.
class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key, this.mealType});

  final MealType? mealType;

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();
  _RecentTab _tab = _RecentTab.recent;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFood(Food food) {
    context.push('/log-food/food/${food.id}', extra: widget.mealType);
  }

  Future<void> _toggleFavorite(Food food) async {
    await ref.read(favoriteToggleProvider.notifier).toggle(food.id!);
    if (_query.trim().isNotEmpty) {
      ref.invalidate(foodSearchResultsProvider(_query.trim()));
    }
  }

  Future<void> _scanBarcode() async {
    final code = await context.push<String>(AppRoutes.scanBarcodePath);
    if (code == null || !mounted) return;

    final match = await ref.read(foodByBarcodeProvider(code).future);
    if (!mounted) return;

    if (match != null) {
      _openFood(match);
    } else {
      context.push(
        AppRoutes.addProductPath,
        extra: AddProductLaunchArgs(prefillBarcode: code, mealType: widget.mealType),
      );
    }
  }

  void _addManually() {
    context.push(
      AppRoutes.addProductPath,
      extra: AddProductLaunchArgs(mealType: widget.mealType),
    );
  }

  void _browseAll() {
    context.push(AppRoutes.browseFoodsPath, extra: widget.mealType);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mealType == null ? 'Log food' : 'Log food to ${widget.mealType!.label}';
    final hasQuery = _query.trim().isNotEmpty;

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
                  Expanded(
                    child: Text(title, style: DashboardTextStyles.greeting, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
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
                    if (hasQuery)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: DashboardColors.textMuted),
                        onPressed: () => setState(() {
                          _searchController.clear();
                          _query = '';
                        }),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _scanBarcode,
                      icon: const Icon(Icons.qr_code_scanner, size: 16),
                      label: const Text('Scan barcode'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DashboardColors.primary,
                        side: const BorderSide(color: Color(0xFFC7C2AC), width: 1.5, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addManually,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Add manually'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DashboardColors.primary,
                        side: const BorderSide(color: Color(0xFFC7C2AC), width: 1.5, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _browseAll,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Browse all foods (A–Z)'),
                  style: TextButton.styleFrom(foregroundColor: DashboardColors.primary),
                ),
              ),
            ),
            if (!hasQuery)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'Recent',
                        active: _tab == _RecentTab.recent,
                        onTap: () => setState(() => _tab = _RecentTab.recent),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TabButton(
                        label: 'Favorites',
                        active: _tab == _RecentTab.favorites,
                        onTap: () => setState(() => _tab = _RecentTab.favorites),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildList(hasQuery),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(bool hasQuery) {
    final AsyncValue<List<Food>> asyncFoods = hasQuery
        ? ref.watch(foodSearchResultsProvider(_query.trim()))
        : _tab == _RecentTab.recent
            ? ref.watch(recentFoodsProvider)
            : ref.watch(favoriteFoodsProvider);

    return asyncFoods.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Could not load foods: $error')),
      data: (foods) {
        if (foods.isEmpty) {
          return Center(
            child: Text(
              hasQuery ? 'No foods match "${_query.trim()}".' : 'Nothing here yet.',
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
            return FoodListRow(
              food: food,
              onTap: () => _openFood(food),
              onToggleFavorite: () => _toggleFavorite(food),
            );
          },
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? DashboardColors.primary : DashboardColors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.addFoodButton.copyWith(
              color: active ? DashboardColors.surface : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
