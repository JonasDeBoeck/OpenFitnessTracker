import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/food_repository.dart';
import 'food_detail_providers.dart';
import 'food_search_providers.dart';

part 'favorite_toggle_notifier.g.dart';

@riverpod
class FavoriteToggleNotifier extends _$FavoriteToggleNotifier {
  @override
  Future<void> build() async {}

  Future<void> toggle(int foodId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(foodRepositoryProvider).toggleFavorite(foodId);
      ref.invalidate(foodByIdProvider(foodId));
      ref.invalidate(favoriteFoodsProvider);
      ref.invalidate(recentFoodsProvider);
      // foodSearchResultsProvider(query) is a family keyed by the query
      // text, so it can't be invalidated generically from here — a row
      // toggling favorite from within an active search list should also
      // invalidate foodSearchResultsProvider(currentQueryText) itself.
    });
  }
}
