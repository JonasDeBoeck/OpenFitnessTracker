// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) =>
    _RecipeIngredient(
      id: (json['id'] as num?)?.toInt(),
      foodId: (json['foodId'] as num).toInt(),
      foodName: json['foodName'] as String,
      grams: (json['grams'] as num).toDouble(),
      caloriesPer100g: (json['caloriesPer100g'] as num).toDouble(),
      proteinPer100g: (json['proteinPer100g'] as num).toDouble(),
      fatPer100g: (json['fatPer100g'] as num).toDouble(),
      carbsPer100g: (json['carbsPer100g'] as num).toDouble(),
      unitLabel: json['unitLabel'] as String?,
      unitCount: (json['unitCount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RecipeIngredientToJson(_RecipeIngredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foodId': instance.foodId,
      'foodName': instance.foodName,
      'grams': instance.grams,
      'caloriesPer100g': instance.caloriesPer100g,
      'proteinPer100g': instance.proteinPer100g,
      'fatPer100g': instance.fatPer100g,
      'carbsPer100g': instance.carbsPer100g,
      'unitLabel': instance.unitLabel,
      'unitCount': instance.unitCount,
    };

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  labels:
      (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  servings: (json['servings'] as num?)?.toInt(),
  prepTime: json['prepTime'] as String?,
  cookTime: json['cookTime'] as String?,
  instructions:
      (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  photoPath: json['photoPath'] as String?,
  isFavorite: json['isFavorite'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecipeIngredient>[],
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'labels': instance.labels,
  'servings': instance.servings,
  'prepTime': instance.prepTime,
  'cookTime': instance.cookTime,
  'instructions': instance.instructions,
  'photoPath': instance.photoPath,
  'isFavorite': instance.isFavorite,
  'createdAt': instance.createdAt?.toIso8601String(),
  'ingredients': instance.ingredients,
};
