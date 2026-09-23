import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/meal_type.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/exit_confirmation_scope.dart';
import '../../../food_logging/domain/models/diary_entry.dart';
import '../../../food_logging/food_logging.dart';
import '../../../food_logging/presentation/widgets/edit_diary_entry_sheet.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../../water/water.dart';
import '../../domain/day_label.dart';
import '../providers/diary_day_providers.dart';
import '../providers/selected_diary_date_provider.dart';
import '../widgets/calorie_gauge_card.dart';
import '../widgets/diary_calendar_card.dart';
import '../widgets/macro_progress_card.dart';
import '../widgets/meal_section_card.dart';

/// How far back/forward the calendar's "has entries" dots are looked up.
/// Generous enough to cover ordinary browsing without re-querying on every
/// week/month navigation.
const Duration _loggedDatesLookback = Duration(days: 90);
const Duration _loggedDatesLookahead = Duration(days: 60);

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateUtils.dateOnly(DateTime.now());
    final selectedDate = ref.watch(selectedDiaryDateProvider);
    final dayAsync = ref.watch(diaryDayProvider(selectedDate));
    final waterDayAsync = ref.watch(waterDayProvider(selectedDate));
    final loggedDatesAsync = ref.watch(
      loggedDatesInRangeProvider(
        DateTimeRange(
          start: today.subtract(_loggedDatesLookback),
          end: today.add(_loggedDatesLookahead),
        ),
      ),
    );

    return ExitConfirmationScope(
      child: Scaffold(
        backgroundColor: DashboardColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Diary', style: DashboardTextStyles.greeting),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DiaryCalendarCard(
                        selectedDate: selectedDate,
                        onDateSelected: (date) => ref
                            .read(selectedDiaryDateProvider.notifier)
                            .select(date),
                        loggedDates: loggedDatesAsync.value ?? const {},
                      ),
                      const SizedBox(height: 20),
                      dayAsync.when(
                        loading: () => const _CenteredLoading(),
                        error: (error, stackTrace) =>
                            _CenteredMessage('Could not load this day: $error'),
                        data: (day) {
                          if (day == null) {
                            return const _CenteredMessage('No profile yet.');
                          }
                          final isToday = DateUtils.isSameDay(
                            selectedDate,
                            today,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                diaryDayLabel(selectedDate, today),
                                style: DashboardTextStyles.sectionTitle,
                              ),
                              const SizedBox(height: 14),
                              CalorieGaugeCard(
                                consumedCalories: day.consumedCalories,
                                targetCalories: day.targetCalories,
                                progress: day.calorieProgress,
                                isToday: isToday,
                              ),
                              const SizedBox(height: 20),
                              MacroProgressCard(macros: day.macros),
                              const SizedBox(height: 20),
                              if (waterDayAsync.value case final waterDay?) ...[
                                WaterProgressCard(day: waterDay),
                                const SizedBox(height: 20),
                                WaterLogCard(
                                  entries: waterDay.entries,
                                  onQuickAdd: (ml) => ref
                                      .read(waterLogControllerProvider.notifier)
                                      .add(selectedDate, ml),
                                  onCustomAdd: (ml) => ref
                                      .read(waterLogControllerProvider.notifier)
                                      .add(selectedDate, ml),
                                  onDelete: (id) => ref
                                      .read(waterLogControllerProvider.notifier)
                                      .delete(selectedDate, id),
                                ),
                                const SizedBox(height: 20),
                              ],
                              for (var i = 0; i < day.meals.length; i++) ...[
                                if (i > 0) const SizedBox(height: 20),
                                MealSectionCard(
                                  meal: day.meals[i],
                                  onAddFood: () =>
                                      _openAddFood(context, day.meals[i].type),
                                  onDeleteItem: (id) => ref
                                      .read(
                                        diaryEntryControllerProvider.notifier,
                                      )
                                      .delete(selectedDate, id),
                                  onEditItem: (entry) => _openEditSheet(
                                    context,
                                    selectedDate,
                                    entry,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const AppBottomNavBar(currentTab: AppNavTab.diary),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddFood(BuildContext context, MealType mealType) {
    context.push(AppRoutes.foodSearchPath, extra: mealType);
  }

  void _openEditSheet(BuildContext context, DateTime date, DiaryEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DashboardColors.surface,
      barrierColor: DashboardColors.dialogBackdrop,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EditDiaryEntrySheet(entry: entry, date: date),
    );
  }
}

class _CenteredLoading extends StatelessWidget {
  const _CenteredLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(child: Text(message)),
    );
  }
}
