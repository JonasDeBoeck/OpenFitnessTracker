/// Formats an already-logged quantity for display: "2 carrots (120g)" when
/// a piece unit was used to log it, or plain "120g" otherwise — shared by
/// the diary meal list and the recipe ingredient list, the two places a
/// snapshotted grams+unit pair is shown back to the user.
String formatLoggedQuantity({
  required double grams,
  String? unitLabel,
  double? unitCount,
}) {
  final gramsText = '${grams.toStringAsFixed(0)}g';
  if (unitLabel == null || unitCount == null) return gramsText;
  final countText = _trimTrailingZero(unitCount);
  final label = unitCount == 1 ? unitLabel : '${unitLabel}s';
  return '$countText $label ($gramsText)';
}

String _trimTrailingZero(double value) {
  final text = value.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
