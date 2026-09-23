// test/features/food_logging/domain/validation/piece_size_validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/validation/piece_size_validator.dart';

void main() {
  group('pieceSizeValidationError', () {
    test('is valid when both label and weight are unset', () {
      expect(pieceSizeValidationError(label: null, weightGrams: null), isNull);
    });

    test('is valid when both label and weight are set', () {
      expect(pieceSizeValidationError(label: 'carrot', weightGrams: 60), isNull);
    });

    test('errors when only the label is set', () {
      expect(pieceSizeValidationError(label: 'carrot', weightGrams: null), isNotNull);
    });

    test('errors when only the weight is set', () {
      expect(pieceSizeValidationError(label: null, weightGrams: 60), isNotNull);
    });

    test('treats a blank label as unset', () {
      expect(pieceSizeValidationError(label: '   ', weightGrams: 60), isNotNull);
    });
  });
}
