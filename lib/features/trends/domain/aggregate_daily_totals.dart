import '../../food_logging/domain/models/diary_entry.dart';
import 'models/daily_totals.dart';

/// Groups [entries] by calendar day and sums their calories/macros, filling
/// every day from [start] to [end] (inclusive, both assumed day-only) with a
/// zero [DailyTotals] when nothing was logged, so charts get a continuous
/// x-axis.
List<DailyTotals> aggregateDailyTotals({
  required List<DiaryEntry> entries,
  required DateTime start,
  required DateTime end,
}) {
  final byDay = <DateTime, List<DiaryEntry>>{};
  for (final entry in entries) {
    final day = DateTime(
      entry.loggedAt.year,
      entry.loggedAt.month,
      entry.loggedAt.day,
    );
    (byDay[day] ??= []).add(entry);
  }

  return [
    for (
      var day = start;
      !day.isAfter(end);
      day = day.add(const Duration(days: 1))
    )
      _totalsFor(day, byDay[day] ?? const []),
  ];
}

DailyTotals _totalsFor(DateTime day, List<DiaryEntry> entries) {
  return DailyTotals(
    date: day,
    calories: entries.fold(0, (sum, e) => sum + e.calories),
    protein: entries.fold(0, (sum, e) => sum + e.protein),
    fat: entries.fold(0, (sum, e) => sum + e.fat),
    carbs: entries.fold(0, (sum, e) => sum + e.carbs),
  );
}
