import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../domain/models/water_entry.dart';

part 'water_repository.g.dart';

class WaterRepository {
  WaterRepository(this._db);

  final AppDatabase _db;

  Future<WaterEntry> insertEntry(WaterEntry entry) async {
    final id = await _db.into(_db.waterEntries).insert(_toCompanion(entry));
    return entry.copyWith(id: id);
  }

  Future<void> deleteEntry(int id) async {
    await (_db.delete(
      _db.waterEntries,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<List<WaterEntry>> getEntriesForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final rows =
        await (_db.select(_db.waterEntries)
              ..where((t) => t.loggedAt.isBetweenValues(start, end))
              ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
            .get();
    return rows.map(_fromRow).toList();
  }

  /// All entries logged between [start] and [end] (day-bounded, inclusive
  /// of both ends), ordered by date. Used to build the Trends chart.
  Future<List<WaterEntry>> getEntriesInRange(
    DateTime start,
    DateTime end,
  ) async {
    final rangeStart = DateTime(start.year, start.month, start.day);
    final rangeEnd = DateTime(
      end.year,
      end.month,
      end.day,
    ).add(const Duration(days: 1));
    final rows =
        await (_db.select(_db.waterEntries)
              ..where((t) => t.loggedAt.isBetweenValues(rangeStart, rangeEnd))
              ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
            .get();
    return rows.map(_fromRow).toList();
  }

  WaterEntriesCompanion _toCompanion(WaterEntry entry) {
    return WaterEntriesCompanion(
      id: entry.id == null ? const Value.absent() : Value(entry.id!),
      loggedAt: Value(entry.loggedAt),
      milliliters: Value(entry.milliliters),
    );
  }

  WaterEntry _fromRow(WaterEntryRow row) {
    return WaterEntry(
      id: row.id,
      loggedAt: row.loggedAt,
      milliliters: row.milliliters,
    );
  }
}

@Riverpod(keepAlive: true)
WaterRepository waterRepository(Ref ref) {
  return WaterRepository(ref.watch(appDatabaseProvider));
}
