import 'package:drift/drift.dart';

@DataClassName('RecipeRow')
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // JSON-encoded List<String>, decoded/encoded in RecipeRepository — a
  // handful of free-text tags doesn't warrant its own join table.
  TextColumn get labels => text().withDefault(const Constant('[]'))();
  IntColumn get servings => integer().nullable()();
  TextColumn get prepTime => text().nullable()();
  TextColumn get cookTime => text().nullable()();
  // JSON-encoded List<String>, one entry per step.
  TextColumn get instructions => text().withDefault(const Constant('[]'))();
  TextColumn get photoPath => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
