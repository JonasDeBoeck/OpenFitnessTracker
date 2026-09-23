/// Validates the Add/Edit Product screen's optional "Piece size" fields —
/// both must be set or both left blank, since a lone label or a lone
/// weight isn't a usable piece size. Returns the error to show, or null
/// when the pair is valid (including when both are unset).
String? pieceSizeValidationError({required String? label, required double? weightGrams}) {
  final hasLabel = label != null && label.trim().isNotEmpty;
  final hasWeight = weightGrams != null;
  if (hasWeight && weightGrams <= 0) {
    return 'Enter a weight greater than zero, or clear it to skip this.';
  }
  if (hasLabel == hasWeight) return null;
  return hasLabel
      ? 'Enter a weight per $label, or clear the label to skip this.'
      : 'Enter a label for this weight (e.g. "carrot"), or clear the weight to skip this.';
}
