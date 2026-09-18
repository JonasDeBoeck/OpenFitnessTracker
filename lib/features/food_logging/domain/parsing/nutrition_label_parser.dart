import '../models/parsed_nutrition_label.dart';

/// One line of OCR'd text plus its position on the photo, in the same
/// coordinate space the OCR engine reported (pixels; origin/scale don't
/// matter as long as they're consistent across all lines of one scan).
///
/// This is the seam that keeps [NutritionLabelParser] a pure, unit-testable
/// class independent of the `google_mlkit_text_recognition` plugin types —
/// [NutritionLabelOcrService] is responsible for mapping
/// `RecognizedText.blocks[].lines[]` into these.
class OcrLine {
  const OcrLine({
    required this.text,
    required this.top,
    required this.bottom,
    required this.left,
  });

  final String text;
  final double top;
  final double bottom;
  final double left;
}

/// Best-effort extraction of per-100g nutrition values from an OCR'd label
/// photo. Pure and synchronous so it's fully unit-testable in isolation
/// from the camera/OCR plugins that produce its input.
///
/// Nutrition tables are laid out in columns (a label on the left, its value
/// on the right) — `RecognizedText.text` just concatenates every detected
/// line block-by-block, so a label and its value routinely end up far apart
/// in that flat string even though they're on the same visual row. Matching
/// on text adjacency alone (the original approach) missed almost every real
/// label. Instead, this reconstructs table rows from each line's on-image
/// position, then searches within a row for a nutrient keyword and its
/// value together.
///
/// Deliberately conservative on missing data: it only trusts a label's own
/// "per 100g" column. If it can't find one, every value is left null rather
/// than guessing from a per-serving column — the user is expected to
/// review and fill in gaps themselves.
class NutritionLabelParser {
  const NutritionLabelParser._();

  static final RegExp _per100gMarker = RegExp(
    r'(per\s*|/\s*|ø\s*/?\s*)?100\s*g\b',
    caseSensitive: false,
  );

  // Keyword lists cover English plus the languages that show up on
  // Belgian/EU multilingual packaging (French, Dutch, German) since that's
  // the actual, common case — not just English-only US-style labels.
  static const _caloriesKeywords = ['energie', 'énergie', 'energy', 'energia', 'energi', 'calories'];
  static const _proteinKeywords = ['eiwitten', 'protéines', 'protéine', 'eiweiß', 'protein', 'proteine'];
  static const _fatKeywords = ['vetten', 'matières grasses', 'fett', 'grassi', 'fat'];
  // "Saturated fat" sub-rows also contain the word "fat" (or its FR/IT
  // equivalent), so they'd otherwise outrank the main fat row whenever
  // they're listed first — this excludes them explicitly.
  static const _saturatedFatExclusions = ['satur', 'verzadigde', 'gesättigte'];
  static const _carbsKeywords = ['koolhydraten', 'glucides', 'kohlenhydrat', 'carbohydrate', 'carboidrati'];
  static const _fiberKeywords = ['vezels', 'fibres', 'fibre', 'ballaststoffe', 'fiber'];
  static const _sugarKeywords = ['suikers', 'sucres', 'zucker', 'sugars', 'zuccheri'];
  static const _saltKeywords = ['zout', 'sel', 'salz', 'salt', 'sale'];
  static const _sodiumKeywords = ['natrium', 'sodium'];
  static const _cholesterolKeywords = ['cholesterol', 'cholestérol', 'cholesterin'];
  static const _potassiumKeywords = ['potassium', 'kalium'];
  static const _calciumKeywords = ['calcium'];
  static const _ironKeywords = ['iron', 'fer', 'ijzer', 'eisen'];
  static const _vitaminCKeywords = ['vitamine c', 'vitamin c'];
  static const _vitaminDKeywords = ['vitamine d', 'vitamin d'];

  // A gram of salt is ~39.3% sodium by mass; nutrition labelling in the EU
  // and elsewhere uses the standard rounded factor of salt(g) x 0.4 =
  // sodium(g), i.e. x 400 for sodium in mg.
  static const double _saltToSodiumMgFactor = 400;

