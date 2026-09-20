import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_level.dart';
import 'goal.dart';
import 'sex.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    int? id,
    required String name,
    required Sex sex,
    required int age,
    required double heightCm,
    required double weightKg,
    required ActivityLevel activityLevel,
    required Goal goal,
    required double bmr,
    required double tdee,
    required double targetCalories,
    required double proteinGrams,
    required double fatGrams,
    required double carbGrams,
    required double waterTargetMl,
    DateTime? createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
