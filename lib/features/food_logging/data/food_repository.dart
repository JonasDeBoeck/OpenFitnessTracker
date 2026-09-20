import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../domain/exceptions/duplicate_barcode_exception.dart';
import '../domain/models/food.dart';

part 'food_repository.g.dart';

class FoodRepository {
  FoodRepository(this._db);

  final AppDatabase _db;

  Future<List<Food>> searchByName(String query) async {
    final lowered = query.toLowerCase();
    final rows =
        await (_db.select(_db.foods)
              ..where((t) => t.name.lower().like('%$lowered%'))
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return rows.map(_fromRow).toList();
  }

  Future<Food?> getById(int id) async {
    final row = await (_db.select(
      _db.foods,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<Food?> getByBarcode(String barcode) async {
    final row = await (_db.select(
      _db.foods,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<List<Food>> getAllSortedByName() async {
    final rows =
        await (_db.select(_db.foods)
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return rows.map(_fromRow).toList();
  }

  Future<List<Food>> getFavorites() async {
    final rows =
        await (_db.select(_db.foods)
              ..where((t) => t.isFavorite.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return rows.map(_fromRow).toList();
  }

  /// The distinct foods behind the most recent diary log entries,
  /// most-recently-logged first. "Recent" is never stored on its own — it's
  /// always derived live from the diary.
  Future<List<Food>> getRecentLoggedFoods({int limit = 10}) async {
    final entryRows =
        await (_db.select(_db.diaryEntries)
              ..where((t) => t.foodId.isNotNull())
              ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)])
              ..limit(limit * 5))
            .get();

    final orderedUniqueFoodIds = <int>[];
    for (final entry in entryRows) {
      final foodId = entry.foodId!;
      if (!orderedUniqueFoodIds.contains(foodId)) {
        orderedUniqueFoodIds.add(foodId);
      }
      if (orderedUniqueFoodIds.length >= limit) break;
    }

    final foods = <Food>[];
    for (final foodId in orderedUniqueFoodIds) {
      final food = await getById(foodId);
      if (food != null) foods.add(food);
    }
    return foods;
  }

  Future<Food> create(Food food) async {
    await _assertBarcodeAvailable(food.barcode);
    final id = await _db.into(_db.foods).insert(_toCompanion(food));
    return food.copyWith(id: id);
  }

  Future<void> update(Food food) async {
    await _assertBarcodeAvailable(food.barcode, excludingId: food.id);
    await (_db.update(
      _db.foods,
    )..where((t) => t.id.equals(food.id!))).write(_toCompanion(food));
  }

  Future<void> toggleFavorite(int id) async {
    final food = await getById(id);
    if (food == null) return;
    await (_db.update(_db.foods)..where((t) => t.id.equals(id))).write(
      FoodsCompanion(isFavorite: Value(!food.isFavorite)),
    );
  }

  Future<void> _assertBarcodeAvailable(String? barcode, {int? excludingId}) async {
    if (barcode == null || barcode.isEmpty) return;
    final existing = await getByBarcode(barcode);
    if (existing != null && existing.id != excludingId) {
      throw DuplicateBarcodeException(barcode, existing.name);
    }
  }

  FoodsCompanion _toCompanion(Food food) {
    return FoodsCompanion(
      id: food.id == null ? const Value.absent() : Value(food.id!),
      name: Value(food.name),
      brand: Value(food.brand),
      store: Value(food.store),
      barcode: Value(food.barcode),
      photoPath: Value(food.photoPath),
      caloriesPer100g: Value(food.caloriesPer100g),
      proteinPer100g: Value(food.proteinPer100g),
      fatPer100g: Value(food.fatPer100g),
      carbsPer100g: Value(food.carbsPer100g),
      fiberPer100g: Value(food.fiberPer100g),
      sugarPer100g: Value(food.sugarPer100g),
      sodiumMgPer100g: Value(food.sodiumMgPer100g),
      cholesterolMgPer100g: Value(food.cholesterolMgPer100g),
      potassiumMgPer100g: Value(food.potassiumMgPer100g),
      calciumMgPer100g: Value(food.calciumMgPer100g),
      ironMgPer100g: Value(food.ironMgPer100g),
      vitaminCMgPer100g: Value(food.vitaminCMgPer100g),
      vitaminDMcgPer100g: Value(food.vitaminDMcgPer100g),
      isFavorite: Value(food.isFavorite),
    );
  }

  Food _fromRow(FoodRow row) {
    return Food(
      id: row.id,
      name: row.name,
      brand: row.brand,
      store: row.store,
      barcode: row.barcode,
      photoPath: row.photoPath,
      caloriesPer100g: row.caloriesPer100g,
      proteinPer100g: row.proteinPer100g,
      fatPer100g: row.fatPer100g,
      carbsPer100g: row.carbsPer100g,
      fiberPer100g: row.fiberPer100g,
      sugarPer100g: row.sugarPer100g,
      sodiumMgPer100g: row.sodiumMgPer100g,
      cholesterolMgPer100g: row.cholesterolMgPer100g,
      potassiumMgPer100g: row.potassiumMgPer100g,
      calciumMgPer100g: row.calciumMgPer100g,
      ironMgPer100g: row.ironMgPer100g,
      vitaminCMgPer100g: row.vitaminCMgPer100g,
      vitaminDMcgPer100g: row.vitaminDMcgPer100g,
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
    );
  }
}

@Riverpod(keepAlive: true)
FoodRepository foodRepository(Ref ref) {
  return FoodRepository(ref.watch(appDatabaseProvider));
}
