import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/food_repository.dart';
import '../../domain/models/food.dart';

part 'food_detail_providers.g.dart';

@riverpod
Future<Food?> foodById(Ref ref, int foodId) {
  return ref.watch(foodRepositoryProvider).getById(foodId);
}

/// The quantity-in-grams the user is currently dialing in on the food
/// detail screen. Pure ephemeral UI state — nothing to persist here, the
/// quantity only matters once it's snapshotted into a [DiaryEntry].
@riverpod
class FoodQuantityNotifier extends _$FoodQuantityNotifier {
  @override
  double build() => 100;

  void setGrams(double grams) => state = grams < 0 ? 0 : grams;
}
