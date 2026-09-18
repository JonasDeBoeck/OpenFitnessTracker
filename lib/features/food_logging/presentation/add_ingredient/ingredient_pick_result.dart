import '../../domain/models/food.dart';

/// Popped result of [AddIngredientScreen] — the food and quantity the user
/// picked, for the caller (Create Recipe) to turn into a [RecipeIngredient].
class IngredientPickResult {
  const IngredientPickResult({required this.food, required this.grams});

  final Food food;
  final double grams;
}
