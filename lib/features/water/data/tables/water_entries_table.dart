import 'package:drift/drift.dart';

@DataClassName('WaterEntryRow')
@TableIndex(name: 'idx_water_entries_logged_at', columns: {#loggedAt})
class WaterEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get loggedAt => dateTime()();
  RealColumn get milliliters => real()();
}
