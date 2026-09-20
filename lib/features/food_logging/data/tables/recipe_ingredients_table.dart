import 'package:drift/drift.dart';

import 'foods_table.dart';
import 'recipes_table.dart';

@DataClassName('RecipeIngredientRow')
@TableIndex(name: 'idx_recipe_ingredients_recipe_id', columns: {#recipeId})
class RecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(Recipes, #id)();
  IntColumn get foodId => integer().references(Foods, #id)();
  // Snapshotted at add time, alongside the macros below, so a later
  // rename/edit of the food never changes an existing recipe's totals.
  TextColumn get foodName => text()();
  RealColumn get grams => real()();
  RealColumn get caloriesPer100g => real()();
  RealColumn get proteinPer100g => real()();
  RealColumn get fatPer100g => real()();
  RealColumn get carbsPer100g => real()();
}
