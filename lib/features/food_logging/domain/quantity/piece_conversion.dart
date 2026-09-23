/// The grams+unit pair a [PieceAwareQuantityField] reports back on every
/// change — [grams] is always populated (the value everything downstream
/// keys nutrition off of); [unitLabel]/[unitCount] are set only when the
/// field was in piece mode, both null when it was in grams mode.
class LoggedQuantity {
  const LoggedQuantity({required this.grams, this.unitLabel, this.unitCount});

  final double grams;
  final String? unitLabel;
  final double? unitCount;
}

/// Converts a piece count to grams using a food's average weight per piece.
double gramsFromPieceCount(double pieceCount, double weightPerPieceGrams) {
  return pieceCount * weightPerPieceGrams;
}

/// The inverse of [gramsFromPieceCount] — how many pieces [grams] is worth.
/// Guards a zero/negative [weightPerPieceGrams] by returning 0 rather than
/// dividing, since this is pure math with no caller-side invariant to lean
/// on (the Add Product form validates a positive weight, but this function
/// doesn't get to assume its caller always went through that form).
double pieceCountFromGrams(double grams, double weightPerPieceGrams) {
  if (weightPerPieceGrams <= 0) return 0;
  return grams / weightPerPieceGrams;
}
