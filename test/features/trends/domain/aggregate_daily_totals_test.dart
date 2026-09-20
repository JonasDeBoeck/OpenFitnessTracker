import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/core/models/meal_type.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/diary_entry.dart';
import 'package:open_fitness_tracker/features/trends/domain/aggregate_daily_totals.dart';

DiaryEntry _entry({
  required DateTime loggedAt,
  required double calories,
  required double protein,
  required double fat,
  required double carbs,
}) {
  return DiaryEntry(
    mealType: MealType.breakfast,
    loggedAt: loggedAt,
    quantityGrams: 100,
    calories: calories,
    protein: protein,
    fat: fat,
    carbs: carbs,
  );
}

void main() {
  group('aggregateDailyTotals', () {
    test('sums same-day entries and zero-fills days with nothing logged', () {
      final start = DateTime(2026, 9, 1);
      final end = DateTime(2026, 9, 3);
      final entries = [
        _entry(
          loggedAt: DateTime(2026, 9, 1, 8),
          calories: 300,
          protein: 20,
          fat: 10,
          carbs: 30,
        ),
        _entry(
          loggedAt: DateTime(2026, 9, 1, 19),
          calories: 500,
          protein: 30,
          fat: 15,
          carbs: 50,
        ),
        _entry(
          loggedAt: DateTime(2026, 9, 3, 12),
          calories: 400,
          protein: 25,
          fat: 12,
          carbs: 40,
        ),
      ];

      final totals = aggregateDailyTotals(
        entries: entries,
        start: start,
        end: end,
      );

      expect(totals.length, 3);
      expect(totals[0].date, DateTime(2026, 9, 1));
      expect(totals[0].calories, 800);
      expect(totals[0].protein, 50);
      expect(totals[0].fat, 25);
      expect(totals[0].carbs, 80);

      expect(totals[1].date, DateTime(2026, 9, 2));
      expect(totals[1].calories, 0);
      expect(totals[1].protein, 0);
      expect(totals[1].fat, 0);
      expect(totals[1].carbs, 0);

      expect(totals[2].date, DateTime(2026, 9, 3));
      expect(totals[2].calories, 400);
    });

    test('a single-day range returns exactly one entry', () {
      final day = DateTime(2026, 9, 5);
      final totals = aggregateDailyTotals(entries: [], start: day, end: day);

      expect(totals.length, 1);
      expect(totals.single.date, day);
      expect(totals.single.calories, 0);
    });
  });
}
