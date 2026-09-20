import 'daily_totals.dart';
import 'trends_range.dart';

/// Fully derived view-model for the Trends screen: the user's targets plus
/// one [DailyTotals] per calendar day in [range], zero-filled for days with
/// nothing logged so the charts have a continuous x-axis.
class TrendsView {
  const TrendsView({
    required this.range,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetFat,
    required this.targetCarbs,
    required this.dailyTotals,
  });

  final TrendsRange range;
  final double targetCalories;
  final double targetProtein;
  final double targetFat;
  final double targetCarbs;
  final List<DailyTotals> dailyTotals;

  double get avgCalories => _avg(dailyTotals.map((d) => d.calories));
  double get avgProtein => _avg(dailyTotals.map((d) => d.protein));
  double get avgFat => _avg(dailyTotals.map((d) => d.fat));
  double get avgCarbs => _avg(dailyTotals.map((d) => d.carbs));

  static double _avg(Iterable<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
