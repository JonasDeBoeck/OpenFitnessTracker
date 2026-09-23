import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/recipe.dart';
import '../add_ingredient/ingredient_pick_result.dart';
import '../add_product/widgets/photo_picker_field.dart';
import '../providers/create_recipe_notifier.dart';
import '../providers/recipe_search_providers.dart';
import '../widgets/label_chips_field.dart';

/// Creates a new recipe: name, labels, ingredients (picked from the food
/// catalog via [AddIngredientScreen]), optional servings/prep/cook time and
/// instructions, plus a live-computed nutrition summary.
class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key, this.editingRecipe});

  final Recipe? editingRecipe;

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  late final _provider = createRecipeProvider(editingRecipe: widget.editingRecipe);

  final _nameController = TextEditingController();
  final _servingsController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = ref.read(_provider);
    _nameController.text = initial.name;
    _servingsController.text = initial.servings?.toString() ?? '';
    _prepTimeController.text = initial.prepTime ?? '';
    _cookTimeController.text = initial.cookTime ?? '';
    _instructionsController.text = initial.instructionsText;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _servingsController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _addIngredient(CreateRecipeNotifier notifier) async {
    final result = await context.push<IngredientPickResult>(AppRoutes.addIngredientPath);
    if (result == null) return;
    notifier.addIngredient(result.food, result.grams);
  }

  Future<void> _save(CreateRecipeNotifier notifier) async {
    await notifier.save();
    if (!mounted) return;
    final state = ref.read(_provider);
    if (state.saveError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.saveError!)));
      return;
    }
    if (state.savedRecipe != null) {
      context.pop();
    }
  }

  int? _parseInt(String text) => text.trim().isEmpty ? null : int.tryParse(text.trim());

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final notifier = ref.read(_provider.notifier);
    final isEditing = widget.editingRecipe != null;

    final preview = Recipe(
      name: state.name,
      ingredients: state.ingredients,
      servings: state.servings,
    );

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
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit recipe' : 'Create recipe',
                      style: DashboardTextStyles.topbarTitle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  PhotoPickerField(
                    photoPath: state.photoPath,
                    isPicking: state.isPickingPhoto,
                    onPick: (source) => notifier.pickPhoto(source),
                    onRemove: notifier.clearPhoto,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recipe name',
                    style: DashboardTextStyles.mealKcal.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nameController,
                    onChanged: notifier.setName,
                    textCapitalization: TextCapitalization.words,
                    style: DashboardTextStyles.mealItemName,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'e.g. Chicken & rice bowl',
                      filled: true,
                      fillColor: DashboardColors.card,
                      errorText: state.nameError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LabelChipsField(
                    labels: state.labels,
                    existingLabels: ref.watch(existingRecipeLabelsProvider).when(
                          data: (labels) => labels,
                          loading: () => const [],
                          error: (_, _) => const [],
                        ),
                    onAdd: notifier.addLabel,
                    onRemove: notifier.removeLabel,
                  ),
                  const SizedBox(height: 20),
                  Text('Ingredients', style: DashboardTextStyles.mealKcal),
                  const SizedBox(height: 8),
                  for (var i = 0; i < state.ingredients.length; i++) ...[
                    _IngredientRow(
                      ingredient: state.ingredients[i],
                      onRemove: () => notifier.removeIngredientAt(i),
                    ),
                    const SizedBox(height: 8),
                  ],
                  _AddIngredientButton(onTap: () => _addIngredient(notifier)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _LabeledField(
                          label: 'Servings (optional)',
                          controller: _servingsController,
                          onChanged: (v) => notifier.setServings(_parseInt(v)),
                          hint: 'e.g. 4',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _LabeledField(
                          label: 'Prep time',
                          controller: _prepTimeController,
                          onChanged: notifier.setPrepTime,
                          hint: 'e.g. 15 min',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _LabeledField(
                          label: 'Cook time',
                          controller: _cookTimeController,
                          onChanged: notifier.setCookTime,
                          hint: 'e.g. 25 min',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Leave servings blank if this recipe doesn't divide neatly — you can still log it by weight later.",
                    style: DashboardTextStyles.mealKcal,
                  ),
                  const SizedBox(height: 16),
                  if (state.showInstructions) ...[
                    Text('Instructions', style: DashboardTextStyles.mealKcal),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _instructionsController,
                      onChanged: notifier.setInstructionsText,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      style: DashboardTextStyles.mealItemName,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'One step per line',
                        filled: true,
                        fillColor: DashboardColors.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextButton(
                    onPressed: notifier.toggleShowInstructions,
                    style: TextButton.styleFrom(
                      foregroundColor: DashboardColors.primary,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      state.showInstructions ? 'Hide instructions' : 'Add instructions (optional)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _NutritionSummary(recipe: preview),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: state.isSaving ? null : () => _save(notifier),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DashboardColors.primary,
                    foregroundColor: DashboardColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    state.isSaving ? 'Saving…' : (isEditing ? 'Save changes' : 'Save recipe'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient, required this.onRemove});

  final RecipeIngredient ingredient;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: DashboardColors.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ingredient.foodName, style: DashboardTextStyles.mealTitle),
                Text(
                  '${ingredient.grams.toStringAsFixed(0)} g · ${ingredient.calories.toStringAsFixed(0)} kcal',
                  style: DashboardTextStyles.mealKcal,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: DashboardColors.textSecondary),
            tooltip: 'Remove ingredient',
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  const _NutritionSummary({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final perServing = recipe.gramsPerServing == null
        ? null
        : recipe.scaledTo(recipe.gramsPerServing!).calories;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DashboardColors.gaugeCardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            recipe.totalCalories.toStringAsFixed(0),
            style: DashboardTextStyles.gaugeValue.copyWith(fontSize: 32),
          ),
          Text('total kcal', style: DashboardTextStyles.gaugeSub),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SummaryMacro(label: 'Protein', value: recipe.totalProtein),
              const SizedBox(width: 18),
              _SummaryMacro(label: 'Fat', value: recipe.totalFat),
              const SizedBox(width: 18),
              _SummaryMacro(label: 'Carbs', value: recipe.totalCarbs),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${recipe.totalGrams.toStringAsFixed(0)} g total · ${recipe.caloriesPer100g.toStringAsFixed(0)} kcal / 100 g',
            style: DashboardTextStyles.gaugeSub,
          ),
          if (perServing != null)
            Text('≈ ${perServing.toStringAsFixed(0)} kcal / serving', style: DashboardTextStyles.gaugeSub),
        ],
      ),
    );
  }
}

class _SummaryMacro extends StatelessWidget {
  const _SummaryMacro({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${value.toStringAsFixed(0)} g', style: DashboardTextStyles.gaugeRemaining),
        Text(label, style: DashboardTextStyles.gaugeSub),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DashboardTextStyles.mealKcal.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: DashboardTextStyles.mealItemName,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            filled: true,
            fillColor: DashboardColors.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _AddIngredientButton extends StatelessWidget {
  const _AddIngredientButton({required this.onTap});

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
                const Icon(Icons.add, size: 16, color: DashboardColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Add ingredient',
                  style: DashboardTextStyles.addFoodButton.copyWith(fontSize: 13),
                ),
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
