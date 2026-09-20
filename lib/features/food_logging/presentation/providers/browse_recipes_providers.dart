import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_repository.dart';
import '../../domain/models/recipe.dart';

part 'browse_recipes_providers.g.dart';

/// Every recipe in the catalog, grouped by the first letter of its name —
/// the recipe counterpart of [foodsGroupedAlphabeticallyProvider].
@riverpod
Future<Map<String, List<Recipe>>> recipesGroupedAlphabetically(Ref ref) async {
  final recipes = await ref.watch(recipeRepositoryProvider).getAllSortedByName();
  final grouped = <String, List<Recipe>>{};
  for (final recipe in recipes) {
    final letter = recipe.name.isEmpty ? '#' : recipe.name[0].toUpperCase();
    grouped.putIfAbsent(letter, () => []).add(recipe);
  }
  return grouped;
}
