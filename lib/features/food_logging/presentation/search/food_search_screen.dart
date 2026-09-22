import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/food.dart';
import '../../domain/models/recipe.dart';
import '../add_product/add_product_launch_args.dart';
import '../providers/add_product_notifier.dart';
import '../providers/diary_providers.dart';
import '../providers/favorite_toggle_notifier.dart';
import '../providers/food_search_providers.dart';
import '../providers/recipe_favorite_toggle_notifier.dart';
import '../providers/recipe_search_providers.dart';
import '../widgets/food_list_row.dart';
import '../widgets/recipe_list_row.dart';

enum _Mode { foods, recipes }

enum _RecentTab { recent, favorites }

/// Search screen for adding food — or a recipe — to a meal (or, from the
/// bottom-nav FAB, with no meal preset). A Foods/Recipes switch at the top
/// picks which catalog is being searched/browsed; each mode still shows
/// Recent/Favorites when its search box is empty, live search results
/// otherwise, plus its own entry points (barcode/manual entry for foods,
/// create for recipes) and a Browse all A-Z link.
class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key, this.mealType});

  final MealType? mealType;

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();
  _Mode _mode = _Mode.foods;
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

  void _openRecipe(Recipe recipe) {
    context.push('/log-food/recipe/${recipe.id}', extra: widget.mealType);
  }

  Future<void> _quickAddFood(Food food) async {
    final mealType = widget.mealType ?? MealType.breakfast;
    await ref.read(logFoodProvider.notifier).logFood(
          food: food,
          quantityGrams: kDefaultLoggedQuantityGrams,
          mealType: mealType,
        );
    final error = ref.read(logFoodProvider).error;
    if (!mounted) return;
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to ${mealType.label}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not log this food: $error')),
      );
    }
  }

  Future<void> _toggleFavorite(Food food) async {
    await ref.read(favoriteToggleProvider.notifier).toggle(food.id!);
    if (_query.trim().isNotEmpty) {
      ref.invalidate(foodSearchResultsProvider(_query.trim()));
    }
  }

  Future<void> _toggleRecipeFavorite(Recipe recipe) async {
    await ref.read(recipeFavoriteToggleProvider.notifier).toggle(recipe.id!);
    if (_query.trim().isNotEmpty) {
      ref.invalidate(recipeSearchResultsProvider(_query.trim()));
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

  void _createRecipe() {
    context.push(AppRoutes.createRecipePath);
  }

  void _browseAll() {
    if (_mode == _Mode.foods) {
      context.push(AppRoutes.browseFoodsPath, extra: widget.mealType);
    } else {
      context.push(AppRoutes.browseRecipesPath, extra: widget.mealType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.mealType == null ? 'Log food' : 'Log food to ${widget.mealType!.label}';
    final hasQuery = _query.trim().isNotEmpty;
    final isFoods = _mode == _Mode.foods;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: DashboardTextStyles.topbarTitle.copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.mealType != null)
                          Text(
                            '${widget.mealType!.label} · Today',
                            style: DashboardTextStyles.mealKcal,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      label: 'Foods',
                      active: isFoods,
                      onTap: () => setState(() => _mode = _Mode.foods),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ModeButton(
                      label: 'Recipes',
                      active: !isFoods,
                      onTap: () => setState(() => _mode = _Mode.recipes),
                    ),
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
                        decoration: InputDecoration(
                          hintText: isFoods ? 'Search foods' : 'Search recipes',
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
              child: isFoods
                  ? Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            onTap: _scanBarcode,
                            icon: Icons.qr_code_scanner,
                            label: 'Scan barcode',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ActionButton(
                            onTap: _addManually,
                            icon: Icons.edit_outlined,
                            label: 'Add manually',
                          ),
                        ),
                      ],
                    )
                  : _ActionButton(
                      onTap: _createRecipe,
                      icon: Icons.add,
                      label: 'Create recipe',
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _browseAll,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(isFoods ? 'Browse all foods (A–Z)' : 'Browse all recipes (A–Z)'),
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
                child: isFoods ? _buildFoodList(hasQuery) : _buildRecipeList(hasQuery),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList(bool hasQuery) {
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
          return _EmptyState(
            message: hasQuery ? 'No foods match "${_query.trim()}".' : 'Nothing here yet.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(_listHeading(hasQuery).toUpperCase(), style: DashboardTextStyles.listHeading),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: foods.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return FoodListRow(
                    food: food,
                    onTap: () => _openFood(food),
                    onToggleFavorite: () => _toggleFavorite(food),
                    onQuickAdd: () => _quickAddFood(food),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _listHeading(bool hasQuery) {
    if (hasQuery) return 'Results for "${_query.trim()}"';
    return _tab == _RecentTab.recent ? 'Recent' : 'Favorites';
  }

  Widget _buildRecipeList(bool hasQuery) {
    final AsyncValue<List<Recipe>> asyncRecipes = hasQuery
        ? ref.watch(recipeSearchResultsProvider(_query.trim()))
        : _tab == _RecentTab.recent
            ? ref.watch(recentRecipesProvider)
            : ref.watch(favoriteRecipesProvider);

    return asyncRecipes.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Could not load recipes: $error')),
      data: (recipes) {
        if (recipes.isEmpty) {
          return _EmptyState(
            message: hasQuery ? 'No recipes match "${_query.trim()}".' : 'Save a recipe to see it here.',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(_listHeading(hasQuery).toUpperCase(), style: DashboardTextStyles.listHeading),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: recipes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeListRow(
                    recipe: recipe,
                    onTap: () => _openRecipe(recipe),
                    onToggleFavorite: () => _toggleRecipeFavorite(recipe),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? DashboardColors.primary : DashboardColors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.sectionTitle.copyWith(
              fontSize: 13.5,
              color: active ? DashboardColors.surface : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
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

/// A dashed-outline action button (scan barcode / add manually / create
/// recipe) — `OutlinedButton` has no native dashed border, so this pairs a
/// [CustomPaint] dashed outline (adapted from `MealSectionCard`'s
/// `_DashedRoundedBorderPainter`) with an `InkWell` for the tap ripple.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: CustomPaint(
          painter: _DashedRoundedBorderPainter(
            color: const Color(0xFFC7C2AC),
            radius: 14,
          ),
          child: SizedBox(
            height: 44,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: DashboardColors.primary),
                const SizedBox(width: 6),
                Text(label, style: DashboardTextStyles.addFoodButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _strokeWidth = 1.5;
  static const double _dashWidth = 5;
  static const double _dashGap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

/// Empty search/browse-list state: a 60px icon circle above the message,
/// matching the design's empty-state treatment.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: DashboardColors.card,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.search, size: 24, color: DashboardColors.textMuted),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: DashboardTextStyles.mealEmpty,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
