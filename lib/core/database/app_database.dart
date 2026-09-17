import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../features/onboarding/data/tables/user_profiles_table.dart';

part 'app_database.g.dart';

// Future features register their own table here (and bump schemaVersion with
// an onUpgrade step) — table ownership stays feature-first, but the database
// instance and migration authority stay centralized in core/database.
@DriftDatabase(tables: [UserProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
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
