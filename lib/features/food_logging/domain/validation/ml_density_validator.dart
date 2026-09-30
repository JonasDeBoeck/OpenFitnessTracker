/// Validates the Add/Edit Product screen's optional liquid density field.
/// Returns the error to show, or null when the value is valid (including
/// when it's unset).
String? mlDensityValidationError({required double? densityGramsPerMl}) {
  if (densityGramsPerMl == null) return null;
  if (densityGramsPerMl <= 0) {
    return 'Enter a density greater than zero, or clear it to skip this.';
  }
  return null;
}
