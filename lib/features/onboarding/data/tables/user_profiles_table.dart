import 'package:drift/drift.dart';

@DataClassName('UserProfileRow')
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get sex => text()();
  IntColumn get age => integer()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();
  TextColumn get activityLevel => text()();
  TextColumn get goal => text()();
  RealColumn get bmr => real()();
  RealColumn get tdee => real()();
  RealColumn get targetCalories => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get fatGrams => real()();
  RealColumn get carbGrams => real()();
  RealColumn get waterTargetMl => real().withDefault(const Constant(0))();
  RealColumn get customTargetCalories => real().nullable()();
  RealColumn get customProteinPerKg => real().nullable()();
  RealColumn get customFatPerKg => real().nullable()();
  RealColumn get customWaterTargetMl => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
