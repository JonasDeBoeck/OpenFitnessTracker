import '../../../diary/diary.dart';
import '../../../onboarding/domain/models/goal.dart';

export '../../../diary/diary.dart' show MacroProgress, MealSection;

/// Fully derived view-model for the home dashboard: [DiaryDayView]'s "today"
/// overview plus the greeting/date header that's specific to Home.
class HomeDashboardView {
  const HomeDashboardView({
    required this.greeting,
    required this.name,
    required this.dateLabel,
    required this.goal,
    required this.targetCalories,
    required this.consumedCalories,
    required this.macros,
    required this.meals,
  });

  final String greeting;
  final String name;
  final String dateLabel;
  final Goal goal;
  final double targetCalories;
  final double consumedCalories;
  final List<MacroProgress> macros;
  final List<MealSection> meals;

  double get remainingCalories => targetCalories - consumedCalories;

  double get calorieProgress =>
      targetCalories <= 0 ? 0 : (consumedCalories / targetCalories).clamp(0, 1);
}
