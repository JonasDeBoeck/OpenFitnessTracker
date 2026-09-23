import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/food_repository.dart';
import '../../domain/models/food.dart';

part 'food_search_providers.g.dart';

@riverpod
Future<List<Food>> foodSearchResults(Ref ref, String query) {
  final trimmed = query.trim();
  if (trimmed.isEmpty) return Future.value(const []);
  return ref.watch(foodRepositoryProvider).searchByName(trimmed);
}

@riverpod
Future<List<Food>> recentFoods(Ref ref) {
  return ref.watch(foodRepositoryProvider).getRecentLoggedFoods();
}

/// Every food in the catalog, sorted alphabetically — the unfiltered state
/// of a search-filtered A–Z list (e.g. Add Ingredient), as opposed to
/// [foodsGroupedAlphabeticallyProvider]'s letter-sectioned Browse Foods view.
@riverpod
Future<List<Food>> allFoodsSorted(Ref ref) {
  return ref.watch(foodRepositoryProvider).getAllSortedByName();
}

@riverpod
Future<List<Food>> favoriteFoods(Ref ref) {
  return ref.watch(foodRepositoryProvider).getFavorites();
}

@riverpod
Future<Food?> foodByBarcode(Ref ref, String barcode) {
  return ref.watch(foodRepositoryProvider).getByBarcode(barcode);
}
