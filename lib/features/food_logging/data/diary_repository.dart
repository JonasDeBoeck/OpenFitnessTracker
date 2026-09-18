import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../../../core/models/meal_type.dart';
import '../domain/models/diary_entry.dart';

part 'diary_repository.g.dart';

class DiaryRepository {
  DiaryRepository(this._db);

  final AppDatabase _db;

  Future<DiaryEntry> insertLogEntry(DiaryEntry entry) async {
    final id = await _db.into(_db.diaryEntries).insert(_toCompanion(entry));
    return entry.copyWith(id: id);
  }

  Future<List<DiaryEntry>> getEntriesForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows =
        await (_db.select(_db.diaryEntries)
              ..where((t) => t.loggedAt.isBetweenValues(start, end))
              ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
            .get();
    return rows.map(_fromRow).toList();
  }

  Future<List<DiaryEntry>> getEntriesForDateAndMeal(
    DateTime date,
    MealType mealType,
  ) async {
    final entries = await getEntriesForDate(date);
    return entries.where((e) => e.mealType == mealType).toList();
  }

  DiaryEntriesCompanion _toCompanion(DiaryEntry entry) {
    return DiaryEntriesCompanion(
      id: entry.id == null ? const Value.absent() : Value(entry.id!),
      foodId: Value(entry.foodId),
      foodName: Value(entry.foodName),
      recipeId: Value(entry.recipeId),
      recipeName: Value(entry.recipeName),
      mealType: Value(entry.mealType.storageKey),
      loggedAt: Value(entry.loggedAt),
      quantityGrams: Value(entry.quantityGrams),
      calories: Value(entry.calories),
      protein: Value(entry.protein),
      fat: Value(entry.fat),
      carbs: Value(entry.carbs),
      fiber: Value(entry.fiber),
      sugar: Value(entry.sugar),
      sodiumMg: Value(entry.sodiumMg),
      cholesterolMg: Value(entry.cholesterolMg),
      potassiumMg: Value(entry.potassiumMg),
      calciumMg: Value(entry.calciumMg),
      ironMg: Value(entry.ironMg),
      vitaminCMg: Value(entry.vitaminCMg),
      vitaminDMcg: Value(entry.vitaminDMcg),
    );
  }

  DiaryEntry _fromRow(DiaryEntryRow row) {
    return DiaryEntry(
      id: row.id,
      foodId: row.foodId,
      foodName: row.foodName,
      recipeId: row.recipeId,
      recipeName: row.recipeName,
      mealType: MealType.fromStorageKey(row.mealType),
      loggedAt: row.loggedAt,
      quantityGrams: row.quantityGrams,
      calories: row.calories,
      protein: row.protein,
      fat: row.fat,
      carbs: row.carbs,
      fiber: row.fiber,
      sugar: row.sugar,
      sodiumMg: row.sodiumMg,
      cholesterolMg: row.cholesterolMg,
      potassiumMg: row.potassiumMg,
      calciumMg: row.calciumMg,
      ironMg: row.ironMg,
      vitaminCMg: row.vitaminCMg,
      vitaminDMcg: row.vitaminDMcg,
    );
  }
}

@Riverpod(keepAlive: true)
DiaryRepository diaryRepository(Ref ref) {
  return DiaryRepository(ref.watch(appDatabaseProvider));
}
