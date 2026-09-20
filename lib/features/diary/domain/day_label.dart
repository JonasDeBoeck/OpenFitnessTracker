import 'package:flutter/material.dart' show DateUtils;

const List<String> _weekdayAbbreviations = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
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

/// "Today"/"Yesterday"/"Tomorrow" for [selected] relative to [today],
/// otherwise a formatted "Wed, Sep 17".
String diaryDayLabel(DateTime selected, DateTime today) {
  final selectedDay = DateUtils.dateOnly(selected);
  final todayDay = DateUtils.dateOnly(today);
  final diffDays = selectedDay.difference(todayDay).inDays;

  if (diffDays == 0) return 'Today';
  if (diffDays == -1) return 'Yesterday';
  if (diffDays == 1) return 'Tomorrow';

  final weekday = _weekdayAbbreviations[selectedDay.weekday - 1];
  final month = _monthAbbreviations[selectedDay.month - 1];
  return '$weekday, $month ${selectedDay.day}';
}
