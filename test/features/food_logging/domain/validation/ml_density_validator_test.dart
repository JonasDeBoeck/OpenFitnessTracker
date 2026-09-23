import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/validation/ml_density_validator.dart';

void main() {
  group('mlDensityValidationError', () {
    test('is valid when unset', () {
      expect(mlDensityValidationError(densityGramsPerMl: null), isNull);
    });

    test('is valid when positive', () {
      expect(mlDensityValidationError(densityGramsPerMl: 1.03), isNull);
    });

    test('errors when zero', () {
      expect(mlDensityValidationError(densityGramsPerMl: 0), isNotNull);
    });

    test('errors when negative', () {
      expect(mlDensityValidationError(densityGramsPerMl: -1), isNotNull);
    });
  });
}
