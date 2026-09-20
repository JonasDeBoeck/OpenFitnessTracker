import 'package:freezed_annotation/freezed_annotation.dart';

part 'parsed_nutrition_label.freezed.dart';

/// The result of running OCR + parsing over a nutrition label photo.
/// Never persisted directly — its fields feed into the add-product form,
/// which the user can still review and edit before saving.
@freezed
abstract class ParsedNutritionLabel with _$ParsedNutritionLabel {
  const factory ParsedNutritionLabel({
    // False means the parser could not confidently find a "per 100g"
    // column on the label, so every field below is null — it never
    // converts from a per-serving column.
    required bool matchedPer100gColumn,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? fatPer100g,
    double? carbsPer100g,
    double? fiberPer100g,
    double? sugarPer100g,
    double? sodiumMgPer100g,
    double? cholesterolMgPer100g,
    double? potassiumMgPer100g,
    double? calciumMgPer100g,
    double? ironMgPer100g,
    double? vitaminCMgPer100g,
    double? vitaminDMcgPer100g,
  }) = _ParsedNutritionLabel;
}
