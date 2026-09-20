// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterEntry _$WaterEntryFromJson(Map<String, dynamic> json) => _WaterEntry(
  id: (json['id'] as num?)?.toInt(),
  loggedAt: DateTime.parse(json['loggedAt'] as String),
  milliliters: (json['milliliters'] as num).toDouble(),
);

Map<String, dynamic> _$WaterEntryToJson(_WaterEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'milliliters': instance.milliliters,
    };
