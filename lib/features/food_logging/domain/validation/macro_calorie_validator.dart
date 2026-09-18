/// How far `protein×4 + carbs×4 + fat×9` may drift from the stated calories
/// before it's flagged as a likely data-entry/OCR mistake.
const double _maxCalorieMacroVariance = 0.20;

/// Returns true when protein/fat/carbs roughly account for the stated
/// calories (within [_maxCalorieMacroVariance]). Also returns true (i.e. no
/// warning) when any of the four values is missing or calories is zero,
/// since there's nothing meaningful to compare in that case.
bool macrosRoughlyMatchCalories({
  required double? calories,
  required double? protein,
  required double? fat,
  required double? carbs,
}) {
  if (calories == null || protein == null || fat == null || carbs == null) {
    return true;
  }
  if (calories <= 0) return true;

  final expectedCalories = protein * 4 + carbs * 4 + fat * 9;
  final variance = (expectedCalories - calories).abs() / calories;
  return variance <= _maxCalorieMacroVariance;
}
