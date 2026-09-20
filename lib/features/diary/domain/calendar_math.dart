import 'package:flutter/material.dart' show DateUtils;

/// The Monday of the week containing [date].
DateTime startOfWeek(DateTime date) {
  final day = DateUtils.dateOnly(date);
  final diff = day.weekday - DateTime.monday; // 0 (Mon) .. 6 (Sun)
  return day.subtract(Duration(days: diff));
}

/// The 7 dates (Monday-Sunday) of the week starting at [weekStart].
List<DateTime> weekDates(DateTime weekStart) => [
  for (var i = 0; i < 7; i++) weekStart.add(Duration(days: i)),
];

/// All dates shown in a month-grid calendar for the month containing
/// [monthAnchor]: full Monday-Sunday weeks covering every day of that
/// month, padded with the leading/trailing days of adjacent months.
List<DateTime> monthGridDates(DateTime monthAnchor) {
  final firstOfMonth = DateTime(monthAnchor.year, monthAnchor.month, 1);
  final lastOfMonth = DateTime(monthAnchor.year, monthAnchor.month + 1, 0);
  final gridStart = startOfWeek(firstOfMonth);
  final gridEnd = startOfWeek(lastOfMonth);
  final totalDays = gridEnd.difference(gridStart).inDays + 7;
  return [for (var i = 0; i < totalDays; i++) gridStart.add(Duration(days: i))];
}
