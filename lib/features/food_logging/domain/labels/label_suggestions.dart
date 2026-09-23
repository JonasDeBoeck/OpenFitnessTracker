/// The already-used, not-yet-selected labels whose text contains [draft]
/// (case-insensitive; all of them when [draft] is blank) — the chips
/// offered below the label field.
List<String> filterLabelSuggestions({
  required List<String> existingLabels,
  required List<String> selectedLabels,
  required String draft,
}) {
  final query = draft.trim().toLowerCase();
  final selectedLower = selectedLabels.map((l) => l.toLowerCase()).toSet();
  return existingLabels
      .where((label) => !selectedLower.contains(label.toLowerCase()))
      .where((label) => query.isEmpty || label.toLowerCase().contains(query))
      .toList();
}

/// An existing label matching [draft] exactly (case-insensitive), if any —
/// used so submitting the field selects that label's canonical casing
/// instead of adding a case-variant duplicate.
String? findExistingLabel(List<String> existingLabels, String draft) {
  final query = draft.trim().toLowerCase();
  for (final label in existingLabels) {
    if (label.toLowerCase() == query) return label;
  }
  return null;
}

/// Whether the label field's "Add" chip for the current draft should be
/// offered: there's text, it isn't already selected, and it doesn't
/// exactly match an existing label (that case is a selection, not a new
/// label).
bool shouldOfferNewLabel({
  required List<String> existingLabels,
  required List<String> selectedLabels,
  required String draft,
}) {
  final trimmed = draft.trim();
  if (trimmed.isEmpty) return false;
  final trimmedLower = trimmed.toLowerCase();
  if (selectedLabels.any((l) => l.toLowerCase() == trimmedLower)) return false;
  return findExistingLabel(existingLabels, trimmed) == null;
}
