import 'water_entry.dart';

/// Fully derived view-model for a single day's water: the user's target,
/// how much they've logged, and the individual entries (so they can be
/// deleted). Used on Home (today) and Diary (any date).
class WaterDayView {
  const WaterDayView({
    required this.date,
    required this.targetMl,
    required this.consumedMl,
    required this.entries,
  });

  final DateTime date;
  final double targetMl;
  final double consumedMl;
  final List<WaterEntry> entries;

  double get remainingMl => targetMl - consumedMl;

  double get progress =>
      targetMl <= 0 ? 0 : (consumedMl / targetMl).clamp(0, 1);
}
