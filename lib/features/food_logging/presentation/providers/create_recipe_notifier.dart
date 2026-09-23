import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_repository.dart';
import '../../data/services/food_photo_service.dart';
import '../../domain/models/food.dart';
import '../../domain/models/recipe.dart';
import 'browse_recipes_providers.dart';
import 'create_recipe_form_state.dart';
import 'recipe_detail_providers.dart';
import 'recipe_search_providers.dart';

part 'create_recipe_notifier.g.dart';

@riverpod
class CreateRecipeNotifier extends _$CreateRecipeNotifier {
  @override
  CreateRecipeFormState build({Recipe? editingRecipe}) {
    if (editingRecipe == null) return const CreateRecipeFormState();
    return CreateRecipeFormState(
      photoPath: editingRecipe.photoPath,
      name: editingRecipe.name,
      labels: editingRecipe.labels,
      ingredients: editingRecipe.ingredients,
      servings: editingRecipe.servings,
      prepTime: editingRecipe.prepTime,
      cookTime: editingRecipe.cookTime,
      instructionsText: editingRecipe.instructions.join('\n'),
      showInstructions: editingRecipe.instructions.isNotEmpty,
      isFavorite: editingRecipe.isFavorite,
      savedRecipe: editingRecipe,
    );
  }

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
    if (trimmed.isEmpty) return;
    if (state.labels.any((l) => l.toLowerCase() == trimmed.toLowerCase())) return;
    state = state.copyWith(labels: [...state.labels, trimmed]);
  }

  void removeLabel(String label) {
    state = state.copyWith(labels: state.labels.where((l) => l != label).toList());
  }

  void addIngredient(Food food, double grams, {String? unitLabel, double? unitCount}) {
    final ingredient = RecipeIngredient.fromFood(
      food: food,
      grams: grams,
      unitLabel: unitLabel,
      unitCount: unitCount,
    );
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
    final previouslySavedId = state.savedRecipe?.id;

    state = state.copyWith(isSaving: true, saveError: null);
    try {
      final instructions = state.instructionsText
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      final recipe = Recipe(
        id: previouslySavedId,
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

      final Recipe saved;
      if (previouslySavedId == null) {
        saved = await ref.read(recipeRepositoryProvider).create(recipe);
      } else {
        saved = await ref.read(recipeRepositoryProvider).update(recipe);
        ref.invalidate(recipeByIdProvider(previouslySavedId));
      }

      ref.invalidate(recentRecipesProvider);
      ref.invalidate(recipesGroupedAlphabeticallyProvider);
      ref.invalidate(existingRecipeLabelsProvider);
      if (state.isFavorite) ref.invalidate(favoriteRecipesProvider);

      state = state.copyWith(isSaving: false, savedRecipe: saved);
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: 'Could not save this recipe: $e');
    }
  }
}
