// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryEntry _$DiaryEntryFromJson(Map<String, dynamic> json) => _DiaryEntry(
  id: (json['id'] as num?)?.toInt(),
  foodId: (json['foodId'] as num?)?.toInt(),
  foodName: json['foodName'] as String?,
  recipeId: (json['recipeId'] as num?)?.toInt(),
  recipeName: json['recipeName'] as String?,
  mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
  loggedAt: DateTime.parse(json['loggedAt'] as String),
  quantityGrams: (json['quantityGrams'] as num).toDouble(),
  calories: (json['calories'] as num).toDouble(),
  protein: (json['protein'] as num).toDouble(),
  fat: (json['fat'] as num).toDouble(),
  carbs: (json['carbs'] as num).toDouble(),
  fiber: (json['fiber'] as num?)?.toDouble(),
  sugar: (json['sugar'] as num?)?.toDouble(),
  sodiumMg: (json['sodiumMg'] as num?)?.toDouble(),
  cholesterolMg: (json['cholesterolMg'] as num?)?.toDouble(),
  potassiumMg: (json['potassiumMg'] as num?)?.toDouble(),
  calciumMg: (json['calciumMg'] as num?)?.toDouble(),
  ironMg: (json['ironMg'] as num?)?.toDouble(),
  vitaminCMg: (json['vitaminCMg'] as num?)?.toDouble(),
  vitaminDMcg: (json['vitaminDMcg'] as num?)?.toDouble(),
  loggedUnitLabel: json['loggedUnitLabel'] as String?,
  loggedUnitCount: (json['loggedUnitCount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DiaryEntryToJson(_DiaryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foodId': instance.foodId,
      'foodName': instance.foodName,
      'recipeId': instance.recipeId,
      'recipeName': instance.recipeName,
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'quantityGrams': instance.quantityGrams,
      'calories': instance.calories,
      'protein': instance.protein,
      'fat': instance.fat,
      'carbs': instance.carbs,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodiumMg': instance.sodiumMg,
      'cholesterolMg': instance.cholesterolMg,
      'potassiumMg': instance.potassiumMg,
      'calciumMg': instance.calciumMg,
      'ironMg': instance.ironMg,
      'vitaminCMg': instance.vitaminCMg,
      'vitaminDMcg': instance.vitaminDMcg,
      'loggedUnitLabel': instance.loggedUnitLabel,
      'loggedUnitCount': instance.loggedUnitCount,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snacks: 'snacks',
};
