import 'package:drift/drift.dart';

import 'foods_table.dart';
import 'recipes_table.dart';

@DataClassName('DiaryEntryRow')
@TableIndex(name: 'idx_diary_entries_logged_at', columns: {#loggedAt})
@TableIndex(name: 'idx_diary_entries_food_id', columns: {#foodId})
@TableIndex(name: 'idx_diary_entries_recipe_id', columns: {#recipeId})
class DiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Exactly one of foodId/recipeId is set, matching whichever was logged.
  IntColumn get foodId => integer().nullable().references(Foods, #id)();
  IntColumn get recipeId => integer().nullable().references(Recipes, #id)();
  // Snapshotted at log time, alongside every nutrition value below, so a
  // later rename/edit of the food or recipe never changes historical
  // entries.
  TextColumn get foodName => text().nullable()();
  TextColumn get recipeName => text().nullable()();
  TextColumn get mealType => text()(); // MealType.storageKey
  DateTimeColumn get loggedAt => dateTime()();
  RealColumn get quantityGrams => real()();
  RealColumn get calories => real()();
  RealColumn get protein => real()();
  RealColumn get fat => real()();
  RealColumn get carbs => real()();
  RealColumn get fiber => real().nullable()();
  RealColumn get sugar => real().nullable()();
  RealColumn get sodiumMg => real().nullable()();
  RealColumn get cholesterolMg => real().nullable()();
  RealColumn get potassiumMg => real().nullable()();
  RealColumn get calciumMg => real().nullable()();
  RealColumn get ironMg => real().nullable()();
  RealColumn get vitaminCMg => real().nullable()();
  RealColumn get vitaminDMcg => real().nullable()();
}
