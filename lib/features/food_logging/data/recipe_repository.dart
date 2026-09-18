import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../domain/models/recipe.dart';

part 'recipe_repository.g.dart';

class RecipeRepository {
  RecipeRepository(this._db);

  final AppDatabase _db;

  Future<List<Recipe>> searchByName(String query) async {
    final lowered = query.toLowerCase();
    final rows =
        await (_db.select(_db.recipes)
              ..where((t) => t.name.lower().like('%$lowered%'))
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return _fromRows(rows);
  }

  Future<Recipe?> getById(int id) async {
    final row = await (_db.select(
      _db.recipes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return (await _fromRows([row])).single;
  }

  Future<List<Recipe>> getAllSortedByName() async {
    final rows =
        await (_db.select(_db.recipes)
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return _fromRows(rows);
  }

  Future<List<Recipe>> getFavorites() async {
    final rows =
        await (_db.select(_db.recipes)
              ..where((t) => t.isFavorite.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return _fromRows(rows);
  }

  /// The distinct recipes behind the most recent diary log entries,
  /// most-recently-logged first — the recipe counterpart of
  /// [FoodRepository.getRecentLoggedFoods].
  Future<List<Recipe>> getRecentLoggedRecipes({int limit = 10}) async {
    final entryRows =
        await (_db.select(_db.diaryEntries)
              ..where((t) => t.recipeId.isNotNull())
              ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
              ..limit(limit * 5))
            .get();

    final orderedUniqueRecipeIds = <int>[];
    for (final entry in entryRows) {
      final recipeId = entry.recipeId!;
      if (!orderedUniqueRecipeIds.contains(recipeId)) {
        orderedUniqueRecipeIds.add(recipeId);
      }
      if (orderedUniqueRecipeIds.length >= limit) break;
    }

    final recipes = <Recipe>[];
    for (final recipeId in orderedUniqueRecipeIds) {
      final recipe = await getById(recipeId);
      if (recipe != null) recipes.add(recipe);
    }
    return recipes;
  }

  Future<Recipe> create(Recipe recipe) async {
    return _db.transaction(() async {
      final id = await _db.into(_db.recipes).insert(_toCompanion(recipe));
      for (final ingredient in recipe.ingredients) {
        await _db.into(_db.recipeIngredients).insert(
              _ingredientToCompanion(ingredient, recipeId: id),
            );
      }
      return (await getById(id))!;
    });
  }

  Future<void> toggleFavorite(int id) async {
    final recipe = await getById(id);
    if (recipe == null) return;
    await (_db.update(_db.recipes)..where((t) => t.id.equals(id))).write(
      RecipesCompanion(isFavorite: Value(!recipe.isFavorite)),
    );
  }

  RecipesCompanion _toCompanion(Recipe recipe) {
    return RecipesCompanion(
      id: recipe.id == null ? const Value.absent() : Value(recipe.id!),
      name: Value(recipe.name),
      labels: Value(jsonEncode(recipe.labels)),
      servings: Value(recipe.servings),
      prepTime: Value(recipe.prepTime),
      cookTime: Value(recipe.cookTime),
      instructions: Value(jsonEncode(recipe.instructions)),
      photoPath: Value(recipe.photoPath),
      isFavorite: Value(recipe.isFavorite),
    );
  }

  RecipeIngredientsCompanion _ingredientToCompanion(
    RecipeIngredient ingredient, {
    required int recipeId,
  }) {
    return RecipeIngredientsCompanion(
      recipeId: Value(recipeId),
      foodId: Value(ingredient.foodId),
      foodName: Value(ingredient.foodName),
      grams: Value(ingredient.grams),
      caloriesPer100g: Value(ingredient.caloriesPer100g),
      proteinPer100g: Value(ingredient.proteinPer100g),
      fatPer100g: Value(ingredient.fatPer100g),
      carbsPer100g: Value(ingredient.carbsPer100g),
    );
  }

  Future<List<Recipe>> _fromRows(List<RecipeRow> rows) async {
    if (rows.isEmpty) return const [];
    final ids = rows.map((r) => r.id).toList();
    final ingredientRows =
        await (_db.select(_db.recipeIngredients)
              ..where((t) => t.recipeId.isIn(ids)))
            .get();
    final ingredientsByRecipeId = <int, List<RecipeIngredient>>{};
    for (final row in ingredientRows) {
      ingredientsByRecipeId.putIfAbsent(row.recipeId, () => []).add(_ingredientFromRow(row));
    }
    return rows
        .map((row) => _fromRow(row, ingredientsByRecipeId[row.id] ?? const []))
        .toList();
  }

  Recipe _fromRow(RecipeRow row, List<RecipeIngredient> ingredients) {
    return Recipe(
      id: row.id,
      name: row.name,
      labels: (jsonDecode(row.labels) as List).cast<String>(),
      servings: row.servings,
      prepTime: row.prepTime,
      cookTime: row.cookTime,
      instructions: (jsonDecode(row.instructions) as List).cast<String>(),
      photoPath: row.photoPath,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      ingredients: ingredients,
    );
  }

  RecipeIngredient _ingredientFromRow(RecipeIngredientRow row) {
    return RecipeIngredient(
      id: row.id,
      foodId: row.foodId,
      foodName: row.foodName,
      grams: row.grams,
      caloriesPer100g: row.caloriesPer100g,
      proteinPer100g: row.proteinPer100g,
      fatPer100g: row.fatPer100g,
      carbsPer100g: row.carbsPer100g,
    );
  }
}

@Riverpod(keepAlive: true)
RecipeRepository recipeRepository(Ref ref) {
  return RecipeRepository(ref.watch(appDatabaseProvider));
}
