// test/features/food_logging/domain/quantity/piece_conversion_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/quantity/piece_conversion.dart';

void main() {
  group('gramsFromPieceCount', () {
    test('multiplies piece count by weight per piece', () {
      expect(gramsFromPieceCount(2, 60), 120);
    });

    test('supports fractional counts', () {
      expect(gramsFromPieceCount(1.5, 60), 90);
    });
  });

  group('pieceCountFromGrams', () {
    test('divides grams by weight per piece', () {
      expect(pieceCountFromGrams(120, 60), 2);
    });

    test('returns 0 for a zero weight per piece instead of dividing', () {
      expect(pieceCountFromGrams(120, 0), 0);
    });

    test('returns 0 for a negative weight per piece instead of dividing', () {
      expect(pieceCountFromGrams(120, -5), 0);
    });
  });
}
