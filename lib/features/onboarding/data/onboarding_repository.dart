import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../domain/models/activity_level.dart';
import '../domain/models/goal.dart';
import '../domain/models/sex.dart';
import '../domain/models/user_profile.dart';

part 'onboarding_repository.g.dart';

// The user profile table is treated as a logical singleton for v1: this
// repository always upserts a single row with a fixed id, leaving the
// autoincrement PK free to support multiple profiles later without a
// schema change.
const int _singletonProfileId = 1;

class OnboardingRepository {
  OnboardingRepository(this._db);

  final AppDatabase _db;

  Future<UserProfile?> getProfile() async {
    final row = await (_db.select(
      _db.userProfiles,
    )..where((t) => t.id.equals(_singletonProfileId))).getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _db
        .into(_db.userProfiles)
        .insertOnConflictUpdate(
          UserProfilesCompanion.insert(
            id: const Value(_singletonProfileId),
            name: profile.name,
            sex: profile.sex.storageKey,
            age: profile.age,
            heightCm: profile.heightCm,
            weightKg: profile.weightKg,
            activityLevel: profile.activityLevel.storageKey,
            goal: profile.goal.storageKey,
            bmr: profile.bmr,
            tdee: profile.tdee,
            targetCalories: profile.targetCalories,
            proteinGrams: profile.proteinGrams,
            fatGrams: profile.fatGrams,
            carbGrams: profile.carbGrams,
          ),
        );
  }

  UserProfile _fromRow(UserProfileRow row) {
    return UserProfile(
      id: row.id,
      name: row.name,
      sex: Sex.fromStorageKey(row.sex),
      age: row.age,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      activityLevel: ActivityLevel.fromStorageKey(row.activityLevel),
      goal: Goal.fromStorageKey(row.goal),
      bmr: row.bmr,
      tdee: row.tdee,
      targetCalories: row.targetCalories,
      proteinGrams: row.proteinGrams,
      fatGrams: row.fatGrams,
      carbGrams: row.carbGrams,
      createdAt: row.createdAt,
    );
  }
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepository(ref.watch(appDatabaseProvider));
}
