import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/diary/domain/calendar_math.dart';

void main() {
  group('startOfWeek', () {
    test('returns the Monday of the week for a mid-week date', () {
      // 2026-09-17 is a Thursday.
      expect(startOfWeek(DateTime(2026, 9, 17)), DateTime(2026, 9, 14));
    });

    test('returns itself for a Monday', () {
      expect(startOfWeek(DateTime(2026, 9, 14)), DateTime(2026, 9, 14));
    });

    test('returns the same week\'s Monday for a Sunday', () {
      // 2026-09-20 is a Sunday, still in the week starting 2026-09-14.
      expect(startOfWeek(DateTime(2026, 9, 20)), DateTime(2026, 9, 14));
    });
  });

  group('weekDates', () {
    test('returns the 7 consecutive dates starting at weekStart', () {
      final dates = weekDates(DateTime(2026, 9, 14));
      expect(dates.length, 7);
      expect(dates.first, DateTime(2026, 9, 14));
      expect(dates.last, DateTime(2026, 9, 20));
      expect(
        dates,
        List.generate(7, (i) => DateTime(2026, 9, 14 + i)),
      );
    });
  });

  group('monthGridDates', () {
    test('pads a month to full Monday-Sunday weeks', () {
      // September 2026 starts on a Tuesday and ends on a Wednesday, so the
      // grid should run from Monday 2026-08-31 through Sunday 2026-10-04.
      final dates = monthGridDates(DateTime(2026, 9, 1));
      expect(dates.length, 35);
      expect(dates.first, DateTime(2026, 8, 31));
      expect(dates.last, DateTime(2026, 10, 4));
      expect(dates, contains(DateTime(2026, 9, 1)));
      expect(dates, contains(DateTime(2026, 9, 30)));
    });

    test('is anchored by month, ignoring the day component', () {
      final fromFirst = monthGridDates(DateTime(2026, 9, 1));
      final fromMidMonth = monthGridDates(DateTime(2026, 9, 17));
      expect(fromFirst, fromMidMonth);
    });
  });
}
