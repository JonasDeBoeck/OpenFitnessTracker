import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/diary/domain/day_label.dart';

void main() {
  group('diaryDayLabel', () {
    final today = DateTime(2026, 9, 17);

    test('is "Today" when selected is today', () {
      expect(diaryDayLabel(today, today), 'Today');
    });

    test('is "Yesterday" when selected is one day before today', () {
      expect(diaryDayLabel(DateTime(2026, 9, 16), today), 'Yesterday');
    });

    test('is "Tomorrow" when selected is one day after today', () {
      expect(diaryDayLabel(DateTime(2026, 9, 18), today), 'Tomorrow');
    });

    test('formats other dates as weekday, month abbreviation and day', () {
      expect(diaryDayLabel(DateTime(2026, 9, 10), today), 'Thu, Sep 10');
      expect(diaryDayLabel(DateTime(2026, 9, 25), today), 'Fri, Sep 25');
    });

    test('ignores time-of-day components', () {
      final selectedWithTime = DateTime(2026, 9, 17, 23, 45);
      final todayWithTime = DateTime(2026, 9, 17, 0, 5);
      expect(diaryDayLabel(selectedWithTime, todayWithTime), 'Today');
    });
  });
}
