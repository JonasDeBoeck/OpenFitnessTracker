import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_repository.dart';
import '../../domain/models/recipe.dart';

part 'recipe_detail_providers.g.dart';

@riverpod
Future<Recipe?> recipeById(Ref ref, int recipeId) {
  return ref.watch(recipeRepositoryProvider).getById(recipeId);
}
