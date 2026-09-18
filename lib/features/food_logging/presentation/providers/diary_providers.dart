import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/meal_type.dart';
import '../../data/diary_repository.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/food.dart';
import '../../domain/models/recipe.dart';
import 'food_search_providers.dart';
import 'recipe_search_providers.dart';

part 'diary_providers.g.dart';

@riverpod
Future<List<DiaryEntry>> diaryEntriesForDate(Ref ref, DateTime date) {
  return ref.watch(diaryRepositoryProvider).getEntriesForDate(date);
}

/// Logs a food (with its snapshotted nutrition at the given quantity) to a
/// meal for today. This is the one place a diary entry gets written from
/// the Food Detail screen — Add Product writes its own via
/// [AddProductNotifier] when "log to a meal" is on.
@riverpod
class LogFoodNotifier extends _$LogFoodNotifier {
  @override
  Future<void> build() async {}

  Future<void> logFood({
    required Food food,
    required double quantityGrams,
    required MealType mealType,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: quantityGrams,
        mealType: mealType,
        loggedAt: DateTime.now(),
      );
      await ref.read(diaryRepositoryProvider).insertLogEntry(entry);
      // homeDashboardProvider watches diaryEntriesForDateProvider for the
      // exact same normalized "today" value, so invalidating this alone is
      // enough for Riverpod to recompute the dashboard too.
      ref.invalidate(diaryEntriesForDateProvider(DateUtils.dateOnly(DateTime.now())));
      ref.invalidate(recentFoodsProvider);
    });
  }
}

/// [LogFoodNotifier]'s recipe counterpart — the one place a diary entry
/// gets written from the Recipe Detail screen.
@riverpod
class LogRecipeNotifier extends _$LogRecipeNotifier {
  @override
  Future<void> build() async {}

  Future<void> logRecipe({
    required Recipe recipe,
    required double quantityGrams,
    required MealType mealType,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final entry = DiaryEntry.snapshotFromRecipe(
        recipe: recipe,
        quantityGrams: quantityGrams,
        mealType: mealType,
        loggedAt: DateTime.now(),
      );
      await ref.read(diaryRepositoryProvider).insertLogEntry(entry);
      ref.invalidate(diaryEntriesForDateProvider(DateUtils.dateOnly(DateTime.now())));
      ref.invalidate(recentRecipesProvider);
    });
  }
}
