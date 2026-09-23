// test/features/food_logging/domain/quantity/logged_quantity_display_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/quantity/logged_quantity_display.dart';

void main() {
  group('formatLoggedQuantity', () {
    test('shows plain grams when no unit was used', () {
      expect(formatLoggedQuantity(grams: 120), '120g');
    });

    test('shows singular unit with grams in parentheses for a count of 1', () {
      expect(
        formatLoggedQuantity(grams: 60, unitLabel: 'carrot', unitCount: 1),
        '1 carrot (60g)',
      );
    });

    test('shows plural unit for a count other than 1', () {
      expect(
        formatLoggedQuantity(grams: 120, unitLabel: 'carrot', unitCount: 2),
        '2 carrots (120g)',
      );
    });

    test('trims a trailing .0 on a fractional count that resolves to a whole number', () {
      expect(
        formatLoggedQuantity(grams: 60, unitLabel: 'carrot', unitCount: 1.0),
        '1 carrot (60g)',
      );
    });

    test('keeps one decimal place for a genuinely fractional count', () {
      expect(
        formatLoggedQuantity(grams: 90, unitLabel: 'carrot', unitCount: 1.5),
        '1.5 carrots (90g)',
      );
    });

    test('does not pluralize the mL unit for a count other than 1', () {
      expect(
        formatLoggedQuantity(grams: 258, unitLabel: 'mL', unitCount: 250),
        '250 mL (258g)',
      );
    });

    test('does not pluralize the mL unit even for a count of 1', () {
      expect(
        formatLoggedQuantity(grams: 1, unitLabel: 'mL', unitCount: 1),
        '1 mL (1g)',
      );
    });

    test('does not pluralize the mL unit for a fractional count', () {
      expect(
        formatLoggedQuantity(grams: 129, unitLabel: 'mL', unitCount: 125.5),
        '125.5 mL (129g)',
      );
    });
  });
}
