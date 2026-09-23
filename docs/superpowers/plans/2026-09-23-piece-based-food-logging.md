# Piece-Based Food Logging Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let a food optionally define an average weight per piece (e.g. "1 carrot ≈ 60g") with a custom label, so it can be logged — to the diary and as a recipe ingredient — by count instead of always by grams, while every existing grams-only food keeps working exactly as it does today.

**Architecture:** Two new nullable columns land on each of three drift tables (`foods`, `recipe_ingredients`, `diary_entries`), mirrored onto the corresponding domain models. A new shared widget, `PieceAwareQuantityField`, generalizes the grams/piece toggle that already exists privately in `RecipeDetailScreen` and replaces the plain `QuantityStepper` on every screen that logs or edits a quantity. Conversion (piece count ↔ grams) and display formatting ("2 carrots (120g)") are pure, unit-tested functions; everywhere else follows this codebase's existing snapshot pattern — the unit/count actually used is frozen onto the ingredient/entry at save time, never re-derived from the food later.

**Tech Stack:** Flutter, Riverpod (`@riverpod` codegen), Freezed, Drift (SQLite), `flutter_test`.

**Spec:** [docs/superpowers/specs/2026-09-23-piece-based-food-logging-design.md](../specs/2026-09-23-piece-based-food-logging-design.md)

## Global Constraints

