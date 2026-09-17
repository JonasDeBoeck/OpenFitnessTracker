const List<String> _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _monthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// A time-of-day-appropriate greeting, e.g. "Good morning".
String greetingForHour(int hour) {
  if (hour < 12) return 'Good morning';
  if (hour < 18) return 'Good afternoon';
  return 'Good evening';
}

/// Formats a date as e.g. "Wednesday, Sep 17".
String formatFriendlyDate(DateTime date) {
  final weekday = _weekdayNames[date.weekday - 1];
  final month = _monthAbbreviations[date.month - 1];
  return '$weekday, $month ${date.day}';
}
