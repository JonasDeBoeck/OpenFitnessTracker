import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_repository.dart';
import 'recipe_detail_providers.dart';
import 'recipe_search_providers.dart';

part 'recipe_favorite_toggle_notifier.g.dart';

@riverpod
class RecipeFavoriteToggleNotifier extends _$RecipeFavoriteToggleNotifier {
  @override
  Future<void> build() async {}

  Future<void> toggle(int recipeId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(recipeRepositoryProvider).toggleFavorite(recipeId);
      ref.invalidate(recipeByIdProvider(recipeId));
      ref.invalidate(favoriteRecipesProvider);
      ref.invalidate(recentRecipesProvider);
      // recipeSearchResultsProvider(query) is a family keyed by the query
      // text, so it can't be invalidated generically from here — same
      // caveat as FavoriteToggleNotifier for foods.
    });
  }
}