- Use `ref.invalidate()`, never `ref.refresh()`.
- No business logic in widgets — logic belongs in notifiers or repositories; widgets only call them.
- One public widget per widget file; prefix private widgets with `_`.
- Never hand-edit `*.g.dart`/`*.freezed.dart` — regenerate with `dart run build_runner build --delete-conflicting-outputs` after any change to an annotated file.
- Do not add new packages without asking first.
- A food's piece unit is single (one label + one weight), both-or-neither — no multiple named units, no package-total/count auto-divide entry (explicitly rejected during design).
- Grams stays the sole source of truth for nutrition everywhere; `unitLabel`/`unitCount` fields are display-only and frozen at the moment an ingredient/entry is saved, never retroactively recomputed if a food's piece definition changes later.
- Per `.claude/CLAUDE.md`: before implementing any new UI, update the relevant mockup(s) in the Design canvas artifact (https://claude.ai/artifact/GoiswZcxUzWMAKqGGEF214) and get the user's explicit confirmation the design is correct — this is a hard gate, not a formality. The spec's "Design artifact sync" section notes no mockups exist yet for this feature's screens.
- This project has no configured web/browser target — UI cannot be verified in a browser preview. Verify via `flutter analyze` + `flutter test` (and golden tests where one exists), and say explicitly that manual UI verification wasn't possible.
- Regenerating code in this environment reliably touches unrelated `.g.dart`/`.freezed.dart` files (environment drift, not caused by these changes). After every `build_runner` run: `git status --short`, revert (`git checkout --`) any regenerated file whose hand-written counterpart this plan didn't touch, then re-verify `flutter analyze`/`flutter test`.

## Review Focus

- A `pieceWeightGrams` of zero or negative reaching `pieceCountFromGrams` — must return 0, not divide/crash or produce `Infinity`/`NaN`. (Task 1)
- The Add/Edit Product screen's "Piece size" fields filled in on only one side (label with no weight, or weight with no label) — must block save with a clear error, not silently save a half-set pair. (Task 1, wired in Task 6)
- Editing a food to clear or change its piece definition after ingredients/diary entries already reference it — those ingredients/entries must keep showing what was actually logged, not re-derive from the food's current (possibly now-different or now-absent) piece definition. (Task 3)
- A logged count that isn't a whole number (a user can still type "1.5" even though the stepper steps by whole pieces) — display formatting must pluralize/format it sensibly rather than assuming an integer. (Task 1)
- A diary entry logged with a piece unit whose food's piece definition was later removed entirely — the diary list and the edit sheet must still work: the list keeps showing the frozen unit/count (Task 9), and the edit sheet's toggle simply isn't offered any more since the food no longer has one (Task 9).

---

### Task 1: Piece-quantity domain helpers

**Files:**
- Create: `lib/features/food_logging/domain/quantity/piece_conversion.dart`
- Create: `lib/features/food_logging/domain/quantity/logged_quantity_display.dart`
- Create: `lib/features/food_logging/domain/validation/piece_size_validator.dart`
- Test: `test/features/food_logging/domain/quantity/piece_conversion_test.dart`
- Test: `test/features/food_logging/domain/quantity/logged_quantity_display_test.dart`
- Test: `test/features/food_logging/domain/validation/piece_size_validator_test.dart`

**Interfaces:**
- Produces: `class LoggedQuantity { const LoggedQuantity({required double grams, String? unitLabel, double? unitCount}); final double grams; final String? unitLabel; final double? unitCount; }` — the value every quantity-entry widget reports back on change.
- Produces: `double gramsFromPieceCount(double pieceCount, double weightPerPieceGrams)`
- Produces: `double pieceCountFromGrams(double grams, double weightPerPieceGrams)` — returns `0` when `weightPerPieceGrams <= 0`.
- Produces: `String formatLoggedQuantity({required double grams, String? unitLabel, double? unitCount})` — e.g. `formatLoggedQuantity(grams: 120)` → `"120g"`; `formatLoggedQuantity(grams: 120, unitLabel: 'carrot', unitCount: 2)` → `"2 carrots (120g)"`.
- Produces: `String? pieceSizeValidationError({required String? label, required double? weightGrams})` — `null` when the pair is valid (including both unset), an error string when exactly one is set.

- [ ] **Step 1: Write the failing tests for conversion**

```dart
// test/features/food_logging/domain/quantity/piece_conversion_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/quantity/piece_conversion.dart';

void main() {
  group('gramsFromPieceCount', () {
    test('multiplies piece count by weight per piece', () {
      expect(gramsFromPieceCount(2, 60), 120);
    });

    test('supports fractional counts', () {
      expect(gramsFromPieceCount(1.5, 60), 90);
    });
  });

  group('pieceCountFromGrams', () {
    test('divides grams by weight per piece', () {
      expect(pieceCountFromGrams(120, 60), 2);
    });

    test('returns 0 for a zero weight per piece instead of dividing', () {
      expect(pieceCountFromGrams(120, 0), 0);
    });

    test('returns 0 for a negative weight per piece instead of dividing', () {
      expect(pieceCountFromGrams(120, -5), 0);
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/quantity/piece_conversion_test.dart`
Expected: FAIL — `piece_conversion.dart` doesn't exist yet (import error).

- [ ] **Step 3: Implement conversion helpers and `LoggedQuantity`**

```dart
// lib/features/food_logging/domain/quantity/piece_conversion.dart

/// The grams+unit pair a [PieceAwareQuantityField] reports back on every
/// change — [grams] is always populated (the value everything downstream
/// keys nutrition off of); [unitLabel]/[unitCount] are set only when the
/// field was in piece mode, both null when it was in grams mode.
class LoggedQuantity {
  const LoggedQuantity({required this.grams, this.unitLabel, this.unitCount});

  final double grams;
  final String? unitLabel;
  final double? unitCount;
}

/// Converts a piece count to grams using a food's average weight per piece.
double gramsFromPieceCount(double pieceCount, double weightPerPieceGrams) {
  return pieceCount * weightPerPieceGrams;
}

/// The inverse of [gramsFromPieceCount] — how many pieces [grams] is worth.
/// Guards a zero/negative [weightPerPieceGrams] by returning 0 rather than
/// dividing, since this is pure math with no caller-side invariant to lean
/// on (the Add Product form validates a positive weight, but this function
/// doesn't get to assume its caller always went through that form).
double pieceCountFromGrams(double grams, double weightPerPieceGrams) {
  if (weightPerPieceGrams <= 0) return 0;
  return grams / weightPerPieceGrams;
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/food_logging/domain/quantity/piece_conversion_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 5: Write the failing tests for display formatting**

```dart
// test/features/food_logging/domain/quantity/logged_quantity_display_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/quantity/logged_quantity_display.dart';

void main() {
  group('formatLoggedQuantity', () {
    test('shows plain grams when no unit was used', () {
      expect(formatLoggedQuantity(grams: 120), '120g');
    });

    test('shows singular unit with grams in parentheses for a count of 1', () {
      expect(
        formatLoggedQuantity(grams: 60, unitLabel: 'carrot', unitCount: 1),
        '1 carrot (60g)',
      );
    });

    test('shows plural unit for a count other than 1', () {
      expect(
        formatLoggedQuantity(grams: 120, unitLabel: 'carrot', unitCount: 2),
        '2 carrots (120g)',
      );
    });

    test('trims a trailing .0 on a fractional count that resolves to a whole number', () {
      expect(
        formatLoggedQuantity(grams: 60, unitLabel: 'carrot', unitCount: 1.0),
        '1 carrot (60g)',
      );
    });

    test('keeps one decimal place for a genuinely fractional count', () {
      expect(
        formatLoggedQuantity(grams: 90, unitLabel: 'carrot', unitCount: 1.5),
        '1.5 carrots (90g)',
      );
    });
  });
}
```

- [ ] **Step 6: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/quantity/logged_quantity_display_test.dart`
Expected: FAIL — `logged_quantity_display.dart` doesn't exist yet.

- [ ] **Step 7: Implement `formatLoggedQuantity`**

```dart
// lib/features/food_logging/domain/quantity/logged_quantity_display.dart

/// Formats an already-logged quantity for display: "2 carrots (120g)" when
/// a piece unit was used to log it, or plain "120g" otherwise — shared by
/// the diary meal list and the recipe ingredient list, the two places a
/// snapshotted grams+unit pair is shown back to the user.
String formatLoggedQuantity({
  required double grams,
  String? unitLabel,
  double? unitCount,
}) {
  final gramsText = '${grams.toStringAsFixed(0)}g';
  if (unitLabel == null || unitCount == null) return gramsText;
  final countText = _trimTrailingZero(unitCount);
  final label = unitCount == 1 ? unitLabel : '${unitLabel}s';
  return '$countText $label ($gramsText)';
}

String _trimTrailingZero(double value) {
  final text = value.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
```

- [ ] **Step 8: Run the test to verify it passes**

Run: `flutter test test/features/food_logging/domain/quantity/logged_quantity_display_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 9: Write the failing tests for piece-size validation**

```dart
// test/features/food_logging/domain/validation/piece_size_validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/validation/piece_size_validator.dart';

void main() {
  group('pieceSizeValidationError', () {
    test('is valid when both label and weight are unset', () {
      expect(pieceSizeValidationError(label: null, weightGrams: null), isNull);
    });

    test('is valid when both label and weight are set', () {
      expect(pieceSizeValidationError(label: 'carrot', weightGrams: 60), isNull);
    });

    test('errors when only the label is set', () {
      expect(pieceSizeValidationError(label: 'carrot', weightGrams: null), isNotNull);
    });

    test('errors when only the weight is set', () {
      expect(pieceSizeValidationError(label: null, weightGrams: 60), isNotNull);
    });

    test('treats a blank label as unset', () {
      expect(pieceSizeValidationError(label: '   ', weightGrams: 60), isNotNull);
    });
  });
}
```

- [ ] **Step 10: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/validation/piece_size_validator_test.dart`
Expected: FAIL — `piece_size_validator.dart` doesn't exist yet.

- [ ] **Step 11: Implement `pieceSizeValidationError`**

```dart
// lib/features/food_logging/domain/validation/piece_size_validator.dart

/// Validates the Add/Edit Product screen's optional "Piece size" fields —
/// both must be set or both left blank, since a lone label or a lone
/// weight isn't a usable piece size. Returns the error to show, or null
/// when the pair is valid (including when both are unset).
String? pieceSizeValidationError({required String? label, required double? weightGrams}) {
  final hasLabel = label != null && label.trim().isNotEmpty;
  final hasWeight = weightGrams != null;
  if (hasLabel == hasWeight) return null;
  return hasLabel
      ? 'Enter a weight per $label, or clear the label to skip this.'
      : 'Enter a label for this weight (e.g. "carrot"), or clear the weight to skip this.';
}
```

- [ ] **Step 12: Run the test to verify it passes**

Run: `flutter test test/features/food_logging/domain/validation/piece_size_validator_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 13: Commit**

```bash
git add lib/features/food_logging/domain/quantity/ lib/features/food_logging/domain/validation/piece_size_validator.dart test/features/food_logging/domain/quantity/ test/features/food_logging/domain/validation/piece_size_validator_test.dart
git commit -m "Add piece-quantity conversion, display, and validation helpers"
```

---

### Task 2: Database schema and migration

**Files:**
- Modify: `lib/features/food_logging/data/tables/foods_table.dart`
- Modify: `lib/features/food_logging/data/tables/recipe_ingredients_table.dart`
- Modify: `lib/features/food_logging/data/tables/diary_entries_table.dart`
- Modify: `lib/core/database/app_database.dart:28,33-58`

**Interfaces:**
- Produces: `Foods.pieceLabel` (nullable text), `Foods.pieceWeightGrams` (nullable real) columns.
- Produces: `RecipeIngredients.unitLabel` (nullable text), `RecipeIngredients.unitCount` (nullable real) columns.
- Produces: `DiaryEntries.loggedUnitLabel` (nullable text), `DiaryEntries.loggedUnitCount` (nullable real) columns.
- Produces: `AppDatabase.schemaVersion == 6`.

This task has no pure-logic tests of its own (this codebase has no drift migration test precedent); it's verified by successful codegen + analyze, and exercised end-to-end once Tasks 3–4 build on the new columns.

- [ ] **Step 1: Add the new columns to `Foods`**

In `lib/features/food_logging/data/tables/foods_table.dart`, add after the existing `createdAt` column:

```dart
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Optional "piece" unit — both null means this food is grams-only, same
  // as every food before this feature existed.
  TextColumn get pieceLabel => text().nullable()();
  RealColumn get pieceWeightGrams => real().nullable()();
```

- [ ] **Step 2: Add the new columns to `RecipeIngredients`**

In `lib/features/food_logging/data/tables/recipe_ingredients_table.dart`, add after the existing `carbsPer100g` column:

```dart
  RealColumn get carbsPer100g => real()();
  // Snapshotted alongside grams — the unit/count actually used when this
  // ingredient was added, or both null if it was added in grams.
  TextColumn get unitLabel => text().nullable()();
  RealColumn get unitCount => real().nullable()();
```

- [ ] **Step 3: Add the new columns to `DiaryEntries`**

In `lib/features/food_logging/data/tables/diary_entries_table.dart`, add after the existing `vitaminDMcg` column:

```dart
  RealColumn get vitaminDMcg => real().nullable()();
  // Snapshotted alongside quantityGrams — the unit/count actually logged,
  // or both null if this entry was logged in grams (recipe entries never
  // have a piece unit, so these always stay null for them).
  TextColumn get loggedUnitLabel => text().nullable()();
  RealColumn get loggedUnitCount => real().nullable()();
```

- [ ] **Step 4: Bump the schema version and add the migration step**

In `lib/core/database/app_database.dart`, change:

```dart
  int get schemaVersion => 5;
```

to:

```dart
  int get schemaVersion => 6;
```

and add a new branch inside `onUpgrade`, after the existing `if (from < 5) { ... }` block:

```dart
      if (from < 6) {
        await migrator.addColumn(foods, foods.pieceLabel);
        await migrator.addColumn(foods, foods.pieceWeightGrams);
        await migrator.addColumn(recipeIngredients, recipeIngredients.unitLabel);
        await migrator.addColumn(recipeIngredients, recipeIngredients.unitCount);
        await migrator.addColumn(diaryEntries, diaryEntries.loggedUnitLabel);
        await migrator.addColumn(diaryEntries, diaryEntries.loggedUnitCount);
      }
```

- [ ] **Step 5: Regenerate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Then: `git status --short` and `git checkout --` any regenerated file outside `lib/core/database/app_database.g.dart`, `lib/features/food_logging/data/tables/*.dart`/their generated counterparts.
Then: `flutter analyze`
Expected: no errors; `app_database.g.dart` reflects the six new columns.

- [ ] **Step 6: Commit**

```bash
git add lib/features/food_logging/data/tables/ lib/core/database/app_database.dart lib/core/database/app_database.g.dart
git commit -m "Add piece-unit columns to foods, recipe_ingredients, and diary_entries"
```

---

### Task 3: Domain models — Food, RecipeIngredient, DiaryEntry

**Files:**
- Modify: `lib/features/food_logging/domain/models/food.dart:10-32`
- Modify: `lib/features/food_logging/domain/models/recipe.dart:16-40`
- Modify: `lib/features/food_logging/domain/models/diary_entry.dart:18-40,52-79`
- Modify: `test/features/food_logging/domain/models/food_test.dart`
- Test: `test/features/food_logging/domain/models/recipe_ingredient_test.dart`
- Test: `test/features/food_logging/domain/models/diary_entry_test.dart`

**Interfaces:**
- Consumes: nothing new from Task 1/2 directly (this task doesn't call the conversion/display helpers).
- Produces: `Food.pieceLabel` (`String?`), `Food.pieceWeightGrams` (`double?`), `Food.hasPieceUnit` (`bool` getter).
- Produces: `RecipeIngredient.unitLabel` (`String?`), `RecipeIngredient.unitCount` (`double?`); `RecipeIngredient.fromFood({required Food food, required double grams, String? unitLabel, double? unitCount})`.
- Produces: `DiaryEntry.loggedUnitLabel` (`String?`), `DiaryEntry.loggedUnitCount` (`double?`); `DiaryEntry.snapshotFrom({..., String? unitLabel, double? unitCount})` (existing required params unchanged).

- [ ] **Step 1: Write the failing tests for `Food.hasPieceUnit`**

Append to `test/features/food_logging/domain/models/food_test.dart` (inside `main()`, as a sibling `group` to the existing `Food.scaledTo` group):

```dart
  group('Food.hasPieceUnit', () {
    test('is true when both pieceLabel and pieceWeightGrams are set', () {
      const food = Food(name: 'Carrot', pieceLabel: 'carrot', pieceWeightGrams: 60);
      expect(food.hasPieceUnit, isTrue);
    });

    test('is false when neither is set', () {
      const food = Food(name: 'Rice');
      expect(food.hasPieceUnit, isFalse);
    });

    test('is false when only the label is set', () {
      const food = Food(name: 'Carrot', pieceLabel: 'carrot');
      expect(food.hasPieceUnit, isFalse);
    });

    test('is false when only the weight is set', () {
      const food = Food(name: 'Carrot', pieceWeightGrams: 60);
      expect(food.hasPieceUnit, isFalse);
    });
  });
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/models/food_test.dart`
Expected: FAIL — `Food` has no `pieceLabel`/`pieceWeightGrams`/`hasPieceUnit` yet (compile error).

- [ ] **Step 3: Add the fields and getter to `Food`**

In `lib/features/food_logging/domain/models/food.dart`, add two fields to the factory constructor (after `vitaminDMcgPer100g`, before `isFavorite`):

```dart
    double? vitaminDMcgPer100g,
    String? pieceLabel,
    double? pieceWeightGrams,
    @Default(false) bool isFavorite,
```

and add a getter alongside `scaledTo`:

```dart
  /// Whether this food has an average per-piece weight defined, letting it
  /// be logged by count instead of only by grams. Both-or-neither by
  /// construction — [pieceLabel] and [pieceWeightGrams] are only ever set
  /// together (enforced by `pieceSizeValidationError` on the Add/Edit
  /// Product screen).
  bool get hasPieceUnit => pieceLabel != null && pieceWeightGrams != null;
```

- [ ] **Step 4: Regenerate and run the test to verify it passes**

Run: `dart run build_runner build --delete-conflicting-outputs`, then revert unrelated regenerated files per the Global Constraints note, then:
Run: `flutter test test/features/food_logging/domain/models/food_test.dart`
Expected: PASS (4 new tests + existing ones)

- [ ] **Step 5: Write the failing tests for `RecipeIngredient.fromFood`**

```dart
// test/features/food_logging/domain/models/recipe_ingredient_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/food.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/recipe.dart';

void main() {
  group('RecipeIngredient.fromFood', () {
    const food = Food(id: 1, name: 'Carrot', caloriesPer100g: 41);

    test('leaves unitLabel and unitCount null when not provided', () {
      final ingredient = RecipeIngredient.fromFood(food: food, grams: 60);
      expect(ingredient.unitLabel, isNull);
      expect(ingredient.unitCount, isNull);
    });

    test('snapshots the unit and count actually used', () {
      final ingredient = RecipeIngredient.fromFood(
        food: food,
        grams: 120,
        unitLabel: 'carrot',
        unitCount: 2,
      );
      expect(ingredient.unitLabel, 'carrot');
      expect(ingredient.unitCount, 2);
      expect(ingredient.grams, 120);
    });
  });
}
```

- [ ] **Step 6: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/models/recipe_ingredient_test.dart`
Expected: FAIL — `fromFood` doesn't accept `unitLabel`/`unitCount` yet (compile error).

- [ ] **Step 7: Add the fields and factory params to `RecipeIngredient`**

In `lib/features/food_logging/domain/models/recipe.dart`, update the factory constructor:

```dart
  const factory RecipeIngredient({
    int? id,
    required int foodId,
    required String foodName,
    required double grams,
    required double caloriesPer100g,
    required double proteinPer100g,
    required double fatPer100g,
    required double carbsPer100g,
    String? unitLabel,
    double? unitCount,
  }) = _RecipeIngredient;
```

and `fromFood`:

```dart
  factory RecipeIngredient.fromFood({
    required Food food,
    required double grams,
    String? unitLabel,
    double? unitCount,
  }) {
    return RecipeIngredient(
      foodId: food.id!,
      foodName: food.name,
      grams: grams,
      caloriesPer100g: food.caloriesPer100g ?? 0,
      proteinPer100g: food.proteinPer100g ?? 0,
      fatPer100g: food.fatPer100g ?? 0,
      carbsPer100g: food.carbsPer100g ?? 0,
      unitLabel: unitLabel,
      unitCount: unitCount,
    );
  }
```

- [ ] **Step 8: Regenerate and run the test to verify it passes**

Run: `dart run build_runner build --delete-conflicting-outputs`, revert unrelated regenerated files, then:
Run: `flutter test test/features/food_logging/domain/models/recipe_ingredient_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 9: Write the failing tests for `DiaryEntry.snapshotFrom`**

```dart
// test/features/food_logging/domain/models/diary_entry_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/core/models/meal_type.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/diary_entry.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/models/food.dart';

void main() {
  group('DiaryEntry.snapshotFrom', () {
    const food = Food(id: 1, name: 'Carrot', caloriesPer100g: 41);
    final loggedAt = DateTime(2026, 1, 1);

    test('leaves loggedUnitLabel and loggedUnitCount null when not provided', () {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: 60,
        mealType: MealType.breakfast,
        loggedAt: loggedAt,
      );
      expect(entry.loggedUnitLabel, isNull);
      expect(entry.loggedUnitCount, isNull);
    });

    test('snapshots the unit and count actually logged', () {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: 120,
        mealType: MealType.breakfast,
        loggedAt: loggedAt,
        unitLabel: 'carrot',
        unitCount: 2,
      );
      expect(entry.loggedUnitLabel, 'carrot');
      expect(entry.loggedUnitCount, 2);
    });
  });
}
```

- [ ] **Step 10: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/models/diary_entry_test.dart`
Expected: FAIL — `snapshotFrom` doesn't accept `unitLabel`/`unitCount` yet (compile error).

- [ ] **Step 11: Add the fields and factory params to `DiaryEntry`**

In `lib/features/food_logging/domain/models/diary_entry.dart`, update the factory constructor (add after `vitaminDMcg`):

```dart
    double? vitaminDMcg,
    String? loggedUnitLabel,
    double? loggedUnitCount,
  }) = _DiaryEntry;
```

and `snapshotFrom`:

```dart
  factory DiaryEntry.snapshotFrom({
    required Food food,
    required double quantityGrams,
    required MealType mealType,
    required DateTime loggedAt,
    String? unitLabel,
    double? unitCount,
  }) {
    final nutrition = food.scaledTo(quantityGrams);
    return DiaryEntry(
      foodId: food.id!,
      foodName: food.name,
      mealType: mealType,
      loggedAt: loggedAt,
      quantityGrams: quantityGrams,
      calories: nutrition.calories,
      protein: nutrition.protein,
      fat: nutrition.fat,
      carbs: nutrition.carbs,
      fiber: nutrition.fiber,
      sugar: nutrition.sugar,
      sodiumMg: nutrition.sodiumMg,
      cholesterolMg: nutrition.cholesterolMg,
      potassiumMg: nutrition.potassiumMg,
      calciumMg: nutrition.calciumMg,
      ironMg: nutrition.ironMg,
      vitaminCMg: nutrition.vitaminCMg,
      vitaminDMcg: nutrition.vitaminDMcg,
      loggedUnitLabel: unitLabel,
      loggedUnitCount: unitCount,
    );
  }
```

(`snapshotFromRecipe` is unchanged — recipes never have a piece unit.)

- [ ] **Step 12: Regenerate and run the test to verify it passes**

Run: `dart run build_runner build --delete-conflicting-outputs`, revert unrelated regenerated files, then:
Run: `flutter test test/features/food_logging/domain/models/diary_entry_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 13: Run the full test suite and analyzer**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing (previous suite + 8 new tests from this task).

- [ ] **Step 14: Commit**

```bash
git add lib/features/food_logging/domain/models/ test/features/food_logging/domain/models/
git commit -m "Add piece-unit fields to Food, RecipeIngredient, and DiaryEntry"
```

---

### Task 4: Repository mapping

**Files:**
- Modify: `lib/features/food_logging/data/food_repository.dart:125-174`
- Modify: `lib/features/food_logging/data/recipe_repository.dart:153-167,201-212`
- Modify: `lib/features/food_logging/data/diary_repository.dart:95-145`

**Interfaces:**
- Consumes: `Food.pieceLabel`/`pieceWeightGrams`, `RecipeIngredient.unitLabel`/`unitCount`, `DiaryEntry.loggedUnitLabel`/`loggedUnitCount` (Task 3); the six new drift columns (Task 2).
- Produces: no new public methods — `FoodRepository.create`/`update`/`getById`/etc., `RecipeRepository.create`/`update`, and `DiaryRepository.insertLogEntry`/`updateEntry`/`getEntriesForDate` now round-trip the new fields.

This task has no repository test precedent to follow in this codebase (none of the three repositories have their own test file today) — it's verified by the model tests from Task 3 plus `flutter analyze`, and exercised end-to-end by the UI tasks that follow.

- [ ] **Step 1: Map the new `Food` fields in `FoodRepository`**

In `lib/features/food_logging/data/food_repository.dart`, add to `_toCompanion` (after `isFavorite`):

```dart
      isFavorite: Value(food.isFavorite),
      pieceLabel: Value(food.pieceLabel),
      pieceWeightGrams: Value(food.pieceWeightGrams),
```

and to `_fromRow` (after `isFavorite`):

```dart
      isFavorite: row.isFavorite,
      pieceLabel: row.pieceLabel,
      pieceWeightGrams: row.pieceWeightGrams,
```

- [ ] **Step 2: Map the new `RecipeIngredient` fields in `RecipeRepository`**

In `lib/features/food_logging/data/recipe_repository.dart`, add to `_ingredientToCompanion` (after `carbsPer100g`):

```dart
      carbsPer100g: Value(ingredient.carbsPer100g),
      unitLabel: Value(ingredient.unitLabel),
      unitCount: Value(ingredient.unitCount),
```

and to `_ingredientFromRow` (after `carbsPer100g`):

```dart
      carbsPer100g: row.carbsPer100g,
      unitLabel: row.unitLabel,
      unitCount: row.unitCount,
```

- [ ] **Step 3: Map the new `DiaryEntry` fields in `DiaryRepository`**

In `lib/features/food_logging/data/diary_repository.dart`, add to `_toCompanion` (after `vitaminDMcg`):

```dart
      vitaminDMcg: Value(entry.vitaminDMcg),
      loggedUnitLabel: Value(entry.loggedUnitLabel),
      loggedUnitCount: Value(entry.loggedUnitCount),
```

and to `_fromRow` (after `vitaminDMcg`):

```dart
      vitaminDMcg: row.vitaminDMcg,
      loggedUnitLabel: row.loggedUnitLabel,
      loggedUnitCount: row.loggedUnitCount,
```

- [ ] **Step 4: Verify**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing (unchanged from Task 3; this task has no new tests of its own, per the note above).

- [ ] **Step 5: Commit**

```bash
git add lib/features/food_logging/data/food_repository.dart lib/features/food_logging/data/recipe_repository.dart lib/features/food_logging/data/diary_repository.dart
git commit -m "Persist piece-unit fields through the food, recipe, and diary repositories"
```

---

### Task 5: Shared `PieceAwareQuantityField` widget

**Files:**
- Create: `lib/features/food_logging/presentation/widgets/piece_aware_quantity_field.dart`

**Interfaces:**
- Consumes: `LoggedQuantity`, `gramsFromPieceCount`, `pieceCountFromGrams` (Task 1); `QuantityStepper` (existing, `lib/features/food_logging/presentation/widgets/quantity_stepper.dart`, untouched).
- Produces: `class PieceAwareQuantityField extends StatefulWidget` with constructor `{required double grams, required ValueChanged<LoggedQuantity> onChanged, String? pieceLabel, double? pieceWeightGrams, double? initialUnitCount, String label = 'Quantity', bool showCard = true, double minGrams = 0, double maxGrams = double.infinity}`.

No widget-test precedent exists in this codebase for interactive stepper/toggle widgets (`QuantityStepper` and the recipe detail screen's private toggle have none), so this task is verified by `flutter analyze` and exercised end-to-end once Tasks 6–9 wire it into real screens.

- [ ] **Step 1: Implement the widget**

```dart
// lib/features/food_logging/presentation/widgets/piece_aware_quantity_field.dart
import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/quantity/piece_conversion.dart';
import 'quantity_stepper.dart';

enum _QuantityUnit { grams, piece }

/// Grams/piece amount control, generalizing the grams/servings toggle that
/// already exists privately in [RecipeDetailScreen]. Renders exactly like
/// [QuantityStepper] (unchanged look, unchanged behavior) whenever
/// [pieceLabel] or [pieceWeightGrams] is null; only when a food has both
/// does it add the segmented grams/piece toggle. Always reports back
/// grams — plus the unit actually used, when applicable — via [onChanged].
class PieceAwareQuantityField extends StatefulWidget {
  const PieceAwareQuantityField({
    super.key,
    required this.grams,
    required this.onChanged,
    this.pieceLabel,
    this.pieceWeightGrams,
    this.initialUnitCount,
    this.label = 'Quantity',
    this.showCard = true,
    this.minGrams = 0,
    this.maxGrams = double.infinity,
  });

  final double grams;
  final ValueChanged<LoggedQuantity> onChanged;
  final String? pieceLabel;
  final double? pieceWeightGrams;
  /// When non-null (and a piece unit is available), the field starts in
  /// piece mode showing this count instead of starting in grams mode —
  /// used by the Edit Diary Entry sheet to reopen an entry the way it was
  /// originally logged.
  final double? initialUnitCount;
  final String label;
  final bool showCard;
  final double minGrams;
  final double maxGrams;

  @override
  State<PieceAwareQuantityField> createState() => _PieceAwareQuantityFieldState();
}

class _PieceAwareQuantityFieldState extends State<PieceAwareQuantityField> {
  late _QuantityUnit _unit = _startingUnit();
  late final _controller = TextEditingController(text: _initialText());

  bool get _hasPieceUnit => widget.pieceLabel != null && widget.pieceWeightGrams != null;

  _QuantityUnit _startingUnit() =>
      widget.initialUnitCount != null && _hasPieceUnit ? _QuantityUnit.piece : _QuantityUnit.grams;

  String _initialText() => _unit == _QuantityUnit.piece
      ? _trimTrailingZero(widget.initialUnitCount!)
      : widget.grams.toStringAsFixed(0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _value => double.tryParse(_controller.text.trim()) ?? 0;

  String _trimTrailingZero(double value) {
    final text = value.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  void _setValue(double value) {
    setState(() {
      _controller.text =
          _unit == _QuantityUnit.grams ? value.toStringAsFixed(0) : _trimTrailingZero(value);
    });
    _notify(value);
  }

  void _notify(double value) {
    if (_unit == _QuantityUnit.piece && _hasPieceUnit) {
      widget.onChanged(LoggedQuantity(
        grams: gramsFromPieceCount(value, widget.pieceWeightGrams!),
        unitLabel: widget.pieceLabel,
        unitCount: value,
      ));
    } else {
      widget.onChanged(LoggedQuantity(grams: value));
    }
  }

  void _pickUnit(_QuantityUnit unit) {
    if (unit == _unit || !_hasPieceUnit) return;
    setState(() {
      _unit = unit;
      _controller.text = unit == _QuantityUnit.grams
          ? widget.grams.toStringAsFixed(0)
          : _trimTrailingZero(pieceCountFromGrams(widget.grams, widget.pieceWeightGrams!));
    });
    _notify(_value);
  }

  void _increment() => _setValue(_unit == _QuantityUnit.grams ? _value + 25 : _value + 1);

  void _decrement() => _setValue(
        _unit == _QuantityUnit.grams
            ? (_value - 25).clamp(widget.minGrams, widget.maxGrams)
            : (_value - 1).clamp(1, double.infinity),
      );

  @override
  Widget build(BuildContext context) {
    if (!_hasPieceUnit) {
      return QuantityStepper(
        grams: widget.grams,
        onChanged: (value) => widget.onChanged(LoggedQuantity(grams: value)),
        label: widget.label,
        showCard: widget.showCard,
        minGrams: widget.minGrams,
        maxGrams: widget.maxGrams,
      );
    }

    final pieceLabel = widget.pieceLabel!;
    final unitSuffix = _unit == _QuantityUnit.grams
        ? 'g'
        : (_value == 1 ? pieceLabel : '${pieceLabel}s');
    final pieceButtonLabel = '${pieceLabel[0].toUpperCase()}${pieceLabel.substring(1)}s';

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: _UnitButton(
                  label: 'Grams',
                  active: _unit == _QuantityUnit.grams,
                  onTap: () => _pickUnit(_QuantityUnit.grams),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _UnitButton(
                  label: pieceButtonLabel,
                  active: _unit == _QuantityUnit.piece,
                  onTap: () => _pickUnit(_QuantityUnit.piece),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: DashboardTextStyles.macroName),
            Row(
              children: [
                _StepButton(icon: Icons.remove, onTap: _decrement),
                const SizedBox(width: 10),
                SizedBox(
                  width: 52,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _notify(_value),
                    style: DashboardTextStyles.macroName,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(unitSuffix, style: DashboardTextStyles.mealKcal),
                const SizedBox(width: 10),
                _StepButton(icon: Icons.add, onTap: _increment),
              ],
            ),
          ],
        ),
      ],
    );

    if (!widget.showCard) return content;

    return Container(
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: content,
    );
  }
}

class _UnitButton extends StatelessWidget {
  const _UnitButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? DashboardColors.primary : DashboardColors.border,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.macroNums.copyWith(
              fontWeight: FontWeight.w600,
              color: active ? DashboardColors.surface : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(side: BorderSide(color: DashboardColors.primary, width: 1.5)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: DashboardColors.primary),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify**

Run: `flutter analyze` — expected clean.

- [ ] **Step 3: Commit**

```bash
git add lib/features/food_logging/presentation/widgets/piece_aware_quantity_field.dart
git commit -m "Add shared PieceAwareQuantityField widget"
```

---

### Task 6: Add/Edit Product screen — Piece size section

**Files:**
- Modify: `lib/features/food_logging/presentation/providers/add_product_form_state.dart:10-47`
- Modify: `lib/features/food_logging/presentation/providers/add_product_notifier.dart`
- Modify: `lib/features/food_logging/presentation/add_product/add_product_screen.dart`

**Interfaces:**
- Consumes: `pieceSizeValidationError` (Task 1); `Food.pieceLabel`/`pieceWeightGrams` (Task 3).
- Produces: `AddProductFormState.pieceLabel`/`pieceWeightGrams`; `AddProductNotifier.setPieceLabel(String? value)`/`setPieceWeightGrams(double? value)`.

- [ ] **Step 1: Update the Design artifact and get confirmation**

Before writing any code, open the Design canvas artifact (https://claude.ai/artifact/GoiswZcxUzWMAKqGGEF214), find the mockup covering the Add/Edit Product screen, and add an optional "Piece size" section: a text field labeled "Label" (hint "e.g. carrot") and a number field labeled "Weight per piece (g)", side by side, styled like the existing Brand/Store row on that screen. Show the user the updated mockup and get their explicit confirmation it's correct before proceeding to Step 2. Do not write implementation code until confirmed.

- [ ] **Step 2: Add the new fields to `AddProductFormState`**

In `lib/features/food_logging/presentation/providers/add_product_form_state.dart`, add two fields to the factory constructor (after `store`):

```dart
    String? brand,
    String? store,
    String? pieceLabel,
    double? pieceWeightGrams,
    @Default(false) bool isFavorite,
```

- [ ] **Step 3: Add setters, editing-prefill, and save-mapping in `AddProductNotifier`**

In `lib/features/food_logging/presentation/providers/add_product_notifier.dart`, add to the `editingFood != null` branch of `build()` (after `store: editingFood.store,`):

```dart
        store: editingFood.store,
        pieceLabel: editingFood.pieceLabel,
        pieceWeightGrams: editingFood.pieceWeightGrams,
```

add two setters (near `setStore`):

```dart
  void setPieceLabel(String? value) => state = state.copyWith(pieceLabel: value);
  void setPieceWeightGrams(double? value) => state = state.copyWith(pieceWeightGrams: value);
```

add a validation check as the first statement inside `save()`'s `try` block (before the macro-mismatch check):

```dart
    try {
      final pieceSizeError = pieceSizeValidationError(
        label: state.pieceLabel,
        weightGrams: state.pieceWeightGrams,
      );
      if (pieceSizeError != null) {
        state = state.copyWith(isSaving: false, saveError: pieceSizeError);
        return;
      }

      final macrosMatch = macrosRoughlyMatchCalories(
```

and add the two fields to the `Food(...)` construction later in `save()` (after `store: state.store,`):

```dart
        store: state.store,
        pieceLabel: state.pieceLabel,
        pieceWeightGrams: state.pieceWeightGrams,
```

Add the import at the top of the file:

```dart
import '../../domain/validation/piece_size_validator.dart';
```

- [ ] **Step 4: Add the UI fields to `AddProductScreen`**

In `lib/features/food_logging/presentation/add_product/add_product_screen.dart`, add two controllers (near `_storeController`):

```dart
  final _storeController = TextEditingController();
  final _pieceLabelController = TextEditingController();
  final _pieceWeightController = TextEditingController();
```

initialize them in `initState` (after `_storeController.text = initial.store ?? '';`):

```dart
    _storeController.text = initial.store ?? '';
    _pieceLabelController.text = initial.pieceLabel ?? '';
    _pieceWeightController.text = initial.pieceWeightGrams?.toString() ?? '';
```

add them to the `dispose()` list (after `_storeController`):

```dart
      _nameController, _brandController, _storeController, _pieceLabelController,
      _pieceWeightController, _barcodeController,
```

and insert the new section after the "Nutrition label" OCR `Container` block's closing `const SizedBox(height: 16),` (right before the `if (state.macroMismatchWarning != null)` block):

```dart
                  const SizedBox(height: 16),
                  Text('Piece size (optional)', style: DashboardTextStyles.mealKcal),
                  const SizedBox(height: 4),
                  Text(
                    'Let this food be logged by count (e.g. "1 carrot") instead of always by weight.',
                    style: DashboardTextStyles.mealKcal.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _LabeledField(
                          label: 'Label',
                          controller: _pieceLabelController,
                          onChanged: (v) => notifier.setPieceLabel(v.trim().isEmpty ? null : v),
                          hint: 'e.g. carrot',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LabeledNumberField(
                          label: 'Weight per piece (g)',
                          controller: _pieceWeightController,
                          onChanged: (v) => notifier.setPieceWeightGrams(_parse(v)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state.macroMismatchWarning != null)
```

(the final line replaces the existing `if (state.macroMismatchWarning != null)` — it isn't a new line, just marking where the inserted block ends).

- [ ] **Step 5: Regenerate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`, revert unrelated regenerated files, then:
Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing (unchanged; no new tests in this task, following the codebase's existing precedent of not unit-testing `AddProductNotifier`/`AddProductScreen`).

- [ ] **Step 6: Commit**

```bash
git add lib/features/food_logging/presentation/providers/add_product_form_state.dart lib/features/food_logging/presentation/providers/add_product_notifier.dart lib/features/food_logging/presentation/providers/add_product_form_state.freezed.dart lib/features/food_logging/presentation/add_product/add_product_screen.dart
git commit -m "Add optional piece-size fields to the Add/Edit Product screen"
```

---

### Task 7: Food Detail screen — logging by grams or piece

**Files:**
- Modify: `lib/features/food_logging/presentation/detail/food_detail_screen.dart`
- Modify: `lib/features/food_logging/presentation/providers/diary_providers.dart:26-51`

**Interfaces:**
- Consumes: `PieceAwareQuantityField`, `LoggedQuantity` (Task 5); `Food.pieceLabel`/`pieceWeightGrams` (Task 3); `DiaryEntry.snapshotFrom`'s new `unitLabel`/`unitCount` params (Task 3).
- Produces: `LogFoodNotifier.logFood({required Food food, required double quantityGrams, required MealType mealType, String? unitLabel, double? unitCount})`.

- [ ] **Step 1: Update the Design artifact and get confirmation**

Open the Design canvas artifact, find the Food Detail screen's mockup, and update its "Serving size" stepper: when the food has a piece unit, show the grams/piece segmented toggle above it (same visual treatment as the Recipe Detail screen's existing grams/servings toggle), with the stepper's unit suffix and step size switching accordingly. Show the user the updated mockup and get explicit confirmation before proceeding to Step 2.

- [ ] **Step 2: Extend `LogFoodNotifier.logFood` to accept a unit**

In `lib/features/food_logging/presentation/providers/diary_providers.dart`, change:

```dart
  Future<void> logFood({
    required Food food,
    required double quantityGrams,
    required MealType mealType,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: quantityGrams,
        mealType: mealType,
        loggedAt: DateTime.now(),
      );
```

to:

```dart
  Future<void> logFood({
    required Food food,
    required double quantityGrams,
    required MealType mealType,
    String? unitLabel,
    double? unitCount,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final entry = DiaryEntry.snapshotFrom(
        food: food,
        quantityGrams: quantityGrams,
        mealType: mealType,
        loggedAt: DateTime.now(),
        unitLabel: unitLabel,
        unitCount: unitCount,
      );
```

- [ ] **Step 3: Wire the widget and local unit state into `FoodDetailScreen`**

In `lib/features/food_logging/presentation/detail/food_detail_screen.dart`, replace the import:

```dart
import '../widgets/quantity_stepper.dart';
```

with:

```dart
import '../widgets/piece_aware_quantity_field.dart';
```

add local state fields (after `late MealType _selectedMeal = ...;`):

```dart
  String? _loggedUnitLabel;
  double? _loggedUnitCount;
```

update `_addToMeal` to pass them through:

```dart
  Future<void> _addToMeal(Food food, double grams) async {
    await ref.read(logFoodProvider.notifier).logFood(
          food: food,
          quantityGrams: grams,
          mealType: _selectedMeal,
          unitLabel: _loggedUnitLabel,
          unitCount: _loggedUnitCount,
        );
```

and replace the `QuantityStepper(...)` call with:

```dart
                      PieceAwareQuantityField(
                        grams: grams,
                        pieceLabel: food.pieceLabel,
                        pieceWeightGrams: food.pieceWeightGrams,
                        onChanged: (quantity) {
                          ref.read(foodQuantityProvider.notifier).setGrams(quantity.grams);
                          setState(() {
                            _loggedUnitLabel = quantity.unitLabel;
                            _loggedUnitCount = quantity.unitCount;
                          });
                        },
                        label: 'Serving size',
                        minGrams: 25,
                        maxGrams: 400,
                      ),
```

- [ ] **Step 4: Verify**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing (unchanged; no widget-test precedent for this screen).

- [ ] **Step 5: Commit**

```bash
git add lib/features/food_logging/presentation/detail/food_detail_screen.dart lib/features/food_logging/presentation/providers/diary_providers.dart
git commit -m "Let Food Detail log by grams or by piece"
```

---

### Task 8: Add Ingredient / Create Recipe — piece-based ingredients

**Files:**
- Modify: `lib/features/food_logging/presentation/add_ingredient/ingredient_pick_result.dart`
- Modify: `lib/features/food_logging/presentation/add_ingredient/add_ingredient_screen.dart`
- Modify: `lib/features/food_logging/presentation/providers/create_recipe_notifier.dart:44-49`
- Modify: `lib/features/food_logging/presentation/create_recipe/create_recipe_screen.dart:57-61,270-304`

**Interfaces:**
- Consumes: `PieceAwareQuantityField`, `LoggedQuantity` (Task 5); `RecipeIngredient.fromFood`'s new `unitLabel`/`unitCount` params (Task 3); `formatLoggedQuantity` (Task 1).
- Produces: `IngredientPickResult.unitLabel`/`unitCount`; `CreateRecipeNotifier.addIngredient(Food food, double grams, {String? unitLabel, double? unitCount})`.

- [ ] **Step 1: Update the Design artifact and get confirmation**

Open the Design canvas artifact, find the Add Ingredient screen's mockup (the quantity step reached after picking a food), and apply the same grams/piece toggle treatment as Food Detail. Also update the Create Recipe screen's ingredient list rows to show "2 carrots (120g) · 41 kcal" instead of "120g · 41 kcal" when a piece unit was used. Get the user's explicit confirmation before proceeding to Step 2.

- [ ] **Step 2: Add unit fields to `IngredientPickResult`**

In `lib/features/food_logging/presentation/add_ingredient/ingredient_pick_result.dart`:

```dart
import '../../domain/models/food.dart';

/// Popped result of [AddIngredientScreen] — the food and quantity the user
/// picked, for the caller (Create Recipe) to turn into a [RecipeIngredient].
class IngredientPickResult {
  const IngredientPickResult({
    required this.food,
    required this.grams,
    this.unitLabel,
    this.unitCount,
  });

  final Food food;
  final double grams;
  final String? unitLabel;
  final double? unitCount;
}
```

- [ ] **Step 3: Wire the widget and unit state into `AddIngredientScreen`**

In `lib/features/food_logging/presentation/add_ingredient/add_ingredient_screen.dart`, replace the import:

```dart
import '../widgets/quantity_stepper.dart';
```

with:

```dart
import '../widgets/piece_aware_quantity_field.dart';
```

add local state fields (after `double _grams = 100;`):

```dart
  String? _unitLabel;
  double? _unitCount;
```

reset them in `_pick`:

```dart
  void _pick(Food food) {
    setState(() {
      _selected = food;
      _grams = 100;
      _unitLabel = null;
      _unitCount = null;
    });
  }
```

pass them through in `_confirm`:

```dart
  void _confirm() {
    context.pop(IngredientPickResult(
      food: _selected!,
      grams: _grams,
      unitLabel: _unitLabel,
      unitCount: _unitCount,
    ));
  }
```

and in `_buildQuantity`, replace:

```dart
              QuantityStepper(grams: _grams, onChanged: (v) => setState(() => _grams = v)),
```

with:

```dart
              PieceAwareQuantityField(
                grams: _grams,
                pieceLabel: food.pieceLabel,
                pieceWeightGrams: food.pieceWeightGrams,
                onChanged: (quantity) => setState(() {
                  _grams = quantity.grams;
                  _unitLabel = quantity.unitLabel;
                  _unitCount = quantity.unitCount;
                }),
              ),
```

- [ ] **Step 4: Accept a unit in `CreateRecipeNotifier.addIngredient`**

In `lib/features/food_logging/presentation/providers/create_recipe_notifier.dart`, replace:

```dart
  void addIngredient(Food food, double grams) {
    final ingredient = RecipeIngredient.fromFood(food: food, grams: grams);
    state = state.copyWith(ingredients: [...state.ingredients, ingredient]);
  }
```

with:

```dart
  void addIngredient(Food food, double grams, {String? unitLabel, double? unitCount}) {
    final ingredient = RecipeIngredient.fromFood(
      food: food,
      grams: grams,
      unitLabel: unitLabel,
      unitCount: unitCount,
    );
    state = state.copyWith(ingredients: [...state.ingredients, ingredient]);
  }
```

- [ ] **Step 5: Pass the unit through and display it in `CreateRecipeScreen`**

In `lib/features/food_logging/presentation/create_recipe/create_recipe_screen.dart`, update `_addIngredient`:

```dart
  Future<void> _addIngredient(CreateRecipeNotifier notifier) async {
    final result = await context.push<IngredientPickResult>(AppRoutes.addIngredientPath);
    if (result == null) return;
    notifier.addIngredient(
      result.food,
      result.grams,
      unitLabel: result.unitLabel,
      unitCount: result.unitCount,
    );
  }
```

and in `_IngredientRow.build`, replace:

```dart
                Text(
                  '${ingredient.grams.toStringAsFixed(0)} g · ${ingredient.calories.toStringAsFixed(0)} kcal',
                  style: DashboardTextStyles.mealKcal,
                ),
```

with:

```dart
                Text(
                  '${formatLoggedQuantity(grams: ingredient.grams, unitLabel: ingredient.unitLabel, unitCount: ingredient.unitCount)} · '
                  '${ingredient.calories.toStringAsFixed(0)} kcal',
                  style: DashboardTextStyles.mealKcal,
                ),
```

Add the import at the top of the file:

```dart
import '../../domain/quantity/logged_quantity_display.dart';
```

- [ ] **Step 6: Verify**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing.

- [ ] **Step 7: Commit**

```bash
git add lib/features/food_logging/presentation/add_ingredient/ lib/features/food_logging/presentation/providers/create_recipe_notifier.dart lib/features/food_logging/presentation/create_recipe/create_recipe_screen.dart
git commit -m "Let recipe ingredients be added by grams or by piece"
```

---

### Task 9: Diary entry editing and display

**Files:**
- Modify: `lib/features/food_logging/presentation/widgets/edit_diary_entry_sheet.dart`
- Modify: `lib/features/food_logging/presentation/providers/diary_providers.dart:101-135`
- Modify: `lib/features/diary/presentation/widgets/meal_section_card.dart:172-175`

**Interfaces:**
- Consumes: `PieceAwareQuantityField`, `LoggedQuantity` (Task 5); `formatLoggedQuantity` (Task 1); `DiaryEntry.loggedUnitLabel`/`loggedUnitCount` (Task 3).
- Produces: `DiaryEntryController.updateQuantity({required DateTime date, required DiaryEntry entry, required double newGrams, String? unitLabel, double? unitCount})`.

- [ ] **Step 1: Update the Design artifact and get confirmation**

Open the Design canvas artifact and update: (a) the Edit Diary Entry bottom sheet's mockup to show the same grams/piece toggle when the underlying food has a piece unit, seeded to whatever unit the entry was originally logged with; (b) the Diary/Goals screen's meal item row to show "2 carrots (120g)" instead of "120g" when an item was logged with a unit. Get the user's explicit confirmation before proceeding to Step 2.

- [ ] **Step 2: Extend `DiaryEntryController.updateQuantity` to accept and persist a unit**

In `lib/features/food_logging/presentation/providers/diary_providers.dart`, replace:

```dart
  Future<void> updateQuantity({
    required DateTime date,
    required DiaryEntry entry,
    required double newGrams,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updated = entry.foodId != null
          ? await _rescaleFood(entry, newGrams)
          : await _rescaleRecipe(entry, newGrams);
      await ref.read(diaryRepositoryProvider).updateEntry(updated);
      ref.invalidate(diaryEntriesForDateProvider(DateUtils.dateOnly(date)));
    });
  }

  Future<DiaryEntry> _rescaleFood(DiaryEntry entry, double grams) async {
    final food = await ref.read(foodByIdProvider(entry.foodId!).future);
    final nutrition = food!.scaledTo(grams);
    return entry.copyWith(
      quantityGrams: grams,
      calories: nutrition.calories,
      protein: nutrition.protein,
      fat: nutrition.fat,
      carbs: nutrition.carbs,
      fiber: nutrition.fiber,
      sugar: nutrition.sugar,
      sodiumMg: nutrition.sodiumMg,
      cholesterolMg: nutrition.cholesterolMg,
      potassiumMg: nutrition.potassiumMg,
      calciumMg: nutrition.calciumMg,
      ironMg: nutrition.ironMg,
      vitaminCMg: nutrition.vitaminCMg,
      vitaminDMcg: nutrition.vitaminDMcg,
    );
  }
```

with:

```dart
  Future<void> updateQuantity({
    required DateTime date,
    required DiaryEntry entry,
    required double newGrams,
    String? unitLabel,
    double? unitCount,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updated = entry.foodId != null
          ? await _rescaleFood(entry, newGrams, unitLabel: unitLabel, unitCount: unitCount)
          : await _rescaleRecipe(entry, newGrams);
      await ref.read(diaryRepositoryProvider).updateEntry(updated);
      ref.invalidate(diaryEntriesForDateProvider(DateUtils.dateOnly(date)));
    });
  }

  Future<DiaryEntry> _rescaleFood(
    DiaryEntry entry,
    double grams, {
    String? unitLabel,
    double? unitCount,
  }) async {
    final food = await ref.read(foodByIdProvider(entry.foodId!).future);
    final nutrition = food!.scaledTo(grams);
    return entry.copyWith(
      quantityGrams: grams,
      calories: nutrition.calories,
      protein: nutrition.protein,
      fat: nutrition.fat,
      carbs: nutrition.carbs,
      fiber: nutrition.fiber,
      sugar: nutrition.sugar,
      sodiumMg: nutrition.sodiumMg,
      cholesterolMg: nutrition.cholesterolMg,
      potassiumMg: nutrition.potassiumMg,
      calciumMg: nutrition.calciumMg,
      ironMg: nutrition.ironMg,
      vitaminCMg: nutrition.vitaminCMg,
      vitaminDMcg: nutrition.vitaminDMcg,
      loggedUnitLabel: unitLabel,
      loggedUnitCount: unitCount,
    );
  }
```

(`_rescaleRecipe` is unchanged — recipe entries never carry a unit.) Passing `unitLabel`/`unitCount` explicitly through `copyWith` — even when null — clears them on the entry when the user switches back to grams while editing; this relies on Freezed's generated `copyWith`, which distinguishes an explicitly-passed `null` from an omitted argument.

- [ ] **Step 3: Wire the widget into `EditDiaryEntrySheet`**

In `lib/features/food_logging/presentation/widgets/edit_diary_entry_sheet.dart`, replace the import:

```dart
import 'quantity_stepper.dart';
```

with:

```dart
import '../../domain/models/food.dart';
import 'piece_aware_quantity_field.dart';
```

add local state fields (after `late double _grams = widget.entry.quantityGrams;`):

```dart
  String? _unitLabel = widget.entry.loggedUnitLabel;
  double? _unitCount = widget.entry.loggedUnitCount;
```

update `_save` to pass them through:

```dart
  Future<void> _save() async {
    setState(() => _isSaving = true);
    await ref
        .read(diaryEntryControllerProvider.notifier)
        .updateQuantity(
          date: widget.date,
          entry: widget.entry,
          newGrams: _grams,
          unitLabel: _unitLabel,
          unitCount: _unitCount,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }
```

replace the preview-calories block in `build` to also capture the food (for its piece unit):

```dart
    final entry = widget.entry;
    Food? food;
    double? previewCalories;
    if (entry.foodId != null) {
      food = ref.watch(foodByIdProvider(entry.foodId!)).value;
      previewCalories = food?.scaledTo(_grams).calories;
    } else if (entry.recipeId != null) {
      previewCalories = ref
          .watch(recipeByIdProvider(entry.recipeId!))
          .value
          ?.scaledTo(_grams)
          .calories;
    }
    previewCalories ??= entry.calories * (_grams / entry.quantityGrams);
```

and replace the `QuantityStepper(...)` call with:

```dart
          PieceAwareQuantityField(
            grams: _grams,
            pieceLabel: food?.pieceLabel,
            pieceWeightGrams: food?.pieceWeightGrams,
            initialUnitCount: widget.entry.loggedUnitCount,
            showCard: false,
            minGrams: 5,
            maxGrams: 2000,
            onChanged: (quantity) => setState(() {
              _grams = quantity.grams;
              _unitLabel = quantity.unitLabel;
              _unitCount = quantity.unitCount;
            }),
          ),
```

- [ ] **Step 4: Show the unit in the meal list**

In `lib/features/diary/presentation/widgets/meal_section_card.dart`, add the import:

```dart
import '../../../food_logging/domain/quantity/logged_quantity_display.dart';
```

and replace:

```dart
                                  Text(
                                    '${item.quantityGrams.toStringAsFixed(0)} g',
                                    style: DashboardTextStyles.mealItemGrams,
                                  ),
```

with:

```dart
                                  Text(
                                    formatLoggedQuantity(
                                      grams: item.quantityGrams,
                                      unitLabel: item.loggedUnitLabel,
                                      unitCount: item.loggedUnitCount,
                                    ),
                                    style: DashboardTextStyles.mealItemGrams,
                                  ),
```

- [ ] **Step 5: Verify**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing.

- [ ] **Step 6: Commit**

```bash
git add lib/features/food_logging/presentation/widgets/edit_diary_entry_sheet.dart lib/features/food_logging/presentation/providers/diary_providers.dart lib/features/diary/presentation/widgets/meal_section_card.dart
git commit -m "Let diary entries be edited by piece and display their logged unit"
```

---

## After the last task

Run the full verification suite once more from a clean state (`dart run build_runner build --delete-conflicting-outputs`, revert any unrelated drift, `flutter analyze`, `flutter test`), then open a PR following this repository's existing pattern (feature branch off `main`, PR description summarizing the change, standard attribution trailer). No manual UI verification is possible in this project (no configured web/browser target) — say so explicitly rather than claiming it was checked.
