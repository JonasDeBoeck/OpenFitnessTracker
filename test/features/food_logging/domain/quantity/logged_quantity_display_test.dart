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
  });
}
