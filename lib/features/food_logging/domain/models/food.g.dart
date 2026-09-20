// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  brand: json['brand'] as String?,
  store: json['store'] as String?,
  barcode: json['barcode'] as String?,
  photoPath: json['photoPath'] as String?,
  caloriesPer100g: (json['caloriesPer100g'] as num?)?.toDouble(),
  proteinPer100g: (json['proteinPer100g'] as num?)?.toDouble(),
  fatPer100g: (json['fatPer100g'] as num?)?.toDouble(),
  carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble(),
  fiberPer100g: (json['fiberPer100g'] as num?)?.toDouble(),
  sugarPer100g: (json['sugarPer100g'] as num?)?.toDouble(),
  sodiumMgPer100g: (json['sodiumMgPer100g'] as num?)?.toDouble(),
  cholesterolMgPer100g: (json['cholesterolMgPer100g'] as num?)?.toDouble(),
  potassiumMgPer100g: (json['potassiumMgPer100g'] as num?)?.toDouble(),
  calciumMgPer100g: (json['calciumMgPer100g'] as num?)?.toDouble(),
  ironMgPer100g: (json['ironMgPer100g'] as num?)?.toDouble(),
  vitaminCMgPer100g: (json['vitaminCMgPer100g'] as num?)?.toDouble(),
  vitaminDMcgPer100g: (json['vitaminDMcgPer100g'] as num?)?.toDouble(),
  isFavorite: json['isFavorite'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'brand': instance.brand,
  'store': instance.store,
  'barcode': instance.barcode,
  'photoPath': instance.photoPath,
  'caloriesPer100g': instance.caloriesPer100g,
  'proteinPer100g': instance.proteinPer100g,
  'fatPer100g': instance.fatPer100g,
  'carbsPer100g': instance.carbsPer100g,
  'fiberPer100g': instance.fiberPer100g,
  'sugarPer100g': instance.sugarPer100g,
  'sodiumMgPer100g': instance.sodiumMgPer100g,
  'cholesterolMgPer100g': instance.cholesterolMgPer100g,
  'potassiumMgPer100g': instance.potassiumMgPer100g,
  'calciumMgPer100g': instance.calciumMgPer100g,
  'ironMgPer100g': instance.ironMgPer100g,
  'vitaminCMgPer100g': instance.vitaminCMgPer100g,
  'vitaminDMcgPer100g': instance.vitaminDMcgPer100g,
  'isFavorite': instance.isFavorite,
  'createdAt': instance.createdAt?.toIso8601String(),
};
