import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../features/food_logging/data/tables/diary_entries_table.dart';
import '../../features/food_logging/data/tables/foods_table.dart';
import '../../features/food_logging/data/tables/recipe_ingredients_table.dart';
import '../../features/food_logging/data/tables/recipes_table.dart';
import '../../features/onboarding/data/tables/user_profiles_table.dart';
import '../../features/water/data/tables/water_entries_table.dart';

part 'app_database.g.dart';

// Future features register their own table here (and bump schemaVersion with
// an onUpgrade step) — table ownership stays feature-first, but the database
// instance and migration authority stay centralized in core/database.
@DriftDatabase(
  tables: [UserProfiles, Foods, DiaryEntries, Recipes, RecipeIngredients, WaterEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(foods);
        await migrator.createTable(diaryEntries);
      }
      if (from < 3) {
        await migrator.createTable(recipes);
        await migrator.createTable(recipeIngredients);
        // diaryEntries.foodId goes from NOT NULL to nullable (a logged
        // entry can now point at a recipe instead) — pre-release, with no
        // migration path for existing rows worth the complexity yet, so
        // the table is rebuilt empty rather than column-migrated in place.
        await migrator.deleteTable('diary_entries');
        await migrator.createTable(diaryEntries);
      }
      if (from < 4) {
        await migrator.createTable(waterEntries);
        await migrator.addColumn(userProfiles, userProfiles.waterTargetMl);
      }
      if (from < 5) {
        await migrator.addColumn(userProfiles, userProfiles.customTargetCalories);
        await migrator.addColumn(userProfiles, userProfiles.customProteinPerKg);
        await migrator.addColumn(userProfiles, userProfiles.customFatPerKg);
        await migrator.addColumn(userProfiles, userProfiles.customWaterTargetMl);
      }
      if (from < 6) {
        await migrator.addColumn(foods, foods.pieceLabel);
        await migrator.addColumn(foods, foods.pieceWeightGrams);
        await migrator.addColumn(recipeIngredients, recipeIngredients.unitLabel);
        await migrator.addColumn(recipeIngredients, recipeIngredients.unitCount);
        await migrator.addColumn(diaryEntries, diaryEntries.loggedUnitLabel);
        await migrator.addColumn(diaryEntries, diaryEntries.loggedUnitCount);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(documentsDir.path, 'app_database.sqlite'));

    // Android has no usable system tmp dir; without this, complex queries
    // can throw out-of-memory errors.
    final tempDir = await getTemporaryDirectory();
    sqlite3.tempDirectory = tempDir.path;

    return NativeDatabase.createInBackground(dbFile);
  });
}
