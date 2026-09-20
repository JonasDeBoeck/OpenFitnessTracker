import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/food_repository.dart';
import '../../domain/models/food.dart';

part 'browse_foods_providers.g.dart';

/// Every food in the catalog, grouped by the first letter of its name.
/// Since [FoodRepository.getAllSortedByName] already returns names sorted,
/// the groups come out alphabetical for free — this is a pure derived
/// transform, so it lives here rather than in the repository or a widget.
@riverpod
Future<Map<String, List<Food>>> foodsGroupedAlphabetically(Ref ref) async {
  final foods = await ref.watch(foodRepositoryProvider).getAllSortedByName();
  final grouped = <String, List<Food>>{};
  for (final food in foods) {
    final letter = food.name.isEmpty ? '#' : food.name[0].toUpperCase();
    grouped.putIfAbsent(letter, () => []).add(food);
  }
  return grouped;
}
