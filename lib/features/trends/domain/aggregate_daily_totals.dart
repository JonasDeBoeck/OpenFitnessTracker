import '../../food_logging/domain/models/diary_entry.dart';
import '../../water/domain/models/water_entry.dart';
import 'models/daily_totals.dart';

/// Groups [entries] and [waterEntries] by calendar day and sums them,
/// filling every day from [start] to [end] (inclusive, both assumed
/// day-only) with a zero [DailyTotals] when nothing was logged, so charts
/// get a continuous x-axis.
List<DailyTotals> aggregateDailyTotals({
  required List<DiaryEntry> entries,
  required List<WaterEntry> waterEntries,
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

  final waterByDay = <DateTime, List<WaterEntry>>{};
  for (final entry in waterEntries) {
    final day = DateTime(
      entry.loggedAt.year,
      entry.loggedAt.month,
      entry.loggedAt.day,
    );
    (waterByDay[day] ??= []).add(entry);
  }

  return [
    for (
      var day = start;
      !day.isAfter(end);
      day = day.add(const Duration(days: 1))
    )
      _totalsFor(day, byDay[day] ?? const [], waterByDay[day] ?? const []),
  ];
}

DailyTotals _totalsFor(
  DateTime day,
  List<DiaryEntry> entries,
  List<WaterEntry> waterEntries,
) {
  return DailyTotals(
    date: day,
    calories: entries.fold(0, (sum, e) => sum + e.calories),
    protein: entries.fold(0, (sum, e) => sum + e.protein),
    fat: entries.fold(0, (sum, e) => sum + e.fat),
    carbs: entries.fold(0, (sum, e) => sum + e.carbs),
    waterMl: waterEntries.fold(0, (sum, e) => sum + e.milliliters),
  );
}
