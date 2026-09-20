/// One calendar day's logged calories and macros (zero when nothing was
/// logged that day), used to plot the Trends charts.
class DailyTotals {
  const DailyTotals({
    required this.date,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.waterMl,
  });

  final DateTime date;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double waterMl;
}
