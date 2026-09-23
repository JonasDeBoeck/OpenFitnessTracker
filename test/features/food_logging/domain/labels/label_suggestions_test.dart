import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/labels/label_suggestions.dart';

void main() {
  group('filterLabelSuggestions', () {
    const existing = ['High protein', 'Meal prep', 'Vegetarian'];

    test('returns every existing label not already selected when draft is blank', () {
      expect(
        filterLabelSuggestions(existingLabels: existing, selectedLabels: const [], draft: ''),
        existing,
      );
    });

    test('excludes already-selected labels', () {
      expect(
        filterLabelSuggestions(
          existingLabels: existing,
          selectedLabels: const ['Meal prep'],
          draft: '',
        ),
        ['High protein', 'Vegetarian'],
      );
    });

    test('filters by a case-insensitive substring match', () {
      expect(
        filterLabelSuggestions(existingLabels: existing, selectedLabels: const [], draft: 'PRO'),
        ['High protein'],
      );
    });
  });

  group('findExistingLabel', () {
    const existing = ['High protein', 'Meal prep'];

    test('finds a case-insensitive exact match and returns its canonical casing', () {
      expect(findExistingLabel(existing, 'meal prep'), 'Meal prep');
    });

    test('returns null when nothing matches exactly', () {
      expect(findExistingLabel(existing, 'meal'), isNull);
    });
  });

  group('shouldOfferNewLabel', () {
    const existing = ['High protein', 'Meal prep'];

    test('is false for a blank draft', () {
      expect(
        shouldOfferNewLabel(existingLabels: existing, selectedLabels: const [], draft: '  '),
        isFalse,
      );
    });

    test('is false when the draft exactly matches an existing label', () {
      expect(
        shouldOfferNewLabel(existingLabels: existing, selectedLabels: const [], draft: 'meal prep'),
        isFalse,
      );
    });

    test('is false when the draft is already selected', () {
      expect(
        shouldOfferNewLabel(
          existingLabels: existing,
          selectedLabels: const ['Quick'],
          draft: 'Quick',
        ),
        isFalse,
      );
    });

    test('is true for genuinely new text', () {
      expect(
        shouldOfferNewLabel(existingLabels: existing, selectedLabels: const [], draft: 'Quick'),
        isTrue,
      );
    });
  });
}
