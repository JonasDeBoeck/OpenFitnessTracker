# mL Logging for Liquids Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let a food optionally define a density (grams per mL) so it can be logged — to the diary and as a recipe ingredient — by volume instead of only by grams, by generalizing the piece-logging feature's existing architecture rather than building a parallel system.

**Architecture:** A food gets one new nullable field (`mlDensityGramsPerMl`), parallel to but independent from its existing piece fields — a food has a piece unit, an mL unit, or neither, never both. `RecipeIngredient` and `DiaryEntry` need no changes at all, since their `unitLabel`/`unitCount` fields already generalize beyond "piece". The shared quantity-entry widget is renamed and generalized from `PieceAwareQuantityField` to `AlternateUnitQuantityField`, collapsing its piece-specific parameters into one `AlternateUnit` value built by a new `Food.alternateUnit` getter, so every call site asks the food once instead of branching on piece-vs-volume itself.

**Tech Stack:** Flutter, Riverpod (`@riverpod` codegen), Freezed, Drift (SQLite), `flutter_test`.

**Spec:** [docs/superpowers/specs/2026-09-23-ml-liquid-logging-design.md](../specs/2026-09-23-ml-liquid-logging-design.md)

## Global Constraints

- Use `ref.invalidate()`, never `ref.refresh()`.
- No business logic in widgets — logic belongs in notifiers or repositories; widgets only call them.
- One public widget per widget file; prefix private widgets with `_`.
- Never hand-edit `*.g.dart`/`*.freezed.dart` — regenerate with `dart run build_runner build --delete-conflicting-outputs` after any change to an annotated file.
- Do not add new packages without asking first.
- A food has a piece unit, an mL unit, or neither — never both. Enforced by the Add/Edit Product screen's UI (switching which kind is selected clears the other kind's fields), not by a combined validator.
- Grams stays the sole source of truth for nutrition everywhere; `mlDensityGramsPerMl` is only a conversion factor applied once at quantity-entry time — a food's nutrition stays per-100g always, never per-100mL.
- "mL" is the one fixed, non-freeform unit label in the system (unlike a piece's user-typed label) and never pluralizes.
- Per `.claude/CLAUDE.md`: before implementing any new UI, update the relevant mockup(s) in the Design canvas artifact (https://claude.ai/artifact/GoiswZcxUzWMAKqGGEF214) and get the user's explicit confirmation the design is correct. Per the spec, only the Add/Edit Product screen's mockup (`ManualEntry.dc.html`) needs this — every other touched screen's mockup already renders whatever `unitLabel`/`unitCount` the data carries, without special-casing "piece".
- This project has no configured web/browser target — UI cannot be verified in a browser preview. Verify via `flutter analyze` + `flutter test`, and say explicitly that manual UI verification wasn't possible.
- Regenerating code in this environment reliably touches unrelated `.g.dart`/`.freezed.dart` files (environment drift, not caused by these changes). After every `build_runner` run: `git status --short`, revert (`git checkout --`) any regenerated file whose hand-written source this plan didn't touch, then re-verify `flutter analyze`/`flutter test`.

## Review Focus

- An mL density of zero or negative must be rejected at save, the same way a zero/negative piece weight already is — not silently accepted and producing 0-gram or negative-gram log entries later. (Task 1's pure validator test, Task 5's screen wiring)
- A food that somehow has both piece fields and `mlDensityGramsPerMl` set (state management bug, not reachable through normal use per the UI's mutual exclusivity) must resolve to *some* defined, tested behavior rather than an untested code path — `Food.alternateUnit` documents and tests that piece takes priority. (Task 1)
- Switching the Add/Edit Product screen's alternate-unit selector away from a kind must actually clear that kind's *persisted* fields (via the notifier), not just hide its UI controls — otherwise a food saved after switching from Piece to Liquid could still carry a stale `pieceLabel`/`pieceWeightGrams` the user no longer sees. (Task 5)
- A logged mL quantity with a fractional count (typing "125.5" directly, since mL doesn't force whole-number typing any more than grams does) must format sensibly and still never pluralize "mL". (Task 1's `formatLoggedQuantity` test)
- Editing an existing mL food's density later must never retroactively change an already-logged diary entry or already-saved recipe ingredient's quantity — already guaranteed structurally, since `RecipeIngredient.fromFood`/`DiaryEntry.snapshotFrom` snapshot from their own explicit `unitLabel`/`unitCount` parameters and never re-derive from a live `Food`, and this plan doesn't touch either factory. No new test needed; confirmed by inspection and by the existing piece-logging tests for the same factories, which this plan leaves untouched.

---

### Task 1: Alternate-unit domain helpers

**Files:**
- Create: `lib/features/food_logging/domain/quantity/alternate_unit.dart`
- Modify: `lib/features/food_logging/domain/models/food.dart:1-4,10-34,60-67`
- Create: `lib/features/food_logging/domain/validation/ml_density_validator.dart`
- Modify: `lib/features/food_logging/domain/quantity/logged_quantity_display.dart`
- Test: `test/features/food_logging/domain/models/food_test.dart` (append)
- Test: `test/features/food_logging/domain/validation/ml_density_validator_test.dart` (new)
- Test: `test/features/food_logging/domain/quantity/logged_quantity_display_test.dart` (append)

**Interfaces:**
- Produces: `class AlternateUnit { const AlternateUnit({required String label, required double weightPerUnitGrams, required double step, required bool pluralize}); final String label; final double weightPerUnitGrams; final double step; final bool pluralize; }` and `const mlUnitLabel = 'mL';`, both in `alternate_unit.dart`.
- Produces: `Food.mlDensityGramsPerMl` (`double?`, new constructor field), `Food.hasVolumeUnit` (`bool` getter), `Food.alternateUnit` (`AlternateUnit?` getter).
- Produces: `String? mlDensityValidationError({required double? densityGramsPerMl})`.
- Consumes: nothing from a later task. `pieceCountFromGrams`/`gramsFromPieceCount` (existing, in `piece_conversion.dart`) are NOT touched or renamed by this task — Task 4 imports and calls them exactly as they exist today.

- [ ] **Step 1: Write the failing tests for `Food.hasVolumeUnit` and `Food.alternateUnit`**

Append to `test/features/food_logging/domain/models/food_test.dart` (a new top-level import plus two new `group`s, as siblings to the existing groups inside `main()`):

```dart
import 'package:open_fitness_tracker/features/food_logging/domain/quantity/alternate_unit.dart';
```

```dart
  group('Food.hasVolumeUnit', () {
    test('is true when mlDensityGramsPerMl is set', () {
      const food = Food(name: 'Milk', mlDensityGramsPerMl: 1.03);
      expect(food.hasVolumeUnit, isTrue);
    });

    test('is false when unset', () {
      const food = Food(name: 'Rice');
      expect(food.hasVolumeUnit, isFalse);
    });
  });

  group('Food.alternateUnit', () {
    test('returns the piece flavor when only piece fields are set', () {
      const food = Food(name: 'Carrot', pieceLabel: 'carrot', pieceWeightGrams: 60);
      final unit = food.alternateUnit;
      expect(unit, isNotNull);
      expect(unit!.label, 'carrot');
      expect(unit.weightPerUnitGrams, 60);
      expect(unit.step, 1);
      expect(unit.pluralize, isTrue);
    });

    test('returns the volume flavor when only mlDensityGramsPerMl is set', () {
      const food = Food(name: 'Milk', mlDensityGramsPerMl: 1.03);
      final unit = food.alternateUnit;
      expect(unit, isNotNull);
      expect(unit!.label, mlUnitLabel);
      expect(unit.weightPerUnitGrams, 1.03);
      expect(unit.step, 50);
      expect(unit.pluralize, isFalse);
    });

    test('is null when neither is set', () {
      const food = Food(name: 'Rice');
      expect(food.alternateUnit, isNull);
    });

    test('prefers the piece flavor when both are somehow set', () {
      const food = Food(
        name: 'Weird',
        pieceLabel: 'carrot',
        pieceWeightGrams: 60,
        mlDensityGramsPerMl: 1.03,
      );
      expect(food.alternateUnit!.label, 'carrot');
    });
  });
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/models/food_test.dart`
Expected: FAIL — `Food` has no `mlDensityGramsPerMl`/`hasVolumeUnit`/`alternateUnit` yet, and `alternate_unit.dart` doesn't exist (compile error).

- [ ] **Step 3: Implement `AlternateUnit`**

```dart
// lib/features/food_logging/domain/quantity/alternate_unit.dart

/// A generic alternate unit a food can optionally be logged in, besides
/// grams — either a countable piece ("1 carrot") or a volume ("250 mL"),
/// built by [Food.alternateUnit] from whichever underlying fields are set.
class AlternateUnit {
  const AlternateUnit({
    required this.label,
    required this.weightPerUnitGrams,
    required this.step,
    required this.pluralize,
  });

  /// The unit's display name — a freeform word for a piece ("carrot"), or
  /// always "mL" for a volume unit.
  final String label;

  /// How many grams one unit of this is worth — a piece's average weight,
  /// or a liquid's density in grams per mL.
  final double weightPerUnitGrams;

  /// How much the quantity-entry stepper's +/- buttons change the count by
  /// — 1 for a piece (can't step by a fraction of a whole item), 50 for
  /// mL (a sensible liquid-measuring increment).
  final double step;

  /// Whether [label] pluralizes for a count other than 1 ("carrot" →
  /// "carrots"). Always false for mL, the one fixed, non-freeform label in
  /// the system.
  final bool pluralize;
}

/// The fixed label every volume-unit food uses — never user-entered,
/// unlike a piece's freeform label.
const mlUnitLabel = 'mL';
```

- [ ] **Step 4: Add the field and getters to `Food`**

In `lib/features/food_logging/domain/models/food.dart`, add the import at the top of the file:

```dart
import '../quantity/alternate_unit.dart';
```

Add one field to the factory constructor (after `pieceWeightGrams`):

```dart
    String? pieceLabel,
    double? pieceWeightGrams,
    double? mlDensityGramsPerMl,
    @Default(false) bool isFavorite,
```

Add two getters alongside `hasPieceUnit`:

```dart
  /// Whether this food has a density (grams per mL) defined, letting it be
  /// logged by volume instead of only by grams.
  bool get hasVolumeUnit => mlDensityGramsPerMl != null;

  /// The single alternate unit this food can be logged in, or null for a
  /// grams-only food. A food has a piece unit, an mL unit, or neither —
  /// never both (enforced on the Add/Edit Product screen, where switching
  /// which kind is selected clears the other kind's fields). If both are
  /// somehow set, piece takes priority — an arbitrary but defined and
  /// tested choice for a state the UI never actually produces.
  AlternateUnit? get alternateUnit {
    if (hasPieceUnit) {
      return AlternateUnit(
        label: pieceLabel!,
        weightPerUnitGrams: pieceWeightGrams!,
        step: 1,
        pluralize: true,
      );
    }
    if (hasVolumeUnit) {
      return AlternateUnit(
        label: mlUnitLabel,
        weightPerUnitGrams: mlDensityGramsPerMl!,
        step: 50,
        pluralize: false,
      );
    }
    return null;
  }
```

- [ ] **Step 5: Regenerate and run the test to verify it passes**

Run: `dart run build_runner build --delete-conflicting-outputs`, then revert unrelated regenerated files per the Global Constraints note, then:
Run: `flutter test test/features/food_logging/domain/models/food_test.dart`
Expected: PASS (7 new tests + existing ones)

- [ ] **Step 6: Write the failing tests for `mlDensityValidationError`**

```dart
// test/features/food_logging/domain/validation/ml_density_validator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:open_fitness_tracker/features/food_logging/domain/validation/ml_density_validator.dart';

void main() {
  group('mlDensityValidationError', () {
    test('is valid when unset', () {
      expect(mlDensityValidationError(densityGramsPerMl: null), isNull);
    });

    test('is valid when positive', () {
      expect(mlDensityValidationError(densityGramsPerMl: 1.03), isNull);
    });

    test('errors when zero', () {
      expect(mlDensityValidationError(densityGramsPerMl: 0), isNotNull);
    });

    test('errors when negative', () {
      expect(mlDensityValidationError(densityGramsPerMl: -1), isNotNull);
    });
  });
}
```

- [ ] **Step 7: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/validation/ml_density_validator_test.dart`
Expected: FAIL — `ml_density_validator.dart` doesn't exist yet.

- [ ] **Step 8: Implement `mlDensityValidationError`**

```dart
// lib/features/food_logging/domain/validation/ml_density_validator.dart

/// Validates the Add/Edit Product screen's optional liquid density field.
/// Returns the error to show, or null when the value is valid (including
/// when it's unset).
String? mlDensityValidationError({required double? densityGramsPerMl}) {
  if (densityGramsPerMl == null) return null;
  if (densityGramsPerMl <= 0) {
    return 'Enter a density greater than zero, or clear it to skip this.';
  }
  return null;
}
```

- [ ] **Step 9: Run the test to verify it passes**

Run: `flutter test test/features/food_logging/domain/validation/ml_density_validator_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 10: Write the failing tests for mL pluralization in `formatLoggedQuantity`**

Append to `test/features/food_logging/domain/quantity/logged_quantity_display_test.dart` (inside the existing `group('formatLoggedQuantity', ...)`, alongside the existing tests):

```dart
    test('does not pluralize the mL unit for a count other than 1', () {
      expect(
        formatLoggedQuantity(grams: 258, unitLabel: 'mL', unitCount: 250),
        '250 mL (258g)',
      );
    });

    test('does not pluralize the mL unit even for a count of 1', () {
      expect(
        formatLoggedQuantity(grams: 1, unitLabel: 'mL', unitCount: 1),
        '1 mL (1g)',
      );
    });

    test('does not pluralize the mL unit for a fractional count', () {
      expect(
        formatLoggedQuantity(grams: 129, unitLabel: 'mL', unitCount: 125.5),
        '125.5 mL (129g)',
      );
    });
```

- [ ] **Step 11: Run the test to verify it fails**

Run: `flutter test test/features/food_logging/domain/quantity/logged_quantity_display_test.dart`
Expected: FAIL — "250 mLs (258g)" (still pluralizing) instead of "250 mL (258g)".

- [ ] **Step 12: Fix the pluralization rule**

In `lib/features/food_logging/domain/quantity/logged_quantity_display.dart`, add the import:

```dart
import 'alternate_unit.dart';
```

Replace:

```dart
  final label = unitCount == 1 ? unitLabel : '${unitLabel}s';
```

with:

```dart
  final label = (unitCount == 1 || unitLabel == mlUnitLabel) ? unitLabel : '${unitLabel}s';
```

- [ ] **Step 13: Run the test to verify it passes**

Run: `flutter test test/features/food_logging/domain/quantity/logged_quantity_display_test.dart`
Expected: PASS (8 tests: 5 existing + 3 new)

- [ ] **Step 14: Run the full test suite and analyzer**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing.

- [ ] **Step 15: Commit**

```bash
git add lib/features/food_logging/domain/ test/features/food_logging/domain/
git commit -m "Add alternate-unit domain helpers for mL logging"
```

---

### Task 2: Database schema and migration

**Files:**
- Modify: `lib/features/food_logging/data/tables/foods_table.dart`
- Modify: `lib/core/database/app_database.dart:28,58-65`

**Interfaces:**
- Produces: `Foods.mlDensityGramsPerMl` (nullable real column).
- Produces: `AppDatabase.schemaVersion == 7`.

No new tests — no drift migration test precedent exists in this codebase (matches the same pattern used for every prior migration, including the piece-logging one). Verified by successful codegen + analyze, exercised end-to-end once Task 3 builds on the new column.

- [ ] **Step 1: Add the new column to `Foods`**

In `lib/features/food_logging/data/tables/foods_table.dart`, add after the existing `pieceWeightGrams` column:

```dart
  RealColumn get pieceWeightGrams => real().nullable()();
  // Optional liquid density (grams per mL) — like pieceLabel/
  // pieceWeightGrams, null means this food has no volume unit. A food
  // never has both a piece unit and this set at once (enforced on the
  // Add/Edit Product screen).
  RealColumn get mlDensityGramsPerMl => real().nullable()();
```

- [ ] **Step 2: Bump the schema version and add the migration step**

In `lib/core/database/app_database.dart`, change:

```dart
  int get schemaVersion => 6;
```

to:

```dart
  int get schemaVersion => 7;
```

and add a new branch inside `onUpgrade`, after the existing `if (from < 6) { ... }` block:

```dart
      if (from < 7) {
        await migrator.addColumn(foods, foods.mlDensityGramsPerMl);
      }
```

- [ ] **Step 3: Regenerate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`
Then: `git status --short` and `git checkout --` any regenerated file outside `lib/core/database/app_database.g.dart` and `lib/features/food_logging/data/tables/foods_table.dart`'s own generated counterpart.
Then: `flutter analyze`
Expected: no errors; `app_database.g.dart` reflects the new column.

- [ ] **Step 4: Commit**

```bash
git add lib/features/food_logging/data/tables/foods_table.dart lib/core/database/app_database.dart lib/core/database/app_database.g.dart
git commit -m "Add mlDensityGramsPerMl column to foods"
```

---

### Task 3: Repository mapping

**Files:**
- Modify: `lib/features/food_logging/data/food_repository.dart:125-178`

**Interfaces:**
- Consumes: `Food.mlDensityGramsPerMl` (Task 1); the new drift column (Task 2).
- Produces: no new public methods — `FoodRepository.create`/`update`/`getById`/etc. now round-trip the new field.

No new tests, matching the precedent set by the piece-logging feature's identical repository task (no repository test file exists for any of the three repositories in this codebase).

- [ ] **Step 1: Map the new field in `_toCompanion` and `_fromRow`**

In `lib/features/food_logging/data/food_repository.dart`, add to `_toCompanion` (after `pieceWeightGrams`):

```dart
      pieceLabel: Value(food.pieceLabel),
      pieceWeightGrams: Value(food.pieceWeightGrams),
      mlDensityGramsPerMl: Value(food.mlDensityGramsPerMl),
```

and to `_fromRow` (after `pieceWeightGrams`):

```dart
      pieceLabel: row.pieceLabel,
      pieceWeightGrams: row.pieceWeightGrams,
      mlDensityGramsPerMl: row.mlDensityGramsPerMl,
```

- [ ] **Step 2: Verify**

Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing (unchanged from Task 1; no new tests in this task).

- [ ] **Step 3: Commit**

```bash
git add lib/features/food_logging/data/food_repository.dart
git commit -m "Persist mlDensityGramsPerMl through the food repository"
```

---

### Task 4: Rename and generalize the alternate-unit quantity widget

**Files:**
- Create: `lib/features/food_logging/presentation/widgets/alternate_unit_quantity_field.dart`
- Delete: `lib/features/food_logging/presentation/widgets/piece_aware_quantity_field.dart`
- Modify: `lib/features/food_logging/presentation/detail/food_detail_screen.dart:16,138-141`
- Modify: `lib/features/food_logging/presentation/add_ingredient/add_ingredient_screen.dart:10,211-214`
- Modify: `lib/features/food_logging/presentation/widgets/edit_diary_entry_sheet.dart:11,86-89`

**Interfaces:**
- Consumes: `LoggedQuantity`, `gramsFromPieceCount`, `pieceCountFromGrams` (existing, from `piece_conversion.dart`, unchanged and not renamed — see Task 1's note); `AlternateUnit`, `Food.alternateUnit` (Task 1).
- Produces: `class AlternateUnitQuantityField extends StatefulWidget` with constructor `{required double grams, required ValueChanged<LoggedQuantity> onChanged, AlternateUnit? altUnit, double? initialUnitCount, String label = 'Quantity', bool showCard = true, double minGrams = 0, double maxGrams = double.infinity}`.

This task must land as one unit — renaming the widget's public API and updating its only three call sites has to happen together, or the branch won't compile in between. No new tests: no widget-test precedent exists for this widget (confirmed when it was first built) or for `QuantityStepper`, which it still delegates to for the grams-only case.

- [ ] **Step 1: Create the renamed, generalized widget**

```dart
// lib/features/food_logging/presentation/widgets/alternate_unit_quantity_field.dart
import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/quantity/alternate_unit.dart';
import '../../domain/quantity/piece_conversion.dart';
import 'quantity_stepper.dart';

enum _QuantityUnit { grams, alt }

/// Grams/alternate-unit control, generalizing the grams/servings toggle
/// that already exists privately in [RecipeDetailScreen]. Renders exactly
/// like [QuantityStepper] (unchanged look, unchanged behavior) whenever
/// [altUnit] is null; only when a food has an alternate unit (piece or
/// mL) does it add the segmented grams/alt-unit toggle. Always reports
/// back grams — plus the unit actually used, when applicable — via
/// [onChanged].
class AlternateUnitQuantityField extends StatefulWidget {
  const AlternateUnitQuantityField({
    super.key,
    required this.grams,
    required this.onChanged,
    this.altUnit,
    this.initialUnitCount,
    this.label = 'Quantity',
    this.showCard = true,
    this.minGrams = 0,
    this.maxGrams = double.infinity,
  });

  final double grams;
  final ValueChanged<LoggedQuantity> onChanged;
  final AlternateUnit? altUnit;
  /// When non-null (and [altUnit] is set), the field starts in alt-unit
  /// mode showing this count instead of starting in grams mode — used by
  /// the Edit Diary Entry sheet to reopen an entry the way it was
  /// originally logged.
  final double? initialUnitCount;
  final String label;
  final bool showCard;
  final double minGrams;
  final double maxGrams;

  @override
  State<AlternateUnitQuantityField> createState() => _AlternateUnitQuantityFieldState();
}

class _AlternateUnitQuantityFieldState extends State<AlternateUnitQuantityField> {
  late _QuantityUnit _unit = _startingUnit();
  late final _controller = TextEditingController(text: _initialText());

  bool get _hasAltUnit => widget.altUnit != null;

  _QuantityUnit _startingUnit() =>
      widget.initialUnitCount != null && _hasAltUnit ? _QuantityUnit.alt : _QuantityUnit.grams;

  String _initialText() => _unit == _QuantityUnit.alt
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

  double _clamp(double value) => _unit == _QuantityUnit.grams
      ? value.clamp(widget.minGrams, widget.maxGrams)
      : value.clamp(1, double.infinity);

  void _setValue(double value) {
    final clamped = _clamp(value);
    setState(() {
      _controller.text =
          _unit == _QuantityUnit.grams ? clamped.toStringAsFixed(0) : _trimTrailingZero(clamped);
    });
    _notify(clamped);
  }

  /// Clamps before reporting so a typed value (which the field displays
  /// as-is, unclamped, so a keystroke is never fought or rewritten mid-type
  /// — see [_clamp]'s caller here vs. [_setValue]'s) never reaches the
  /// caller out of range: clearing the field or typing something below
  /// the minimum still reports the floor, not a stray 0 or negative value.
  void _notify(double value) {
    final clamped = _clamp(value);
    if (_unit == _QuantityUnit.alt && _hasAltUnit) {
      final altUnit = widget.altUnit!;
      widget.onChanged(LoggedQuantity(
        grams: gramsFromPieceCount(clamped, altUnit.weightPerUnitGrams),
        unitLabel: altUnit.label,
        unitCount: clamped,
      ));
    } else {
      widget.onChanged(LoggedQuantity(grams: clamped));
    }
  }

  void _pickUnit(_QuantityUnit unit) {
    if (unit == _unit || !_hasAltUnit) return;
    final altUnit = widget.altUnit!;
    setState(() {
      _unit = unit;
      _controller.text = unit == _QuantityUnit.grams
          ? widget.grams.toStringAsFixed(0)
          : _trimTrailingZero(pieceCountFromGrams(widget.grams, altUnit.weightPerUnitGrams));
    });
    _notify(_value);
  }

  void _increment() => _setValue(
        _unit == _QuantityUnit.grams ? _value + 25 : _value + widget.altUnit!.step,
      );

  void _decrement() => _setValue(
        _unit == _QuantityUnit.grams ? _value - 25 : _value - widget.altUnit!.step,
      );

  @override
  Widget build(BuildContext context) {
    if (!_hasAltUnit) {
      return QuantityStepper(
        grams: widget.grams,
        onChanged: (value) => widget.onChanged(LoggedQuantity(grams: value)),
        label: widget.label,
        showCard: widget.showCard,
        minGrams: widget.minGrams,
        maxGrams: widget.maxGrams,
      );
    }

    final altUnit = widget.altUnit!;
    final unitSuffix = _unit == _QuantityUnit.grams
        ? 'g'
        : (!altUnit.pluralize || _value == 1 ? altUnit.label : '${altUnit.label}s');
    final altButtonLabel = altUnit.pluralize
        ? '${altUnit.label[0].toUpperCase()}${altUnit.label.substring(1)}s'
        : altUnit.label;

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
                  label: altButtonLabel,
                  active: _unit == _QuantityUnit.alt,
                  onTap: () => _pickUnit(_QuantityUnit.alt),
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

- [ ] **Step 2: Delete the old widget file**

```bash
git rm lib/features/food_logging/presentation/widgets/piece_aware_quantity_field.dart
```

- [ ] **Step 3: Update `FoodDetailScreen`**

In `lib/features/food_logging/presentation/detail/food_detail_screen.dart`, replace the import:

```dart
import '../widgets/piece_aware_quantity_field.dart';
```

with:

```dart
import '../widgets/alternate_unit_quantity_field.dart';
```

and replace:

```dart
                      PieceAwareQuantityField(
                        grams: grams,
                        pieceLabel: food.pieceLabel,
                        pieceWeightGrams: food.pieceWeightGrams,
                        onChanged: (quantity) {
```

with:

```dart
                      AlternateUnitQuantityField(
                        grams: grams,
                        altUnit: food.alternateUnit,
                        onChanged: (quantity) {
```

(the rest of that call — `label: 'Serving size', minGrams: 25, maxGrams: 400,` and the closing `),` — is unchanged).

- [ ] **Step 4: Update `AddIngredientScreen`**

In `lib/features/food_logging/presentation/add_ingredient/add_ingredient_screen.dart`, replace the import:

```dart
import '../widgets/piece_aware_quantity_field.dart';
```

with:

```dart
import '../widgets/alternate_unit_quantity_field.dart';
```

and replace:

```dart
              PieceAwareQuantityField(
                grams: _grams,
                pieceLabel: food.pieceLabel,
                pieceWeightGrams: food.pieceWeightGrams,
```

with:

```dart
              AlternateUnitQuantityField(
                grams: _grams,
                altUnit: food.alternateUnit,
```

(the rest of that call — its `onChanged` callback — is unchanged).

- [ ] **Step 5: Update `EditDiaryEntrySheet`**

In `lib/features/food_logging/presentation/widgets/edit_diary_entry_sheet.dart`, replace the import:

```dart
import 'piece_aware_quantity_field.dart';
```

with:

```dart
import 'alternate_unit_quantity_field.dart';
```

and replace:

```dart
          PieceAwareQuantityField(
            grams: _grams,
            pieceLabel: food?.pieceLabel,
            pieceWeightGrams: food?.pieceWeightGrams,
            initialUnitCount: widget.entry.loggedUnitCount,
```

with:

```dart
          AlternateUnitQuantityField(
            grams: _grams,
            altUnit: food?.alternateUnit,
            initialUnitCount: widget.entry.loggedUnitCount,
```

(the rest of that call — `showCard: false, minGrams: 5, maxGrams: 2000,` and its `onChanged` callback — is unchanged).

- [ ] **Step 6: Verify**

Run: `flutter analyze` — expected clean (no references to `PieceAwareQuantityField`/`piece_aware_quantity_field.dart` anywhere).
Run: `flutter test` — expected all passing.

- [ ] **Step 7: Commit**

```bash
git add lib/features/food_logging/presentation/widgets/alternate_unit_quantity_field.dart lib/features/food_logging/presentation/detail/food_detail_screen.dart lib/features/food_logging/presentation/add_ingredient/add_ingredient_screen.dart lib/features/food_logging/presentation/widgets/edit_diary_entry_sheet.dart
git commit -m "Rename and generalize PieceAwareQuantityField to AlternateUnitQuantityField"
```

---

### Task 5: Add/Edit Product screen — Alternate unit section

**Files:**
- Modify: `lib/features/food_logging/presentation/providers/add_product_form_state.dart`
- Modify: `lib/features/food_logging/presentation/providers/add_product_notifier.dart`
- Modify: `lib/features/food_logging/presentation/add_product/add_product_screen.dart`

**Interfaces:**
- Consumes: `mlDensityValidationError` (Task 1); `Food.mlDensityGramsPerMl` (Task 1).
- Produces: `AddProductFormState.mlDensityGramsPerMl`; `AddProductNotifier.setMlDensityGramsPerMl(double? value)`.

- [ ] **Step 1: Update the Design artifact and get confirmation**

Before writing any code, open the Design canvas artifact (https://claude.ai/artifact/GoiswZcxUzWMAKqGGEF214), find `ManualEntry.dc.html` (the Add/Edit Product screen's mockup), and replace its existing "Piece size (optional)" section with a broader "Alternate unit (optional)" section: a 3-way segmented selector — **None / Piece / Liquid** — styled like the existing meal-type pills already on that screen. Selecting **None** shows no extra fields. Selecting **Piece** shows exactly today's Label + Weight per piece (g) fields. Selecting **Liquid** shows a single "Density (g per mL)" number field with a hint line reading `Water ≈ 1.0, milk ≈ 1.03, oil ≈ 0.92`. Show the user the updated mockup and get their explicit confirmation it's correct before proceeding to Step 2. Do not write implementation code until confirmed.

- [ ] **Step 2: Add the new field to `AddProductFormState`**

In `lib/features/food_logging/presentation/providers/add_product_form_state.dart`, add one field to the factory constructor (after `pieceWeightGrams`):

```dart
    String? pieceLabel,
    double? pieceWeightGrams,
    double? mlDensityGramsPerMl,
    @Default(false) bool isFavorite,
```

- [ ] **Step 3: Add the setter, editing-prefill, validation, and save-mapping in `AddProductNotifier`**

In `lib/features/food_logging/presentation/providers/add_product_notifier.dart`, add the import:

```dart
import '../../domain/validation/ml_density_validator.dart';
```

Add to the `editingFood != null` branch of `build()` (after `pieceWeightGrams: editingFood.pieceWeightGrams,`):

```dart
        pieceLabel: editingFood.pieceLabel,
        pieceWeightGrams: editingFood.pieceWeightGrams,
        mlDensityGramsPerMl: editingFood.mlDensityGramsPerMl,
```

Add a setter (near `setPieceWeightGrams`):

```dart
  void setMlDensityGramsPerMl(double? value) =>
      state = state.copyWith(mlDensityGramsPerMl: value);
```

Add a validation check in `save()`'s `try` block, right after the existing `pieceSizeError` check:

```dart
      final pieceSizeError = pieceSizeValidationError(
        label: state.pieceLabel,
        weightGrams: state.pieceWeightGrams,
      );
      if (pieceSizeError != null) {
        state = state.copyWith(isSaving: false, saveError: pieceSizeError);
        return;
      }

      final mlDensityError = mlDensityValidationError(
        densityGramsPerMl: state.mlDensityGramsPerMl,
      );
      if (mlDensityError != null) {
        state = state.copyWith(isSaving: false, saveError: mlDensityError);
        return;
      }

      final macrosMatch = macrosRoughlyMatchCalories(
```

Add the field to the `Food(...)` construction (after `pieceWeightGrams: state.pieceWeightGrams,`):

```dart
        pieceLabel: state.pieceLabel,
        pieceWeightGrams: state.pieceWeightGrams,
        mlDensityGramsPerMl: state.mlDensityGramsPerMl,
```

- [ ] **Step 4: Add the kind selector and UI section to `AddProductScreen`**

In `lib/features/food_logging/presentation/add_product/add_product_screen.dart`, add a file-level private enum above the class (after the imports):

```dart
enum _AlternateUnitKind { none, piece, liquid }
```

Add a controller (near `_pieceWeightController`):

```dart
  final _mlDensityController = TextEditingController();
```

Add a mutable field (near the other state fields, e.g. right after the controller declarations):

```dart
  _AlternateUnitKind _altUnitKind = _AlternateUnitKind.none;
```

In `initState()`, after `_pieceWeightController.text = initial.pieceWeightGrams?.toString() ?? '';`, add:

```dart
    _mlDensityController.text = initial.mlDensityGramsPerMl?.toString() ?? '';
    if (initial.pieceLabel != null || initial.pieceWeightGrams != null) {
      _altUnitKind = _AlternateUnitKind.piece;
    } else if (initial.mlDensityGramsPerMl != null) {
      _altUnitKind = _AlternateUnitKind.liquid;
    }
```

Add `_mlDensityController` to the `dispose()` list (alongside `_pieceLabelController, _pieceWeightController,`):

```dart
      _nameController, _brandController, _storeController, _pieceLabelController,
      _pieceWeightController, _mlDensityController, _barcodeController,
```

Add a method (near `_save`):

```dart
  void _pickAltUnitKind(_AlternateUnitKind kind, AddProductNotifier notifier) {
    if (kind == _altUnitKind) return;
    setState(() {
      _altUnitKind = kind;
      if (kind != _AlternateUnitKind.piece) {
        _pieceLabelController.clear();
        _pieceWeightController.clear();
        notifier.setPieceLabel(null);
        notifier.setPieceWeightGrams(null);
      }
      if (kind != _AlternateUnitKind.liquid) {
        _mlDensityController.clear();
        notifier.setMlDensityGramsPerMl(null);
      }
    });
  }
```

Replace the existing "Piece size (optional)" section:

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
                          onChanged: (v) => notifier.setPieceLabel(v.trim().isEmpty ? null : v.trim()),
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
```

with:

```dart
                  const SizedBox(height: 16),
                  Text('Alternate unit (optional)', style: DashboardTextStyles.mealKcal),
                  const SizedBox(height: 4),
                  Text(
                    'Let this food be logged by count (e.g. "1 carrot") or by volume '
                    '(e.g. "250 mL") instead of always by weight.',
                    style: DashboardTextStyles.mealKcal.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _AltUnitKindButton(
                          label: 'None',
                          active: _altUnitKind == _AlternateUnitKind.none,
                          onTap: () => _pickAltUnitKind(_AlternateUnitKind.none, notifier),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _AltUnitKindButton(
                          label: 'Piece',
                          active: _altUnitKind == _AlternateUnitKind.piece,
                          onTap: () => _pickAltUnitKind(_AlternateUnitKind.piece, notifier),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _AltUnitKindButton(
                          label: 'Liquid',
                          active: _altUnitKind == _AlternateUnitKind.liquid,
                          onTap: () => _pickAltUnitKind(_AlternateUnitKind.liquid, notifier),
                        ),
                      ),
                    ],
                  ),
                  if (_altUnitKind == _AlternateUnitKind.piece) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Label',
                            controller: _pieceLabelController,
                            onChanged: (v) =>
                                notifier.setPieceLabel(v.trim().isEmpty ? null : v.trim()),
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
                  ],
                  if (_altUnitKind == _AlternateUnitKind.liquid) ...[
                    const SizedBox(height: 8),
                    _LabeledNumberField(
                      label: 'Density (g per mL)',
                      controller: _mlDensityController,
                      onChanged: (v) => notifier.setMlDensityGramsPerMl(_parse(v)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Water ≈ 1.0, milk ≈ 1.03, oil ≈ 0.92',
                      style: DashboardTextStyles.mealKcal.copyWith(fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 16),
```

Add a new private widget, alongside the file's other private widgets (e.g. after `_LabeledNumberField`):

```dart
class _AltUnitKindButton extends StatelessWidget {
  const _AltUnitKindButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.mealKcal.copyWith(
              fontWeight: FontWeight.w600,
              color: active ? DashboardColors.surface : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Regenerate and verify**

Run: `dart run build_runner build --delete-conflicting-outputs`, revert unrelated regenerated files, then:
Run: `flutter analyze` — expected clean.
Run: `flutter test` — expected all passing (no new tests in this task, following the same no-notifier/no-screen-test precedent the piece-logging feature's equivalent task used).

- [ ] **Step 6: Commit**

```bash
git add lib/features/food_logging/presentation/providers/add_product_form_state.dart lib/features/food_logging/presentation/providers/add_product_notifier.dart lib/features/food_logging/presentation/providers/add_product_form_state.freezed.dart lib/features/food_logging/presentation/add_product/add_product_screen.dart
git commit -m "Add liquid density option to the Add/Edit Product screen"
```

---

## After the last task

Run the full verification suite once more from a clean state (`dart run build_runner build --delete-conflicting-outputs`, revert any unrelated drift, `flutter analyze`, `flutter test`), then open a PR following this repository's existing pattern (feature branch off `main`, PR description summarizing the change, standard attribution trailer). No manual UI verification is possible in this project (no configured web/browser target) — say so explicitly rather than claiming it was checked.
