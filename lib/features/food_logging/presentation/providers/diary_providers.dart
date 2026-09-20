import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/models/meal_type.dart';
import '../../data/diary_repository.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/food.dart';
import '../../domain/models/recipe.dart';
import 'food_detail_providers.dart';
import 'food_search_providers.dart';
import 'recipe_detail_providers.dart';
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

/// Deletes and edits already-logged diary entries (the Goals/Diary screens'
/// swipe-to-delete and tap-to-edit-quantity flows). `keepAlive` because
/// nothing watches this provider's own state — an autoDispose notifier with
/// no listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.
@Riverpod(keepAlive: true)
class DiaryEntryController extends _$DiaryEntryController {
  @override
  Future<void> build() async {}

  Future<void> delete(DateTime date, int entryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(diaryRepositoryProvider).deleteEntry(entryId);
      ref.invalidate(diaryEntriesForDateProvider(DateUtils.dateOnly(date)));
    });
  }

  /// Re-fetches the entry's underlying [Food]/[Recipe] and rescales its
  /// snapshotted nutrition to [newGrams] — the same [Food.scaledTo]/
  /// [Recipe.scaledTo] formula used when the entry was first logged.
  Future<void> updateQuantity({
    required DateTime date,
    required DiaryEntry entry,
    required double newGrams,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updated = entry.foodId != null
          ? await _rescaleFood(entry, newGrams)
          : await _rescaleRecipe(entry, newGrams);
      await ref.read(diaryRepositoryProvider).updateEntry(updated);
      ref.invalidate(diaryEntriesForDateProvider(DateUtils.dateOnly(date)));
    });
  }

  Future<DiaryEntry> _rescaleFood(DiaryEntry entry, double grams) async {
    final food = await ref.read(foodByIdProvider(entry.foodId!).future);
    final nutrition = food!.scaledTo(grams);
    return entry.copyWith(
      quantityGrams: grams,
      calories: nutrition.calories,
      protein: nutrition.protein,
      fat: nutrition.fat,
      carbs: nutrition.carbs,
      fiber: nutrition.fiber,
      sugar: nutrition.sugar,
      sodiumMg: nutrition.sodiumMg,
      cholesterolMg: nutrition.cholesterolMg,
      potassiumMg: nutrition.potassiumMg,
      calciumMg: nutrition.calciumMg,
      ironMg: nutrition.ironMg,
      vitaminCMg: nutrition.vitaminCMg,
      vitaminDMcg: nutrition.vitaminDMcg,
    );
  }

  Future<DiaryEntry> _rescaleRecipe(DiaryEntry entry, double grams) async {
    final recipe = await ref.read(recipeByIdProvider(entry.recipeId!).future);
    final nutrition = recipe!.scaledTo(grams);
    return entry.copyWith(
      quantityGrams: grams,
      calories: nutrition.calories,
      protein: nutrition.protein,
      fat: nutrition.fat,
      carbs: nutrition.carbs,
    );
  }
}
