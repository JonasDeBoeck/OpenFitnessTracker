import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/home/domain/greeting.dart';

void main() {
  group('greetingForHour', () {
    test('before noon is morning', () {
      expect(greetingForHour(0), 'Good morning');
      expect(greetingForHour(11), 'Good morning');
    });

    test('noon through late afternoon is afternoon', () {
      expect(greetingForHour(12), 'Good afternoon');
      expect(greetingForHour(17), 'Good afternoon');
    });

    test('evening onward is evening', () {
      expect(greetingForHour(18), 'Good evening');
      expect(greetingForHour(23), 'Good evening');
    });
  });

  group('formatFriendlyDate', () {
    test('formats weekday, month abbreviation and day', () {
      expect(
        formatFriendlyDate(DateTime(2026, 9, 17)),
        'Thursday, Sep 17',
      );
      expect(
        formatFriendlyDate(DateTime(2026, 1, 1)),
        'Thursday, Jan 1',
      );
    });
  });
}
