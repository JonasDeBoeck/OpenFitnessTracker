/// A generic alternate unit a food can optionally be logged in, besides
/// grams — either a countable piece ("1 carrot") or a volume ("250 mL"),
/// built by [Food.alternateUnit] from whichever underlying fields are set.
class AlternateUnit {
  const AlternateUnit({
    required this.label,
    required this.weightPerUnitGrams,
    required this.step,
    required this.pluralize,
  });

  /// The unit's display name — a freeform word for a piece ("carrot"), or
  /// always "mL" for a volume unit.
  final String label;

  /// How many grams one unit of this is worth — a piece's average weight,
  /// or a liquid's density in grams per mL.
  final double weightPerUnitGrams;

  /// How much the quantity-entry stepper's +/- buttons change the count by
  /// — 1 for a piece (can't step by a fraction of a whole item), 50 for
  /// mL (a sensible liquid-measuring increment).
  final double step;

  /// Whether [label] pluralizes for a count other than 1 ("carrot" →
  /// "carrots"). Always false for mL, the one fixed, non-freeform label in
  /// the system.
  final bool pluralize;
}

/// The fixed label every volume-unit food uses — never user-entered,
/// unlike a piece's freeform label.
const mlUnitLabel = 'mL';
