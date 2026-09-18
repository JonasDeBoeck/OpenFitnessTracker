import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/recipe.dart';

part 'create_recipe_form_state.freezed.dart';

@freezed
abstract class CreateRecipeFormState with _$CreateRecipeFormState {
  const factory CreateRecipeFormState({
    String? photoPath,
    @Default('') String name,
    @Default(<String>[]) List<String> labels,
    @Default(<RecipeIngredient>[]) List<RecipeIngredient> ingredients,
    int? servings,
    String? prepTime,
    String? cookTime,
    @Default('') String instructionsText,
    @Default(false) bool showInstructions,
    @Default(false) bool isFavorite,
    @Default(false) bool isSaving,
    @Default(false) bool isPickingPhoto,
    String? photoError,
    String? nameError,
    String? saveError,
    Recipe? savedRecipe,
  }) = _CreateRecipeFormState;
}