  static ParsedNutritionLabel parseLines(List<OcrLine> lines) {
    if (lines.isEmpty) return const ParsedNutritionLabel(matchedPer100gColumn: false);

    final rows = _clusterIntoRows(lines);
    final rowTexts = rows.map((row) => row.map((l) => l.text).join(' ')).toList();
    final fullText = rowTexts.join('\n');

    if (!_per100gMarker.hasMatch(fullText)) {
      return const ParsedNutritionLabel(matchedPer100gColumn: false);
    }

    final sodiumFromLabel = _findValue(rowTexts, _sodiumKeywords, unit: 'mg');
    final saltGrams = _findValue(rowTexts, _saltKeywords, unit: 'g');

    return ParsedNutritionLabel(
      matchedPer100gColumn: true,
      caloriesPer100g: _findValue(rowTexts, _caloriesKeywords, unit: 'kcal'),
      proteinPer100g: _findValue(rowTexts, _proteinKeywords, unit: 'g'),
      fatPer100g: _findValue(
        rowTexts,
        _fatKeywords,
        unit: 'g',
        excludeKeywords: _saturatedFatExclusions,
      ),
      carbsPer100g: _findValue(rowTexts, _carbsKeywords, unit: 'g'),
      fiberPer100g: _findValue(rowTexts, _fiberKeywords, unit: 'g'),
      sugarPer100g: _findValue(rowTexts, _sugarKeywords, unit: 'g'),
      // Most EU labels print Salt (g), not Sodium (mg) directly — convert
      // so the field always ends up in the sodium-mg shape the app stores.
      sodiumMgPer100g: sodiumFromLabel ?? (saltGrams == null ? null : saltGrams * _saltToSodiumMgFactor),
      cholesterolMgPer100g: _findValue(rowTexts, _cholesterolKeywords, unit: 'mg'),
      potassiumMgPer100g: _findValue(rowTexts, _potassiumKeywords, unit: 'mg'),
      calciumMgPer100g: _findValue(rowTexts, _calciumKeywords, unit: 'mg'),
      ironMgPer100g: _findValue(rowTexts, _ironKeywords, unit: 'mg'),
      vitaminCMgPer100g: _findValue(rowTexts, _vitaminCKeywords, unit: 'mg'),
      vitaminDMcgPer100g: _findValue(rowTexts, _vitaminDKeywords, unit: 'mcg') ??
          _findValue(rowTexts, _vitaminDKeywords, unit: 'ug') ??
          _findValue(rowTexts, _vitaminDKeywords, unit: 'µg'),
    );
  }

  /// Convenience entry point for a single already-flattened block of text
  /// (e.g. a quick manual test) — treated as one row, so it only works for
  /// labels where each nutrient's keyword and value are genuinely adjacent
  /// in the string. Real photos should go through [parseLines].
  static ParsedNutritionLabel parse(String ocrText) {
    return parseLines([OcrLine(text: ocrText, top: 0, bottom: 1, left: 0)]);
  }

  /// Groups lines into table rows by vertical (top/bottom) overlap, since a
  /// label and its value are OCR'd as separate line elements but sit at
  /// roughly the same height on the image. Rows are returned top-to-bottom,
  /// each sorted left-to-right.
  static List<List<OcrLine>> _clusterIntoRows(List<OcrLine> lines) {
    final sorted = [...lines]..sort((a, b) => a.top.compareTo(b.top));
    final rows = <List<OcrLine>>[];

    for (final line in sorted) {
      final lineCenter = (line.top + line.bottom) / 2;
      final lineHeight = (line.bottom - line.top).abs().clamp(1, double.infinity);

      List<OcrLine>? targetRow;
      for (final row in rows) {
        final rowTop = row.map((l) => l.top).reduce((a, b) => a < b ? a : b);
        final rowBottom = row.map((l) => l.bottom).reduce((a, b) => a > b ? a : b);
        final rowCenter = (rowTop + rowBottom) / 2;
        if ((lineCenter - rowCenter).abs() < lineHeight * 0.6) {
          targetRow = row;
          break;
        }
      }

      if (targetRow != null) {
        targetRow.add(line);
      } else {
        rows.add([line]);
      }
    }

    for (final row in rows) {
      row.sort((a, b) => a.left.compareTo(b.left));
    }
    return rows;
  }

  // How far past a matched keyword to look for its value. Generous enough
  // to span a keyword's own multilingual repetitions before the number
  // (see the Skyr test: five language variants before the actual value),
  // but bounded so it can't reach into an unrelated, earlier number
  // elsewhere in a merged/flattened row (see the "100g" header vs.
  // "Protein 9g" regression this guards against).
  static const int _valueSearchWindow = 80;

  static double? _findValue(
    List<String> rowTexts,
    List<String> keywords, {
    required String unit,
    List<String> excludeKeywords = const [],
  }) {
    for (final rowText in rowTexts) {
      final lower = rowText.toLowerCase();
      if (excludeKeywords.any(lower.contains)) continue;

      for (final keyword in keywords) {
        final matchIndex = lower.indexOf(keyword);
        if (matchIndex == -1) continue;

        final windowEnd = (matchIndex + keyword.length + _valueSearchWindow)
            .clamp(0, rowText.length);
        final value = _numberBeforeUnit(rowText.substring(matchIndex, windowEnd), unit);
        if (value != null) return value;
      }
    }
    return null;
  }

  static double? _numberBeforeUnit(String text, String unit) {
    final pattern = RegExp(
      '(\\d+(?:[.,]\\d+)?)\\s*${RegExp.escape(unit)}\\b',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }
}
