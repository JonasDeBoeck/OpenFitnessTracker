import 'package:drift/drift.dart';

@DataClassName('FoodRow')
class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get store => text().nullable()();
  // SQLite's UNIQUE constraint allows any number of NULL rows, so
  // barcode-less foods never collide with each other.
  TextColumn get barcode => text().nullable().unique()();
  TextColumn get photoPath => text().nullable()();
  RealColumn get caloriesPer100g => real().nullable()();
  RealColumn get proteinPer100g => real().nullable()();
  RealColumn get fatPer100g => real().nullable()();
  RealColumn get carbsPer100g => real().nullable()();
  RealColumn get fiberPer100g => real().nullable()();
  RealColumn get sugarPer100g => real().nullable()();
  RealColumn get sodiumMgPer100g => real().nullable()();
  RealColumn get cholesterolMgPer100g => real().nullable()();
  RealColumn get potassiumMgPer100g => real().nullable()();
  RealColumn get calciumMgPer100g => real().nullable()();
  RealColumn get ironMgPer100g => real().nullable()();
  RealColumn get vitaminCMgPer100g => real().nullable()();
  RealColumn get vitaminDMcgPer100g => real().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Optional "piece" unit — both null means this food is grams-only, same
  // as every food before this feature existed.
  TextColumn get pieceLabel => text().nullable()();
  RealColumn get pieceWeightGrams => real().nullable()();
}
