import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_entry.freezed.dart';
part 'water_entry.g.dart';

/// A single logged water amount.
@freezed
abstract class WaterEntry with _$WaterEntry {
  const factory WaterEntry({
    int? id,
    required DateTime loggedAt,
    required double milliliters,
  }) = _WaterEntry;

  factory WaterEntry.fromJson(Map<String, dynamic> json) =>
      _$WaterEntryFromJson(json);
}
