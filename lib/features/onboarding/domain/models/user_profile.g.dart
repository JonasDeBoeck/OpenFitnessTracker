// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  sex: $enumDecode(_$SexEnumMap, json['sex']),
  age: (json['age'] as num).toInt(),
  heightCm: (json['heightCm'] as num).toDouble(),
  weightKg: (json['weightKg'] as num).toDouble(),
  activityLevel: $enumDecode(_$ActivityLevelEnumMap, json['activityLevel']),
  goal: $enumDecode(_$GoalEnumMap, json['goal']),
  bmr: (json['bmr'] as num).toDouble(),
  tdee: (json['tdee'] as num).toDouble(),
  targetCalories: (json['targetCalories'] as num).toDouble(),
  proteinGrams: (json['proteinGrams'] as num).toDouble(),
  fatGrams: (json['fatGrams'] as num).toDouble(),
  carbGrams: (json['carbGrams'] as num).toDouble(),
  waterTargetMl: (json['waterTargetMl'] as num).toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sex': _$SexEnumMap[instance.sex]!,
      'age': instance.age,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
      'goal': _$GoalEnumMap[instance.goal]!,
      'bmr': instance.bmr,
      'tdee': instance.tdee,
      'targetCalories': instance.targetCalories,
      'proteinGrams': instance.proteinGrams,
      'fatGrams': instance.fatGrams,
      'carbGrams': instance.carbGrams,
      'waterTargetMl': instance.waterTargetMl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$SexEnumMap = {Sex.male: 'male', Sex.female: 'female'};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.light: 'light',
  ActivityLevel.moderate: 'moderate',
  ActivityLevel.active: 'active',
  ActivityLevel.veryActive: 'veryActive',
};

const _$GoalEnumMap = {
  Goal.cut: 'cut',
  Goal.bulk: 'bulk',
  Goal.maintain: 'maintain',
};
