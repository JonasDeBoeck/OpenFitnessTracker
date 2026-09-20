import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_repository.dart';
import '../../data/services/food_photo_service.dart';
import '../../domain/models/food.dart';
import '../../domain/models/recipe.dart';
import 'browse_recipes_providers.dart';
import 'create_recipe_form_state.dart';
import 'recipe_search_providers.dart';

part 'create_recipe_notifier.g.dart';

@riverpod
class CreateRecipeNotifier extends _$CreateRecipeNotifier {
  @override
  CreateRecipeFormState build() => const CreateRecipeFormState();

  void setName(String value) => state = state.copyWith(name: value, nameError: null);
  void setServings(int? value) => state = state.copyWith(servings: value);
  void setPrepTime(String? value) => state = state.copyWith(prepTime: value);
  void setCookTime(String? value) => state = state.copyWith(cookTime: value);
  void setInstructionsText(String value) => state = state.copyWith(instructionsText: value);
  void toggleShowInstructions() =>
      state = state.copyWith(showInstructions: !state.showInstructions);
  void toggleFavorite() => state = state.copyWith(isFavorite: !state.isFavorite);

  void addLabel(String label) {
    final trimmed = label.trim();
    if (trimmed.isEmpty || state.labels.contains(trimmed)) return;
    state = state.copyWith(labels: [...state.labels, trimmed]);
  }

  void removeLabel(String label) {
    state = state.copyWith(labels: state.labels.where((l) => l != label).toList());
  }

  void addIngredient(Food food, double grams) {
    final ingredient = RecipeIngredient.fromFood(food: food, grams: grams);
    state = state.copyWith(ingredients: [...state.ingredients, ingredient]);
  }

  void removeIngredientAt(int index) {
    final updated = [...state.ingredients]..removeAt(index);
    state = state.copyWith(ingredients: updated);
  }

  void clearPhoto() => state = state.copyWith(photoPath: null);

  Future<void> pickPhoto(ImageSource source) async {
    state = state.copyWith(isPickingPhoto: true, photoError: null);
    try {
      final path = await ref.read(foodPhotoServiceProvider).pickPhoto(source: source);
      state = state.copyWith(isPickingPhoto: false, photoPath: path ?? state.photoPath);
    } catch (e) {
      state = state.copyWith(isPickingPhoto: false, photoError: 'Could not use that photo: $e');
    }
  }

  Future<void> save() async {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(nameError: 'Enter a recipe name');
      return;
    }
    state = state.copyWith(isSaving: true, saveError: null);
    try {
      final instructions = state.instructionsText
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      final recipe = Recipe(
        name: state.name.trim(),
        labels: state.labels,
        servings: state.servings,
        prepTime: state.prepTime,
        cookTime: state.cookTime,
        instructions: instructions,
        photoPath: state.photoPath,
        isFavorite: state.isFavorite,
        ingredients: state.ingredients,
      );

      final saved = await ref.read(recipeRepositoryProvider).create(recipe);

      ref.invalidate(recentRecipesProvider);
      ref.invalidate(recipesGroupedAlphabeticallyProvider);
      if (state.isFavorite) ref.invalidate(favoriteRecipesProvider);

      state = state.copyWith(isSaving: false, savedRecipe: saved);
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: 'Could not save this recipe: $e');
    }
  }
}
