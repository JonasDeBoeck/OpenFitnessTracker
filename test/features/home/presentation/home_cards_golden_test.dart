// Renders the Home dashboard's meal and water cards with the same mock data
// used in the Design artifact mockup, so the resulting PNG can be compared
// against it directly instead of eyeballing the widget source.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_fitness_tracker/core/models/meal_type.dart';
import 'package:open_fitness_tracker/features/diary/domain/models/diary_day_view.dart';
import 'package:open_fitness_tracker/features/diary/presentation/widgets/meal_section_card.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/diary_entry.dart';
import 'package:open_fitness_tracker/features/home/presentation/theme/dashboard_colors.dart';
import 'package:open_fitness_tracker/features/water/domain/models/water_entry.dart';
import 'package:open_fitness_tracker/features/water/presentation/widgets/water_log_card.dart';

// GoogleFonts can't load real font files offline (allowRuntimeFetching is
// disabled below), so it falls back to the platform's default glyphs. That
// fallback rendering isn't byte-identical between the machine the golden was
// captured on and the CI runner, so a small tolerance absorbs that
// font-fallback noise without letting real visual regressions slide.
class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(super.testFile, {required double precisionTolerance})
    : assert(
        0 <= precisionTolerance && precisionTolerance <= 1,
        'precisionTolerance must be between 0 and 1',
      ),
      _precisionTolerance = precisionTolerance;

  final double _precisionTolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    final passed = result.passed || result.diffPercent <= _precisionTolerance;
    if (passed) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

void main() {
  // Avoid GoogleFonts trying to fetch over the network during the test run.
  GoogleFonts.config.allowRuntimeFetching = false;

  goldenFileComparator = _TolerantGoldenFileComparator(
    Uri.parse('test/features/home/presentation/home_cards_golden_test.dart'),
    precisionTolerance: 0.02,
  );

  testWidgets('Home cards match the design mock data', (tester) async {
    final breakfast = MealSection(
      type: MealType.breakfast,
      consumedCalories: 325,
      proteinGrams: 8,
      fatGrams: 6,
      carbGrams: 58,
      items: [
        DiaryEntry(
          id: 1,
          foodId: 1,
          foodName: 'Oatmeal with blueberries',
          mealType: MealType.breakfast,
          loggedAt: DateTime(2026, 1, 1, 8),
          quantityGrams: 250,
          calories: 320,
          protein: 7,
          fat: 5,
          carbs: 53,
        ),
        DiaryEntry(
          id: 2,
          foodId: 2,
          foodName: 'Black coffee',
          mealType: MealType.breakfast,
          loggedAt: DateTime(2026, 1, 1, 8, 5),
          quantityGrams: 240,
          calories: 5,
          protein: 1,
          fat: 1,
          carbs: 5,
        ),
      ],
    );

    final waterEntries = [
      WaterEntry(id: 1, loggedAt: DateTime(2026, 1, 1, 8, 10), milliliters: 500),
      WaterEntry(id: 2, loggedAt: DateTime(2026, 1, 1, 11, 40), milliliters: 300),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: DashboardColors.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MealSectionCard(
                    meal: breakfast,
                    onAddFood: () {},
                    onDeleteItem: (_) {},
                    onEditItem: (_) {},
                  ),
                  const SizedBox(height: 16),
                  WaterLogCard(
                    entries: waterEntries,
                    onQuickAdd: (_) {},
                    onCustomAdd: (_) {},
                    onDelete: (_) {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/home_cards.png'),
    );
  });
}
