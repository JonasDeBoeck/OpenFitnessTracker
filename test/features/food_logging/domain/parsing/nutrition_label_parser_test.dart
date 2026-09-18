import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/parsing/nutrition_label_parser.dart';

/// Builds one table "row" as two separate OCR line elements — a label on
/// the left, its value on the right — at the same height, the way a real
/// nutrition table actually gets OCR'd (label and value are different text
/// blocks, never one adjacent string).
List<OcrLine> _row(double top, String label, String value) => [
  OcrLine(text: label, top: top, bottom: top + 20, left: 0),
  OcrLine(text: value, top: top + 2, bottom: top + 18, left: 400),
];

void main() {
  group('NutritionLabelParser.parseLines', () {
    test('leaves everything null when no per-100g marker is found anywhere', () {
      final lines = [
        OcrLine(text: 'Nutrition Facts', top: 0, bottom: 20, left: 0),
        ..._row(40, 'Serving size 1 cup (240g)', ''),
        ..._row(80, 'Calories', '245'),
        ..._row(120, 'Protein', '9g'),
      ];

      final result = NutritionLabelParser.parseLines(lines);

      expect(result.matchedPer100gColumn, isFalse);
      expect(result.caloriesPer100g, isNull);
      expect(result.proteinPer100g, isNull);
    });

    test('reconstructs a real multilingual Belgian label (Aldi "Filet de York")', () {
      // Modeled directly on a photographed label: "Per/Pour/Je 100g" header,
      // comma decimals, a combined kJ/kcal energy row, a saturated-fat
      // sub-row that must not shadow the main fat row, and Salt (not
      // Sodium) as the only sodium-adjacent value.
      final lines = [
        ..._row(0, 'Per/Pour/Je 100g', ''),
        ..._row(40, 'Energie / Énergie / Energy', '519 kJ / 123 kcal'),
        ..._row(80, 'Vetten / Matières grasses / Fett', '3,0 g'),
        ..._row(
          120,
          '- waarvan verzadigde vetzuren / dont acides gras saturés / davon gesättigte Fettsäuren',
          '1,2 g',
        ),
        ..._row(160, 'Koolhydraten / Glucides / Kohlenhydrate', '1,0 g'),
        ..._row(200, '- waarvan suikers / dont sucres / davon Zucker', '0,6 g'),
        ..._row(240, 'Vezels / Fibres alimentaires / Ballaststoffe', '0 g'),
        ..._row(280, 'Eiwitten / Protéines / Eiweiß', '23 g'),
        ..._row(320, 'Zout / Sel / Salz', '4,0 g'),
      ];

      final result = NutritionLabelParser.parseLines(lines);

      expect(result.matchedPer100gColumn, isTrue);
      expect(result.caloriesPer100g, 123);
      expect(result.fatPer100g, 3.0);
      expect(result.carbsPer100g, 1.0);
      expect(result.sugarPer100g, 0.6);
      expect(result.fiberPer100g, 0);
      expect(result.proteinPer100g, 23);
      // Salt 4.0 g -> sodium mg via the standard x400 conversion.
      expect(result.sodiumMgPer100g, 1600);
    });

    test('reconstructs a real multilingual EU label (Lidl "Skyr Classic")', () {
      final lines = [
        ..._row(0, 'ø/100 g', ''),
        ..._row(40, 'Energie/Energi/Energie/Énergie/Energie/Energia', '262 kJ/ 62 kcal'),
        ..._row(80, 'Rasvaa/Fett/Vetten/Matières grasses/Fett/Grassi', '0,2 g'),
        ..._row(
          120,
          'josta tyydyttynyttä rasvaa/varav mättat fett/waarvan verzadigde vetzuren',
          '0,1 g',
        ),
        ..._row(160, 'Hiilihydraatteja/Kolhydrat/Koolhydraten/Glucides', '4,0 g'),
        ..._row(200, 'joista sokereita/varav sockerarter/waarvan suikers', '4,0 g'),
        ..._row(240, 'Ravintokuitua/Fiber/Vezels/Fibres alimentaires', '0 g'),
        ..._row(280, 'Proteiinia/Protein/Eiwitten/Protéines/Eiweiss/Proteine', '11,0 g'),
        ..._row(320, 'Suolaa/Salt/Zout/Sel/Salz/Sale', '0,13 g'),
      ];

      final result = NutritionLabelParser.parseLines(lines);

      expect(result.matchedPer100gColumn, isTrue);
      expect(result.caloriesPer100g, 62);
      expect(result.fatPer100g, 0.2);
      expect(result.carbsPer100g, 4.0);
      expect(result.sugarPer100g, 4.0);
      expect(result.fiberPer100g, 0);
      expect(result.proteinPer100g, 11.0);
      expect(result.sodiumMgPer100g, closeTo(52, 0.01));
    });

    test('prefers a direct sodium value over converting from salt when both exist', () {
      final lines = [
        ..._row(0, 'Per 100g', ''),
        ..._row(40, 'Sodium', '200mg'),
        ..._row(80, 'Salt', '0.5g'),
      ];

      final result = NutritionLabelParser.parseLines(lines);

      expect(result.sodiumMgPer100g, 200);
    });
  });

  group('NutritionLabelParser.parse (single-row convenience entry point)', () {
    test('still works for a simple already-adjacent label', () {
      const ocrText = 'per 100g Calories 245 kcal Protein 9g Total Fat 11g Total Carbohydrate 27g';

      final result = NutritionLabelParser.parse(ocrText);

      expect(result.matchedPer100gColumn, isTrue);
      expect(result.caloriesPer100g, 245);
      expect(result.proteinPer100g, 9);
      expect(result.fatPer100g, 11);
      expect(result.carbsPer100g, 27);
    });
  });
}
