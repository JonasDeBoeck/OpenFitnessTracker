import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_repository.dart';
import '../../domain/models/recipe.dart';

part 'recipe_search_providers.g.dart';

@riverpod
Future<List<Recipe>> recipeSearchResults(Ref ref, String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return Future.value(const []);
  return ref.watch(recipeRepositoryProvider).searchByName(trimmed);
}

@riverpod
Future<List<Recipe>> recentRecipes(Ref ref) {
  return ref.watch(recipeRepositoryProvider).getRecentRecipes();
}

@riverpod
Future<List<Recipe>> favoriteRecipes(Ref ref) {
  return ref.watch(recipeRepositoryProvider).getFavorites();
}

@riverpod
Future<List<String>> existingRecipeLabels(Ref ref) {
  return ref.watch(recipeRepositoryProvider).getAllLabels();
}
