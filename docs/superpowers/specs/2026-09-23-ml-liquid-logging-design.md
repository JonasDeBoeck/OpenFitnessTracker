# mL logging for liquids — design

## Summary

Let a food optionally define a density (grams per mL) so it can be logged
— to the diary and as a recipe ingredient — by volume in millilitres
instead of only by grams, the same way an earlier feature let a food
define an average weight per piece for countable items ("1 carrot ≈
60g"). A food can have a piece unit, an mL unit, or neither — never both.
Grams stays the sole source of truth for nutrition everywhere; the unit
actually used is snapshotted onto the diary entry / recipe ingredient at
save time, exactly like piece logging already does.

## Goals

- Let the user log liquids (milk, juice, oil, broth, ...) by volume
  without mentally converting to grams.
- Reuse the piece-logging architecture and its shared widget rather than
  building a parallel system, since the two features are structurally
  identical (an optional alternate unit with a conversion factor to
  grams, frozen at save time).
- Support both individual foods (diary logging) and recipe ingredients,
  matching piece logging's scope.
- Zero behavior change for any food that doesn't opt in, and no change at
  all to foods that already use a piece unit.

## Non-goals

- No per-100mL nutrition basis. A food's nutrition stays per-100g always;
  density is only a conversion factor between mL and grams, applied once
  at quantity-entry time — mirrors how piece weight never changes how
  nutrition is stored, only how quantity is entered.
- No food with both a piece unit and an mL unit at once — confirmed
  during design. One alternate unit per food, or none.
- No density lookup/suggestion from an external source (no such
  integration exists in this app). The user types the number; the UI
  hints at a couple of reference points (water ≈ 1.0, milk ≈ 1.03, oil ≈
  0.92) so they're not guessing blind.

## Data model

### `Food` (`lib/features/food_logging/domain/models/food.dart`)

One new optional field:

```dart
double? mlDensityGramsPerMl,  // e.g. 1.03 for milk
```

`null` (the default) means "no mL unit," identical to every food before
this feature. New getter:

```dart
bool get hasVolumeUnit => mlDensityGramsPerMl != null;
```

### `AlternateUnit` (new: `lib/features/food_logging/domain/quantity/alternate_unit.dart`)

A small value type bundling everything the quantity-entry widget needs to
render either flavor of alternate unit, so call sites never branch on
piece-vs-volume themselves — they ask `Food` once and get back one thing
or nothing:

```dart
class AlternateUnit {
  const AlternateUnit({
    required this.label,
    required this.weightPerUnitGrams,
    required this.step,
    required this.pluralize,
  });

  final String label;
  final double weightPerUnitGrams;
  final double step;
  final bool pluralize;
}

const mlUnitLabel = 'mL';
```

`Food` gains a getter building this from whichever fields are set:

```dart
/// The single alternate unit this food can be logged in, or null for a
/// grams-only food. A food has a piece unit, an mL unit, or neither —
/// never both (enforced on the Add/Edit Product screen, where switching
/// which kind is selected clears the other kind's fields).
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

`step: 50` mirrors grams' existing 25g step, scaled to a sensible liquid
measuring increment (a shot glass is ~50mL). `pluralize: false` is what
keeps "1 mL" from becoming "1 mLs" — "mL" is the one fixed, non-freeform
label in the system (piece labels are always user-typed words that
correctly pluralize, "carrot" → "carrots"). `hasPieceUnit` is checked
first only because a food is guaranteed to have at most one of the two
sets of fields non-null; the order has no effect on valid data.

### `RecipeIngredient` / `DiaryEntry`

No changes. Both already carry generic `unitLabel`/`unitCount` fields
(added for piece logging but never named around "piece" specifically) —
"mL" is just another value `unitLabel` can hold. `formatLoggedQuantity`
needs one small change (see Display below) but the models themselves are
already general enough.

### Database

`schemaVersion` bumps from 6 to 7. One nullable column, following the
same `if (from < N)` cumulative pattern already used for every prior
migration:

```dart
// foods_table.dart
RealColumn get mlDensityGramsPerMl => real().nullable()();
```

```dart
if (from < 7) {
  await migrator.addColumn(foods, foods.mlDensityGramsPerMl);
}
```

`FoodRepository._toCompanion`/`_fromRow` need the one new field added to
their existing field-by-field mapping. `RecipeRepository` and
`DiaryRepository` need no changes — they already map `unitLabel`/
`unitCount` generically.

## Validation

New, parallel to `pieceSizeValidationError`
(`lib/features/food_logging/domain/validation/`):

```dart
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

Simpler than the piece validator — there's no paired label to check
both-or-neither on, since "mL" isn't user-entered. Mutual exclusivity
between a piece unit and an mL unit isn't separately validated: the
Add/Edit Product screen's UI (below) makes it structurally impossible to
fill both, the same way today's screen makes it impossible to enter a
weight-per-piece for two different labels at once. This matches the
project's validate-at-the-boundary convention — the boundary is the form
UI, and the UI already enforces it.

## UI changes

### Add/Edit Product screen

Design canvas mockup: `ManualEntry.dc.html` — the existing "Piece size
(optional)" section becomes a broader "Alternate unit (optional)" section
with a 3-way segmented selector: **None / Piece / Liquid**, styled like
the existing meal-type pills already used elsewhere on this screen.

- **None** (default, and the state for every existing food): no extra
  fields shown.
- **Piece**: shows exactly today's Label + Weight per piece (g) fields.
- **Liquid**: shows a single "Density (g per mL)" number field, with a
  hint line: `Water ≈ 1.0, milk ≈ 1.03, oil ≈ 0.92`.

Switching the selector clears whichever kind's fields aren't currently
shown (so leaving "Piece" for "Liquid" doesn't leave a stale piece label
sitting in the saved food). The selector's initial position is derived
from the food being edited: `Piece` if `hasPieceUnit`, `Liquid` if
`hasVolumeUnit`, `None` otherwise — this is screen-local state, not a new
persisted field; `Food`/`AddProductFormState` only ever need to know
which underlying fields are set, never which segment was last tapped.

`AddProductFormState` gains one field (`double? mlDensityGramsPerMl`,
mirroring `pieceLabel`/`pieceWeightGrams`); `AddProductNotifier` gains
`setMlDensityGramsPerMl` and calls `mlDensityValidationError` alongside
the existing `pieceSizeValidationError` check in `save()`; the
constructed `Food(...)` gains the field.

### Shared widget

`PieceAwareQuantityField` (`lib/features/food_logging/presentation/
widgets/piece_aware_quantity_field.dart`) is renamed to
`AlternateUnitQuantityField` (file renamed to
`alternate_unit_quantity_field.dart`) and its four piece-specific
parameters (`pieceLabel`, `pieceWeightGrams`) collapse into one:

```dart
const AlternateUnitQuantityField({
  required this.grams,
  required this.onChanged,
  this.altUnit,        // was pieceLabel + pieceWeightGrams
  this.initialUnitCount,
  this.label = 'Quantity',
  this.showCard = true,
  this.minGrams = 0,
  this.maxGrams = double.infinity,
});
```

Internally, every place the widget currently reads `widget.pieceLabel`/
`widget.pieceWeightGrams` reads `widget.altUnit!.label`/
`widget.altUnit!.weightPerUnitGrams` instead; `_hasPieceUnit` becomes
`_hasAltUnit => widget.altUnit != null`; the hardcoded step sizes (`+ 1`
for the alternate unit, matching a piece's whole-count stepping) become
`widget.altUnit!.step` (1 for piece, 50 for mL); the pluralized button
label / unit suffix (`'${pieceLabel}s'`) only pluralizes when
`widget.altUnit!.pluralize` is true. When `altUnit` is null, it still
renders exactly the plain `QuantityStepper` it always has — zero visual
change for any grams-only food, identical to how it already behaves for
a food with no piece unit today.

The grams-only degrade path, the min/max clamping (fixed after the piece
feature's final review), and the card/no-card layout are all unchanged —
only the piece-specific naming and the fixed "+1, always pluralize"
assumption generalize.

### The four call sites

`food_detail_screen.dart`, `add_ingredient_screen.dart`,
`edit_diary_entry_sheet.dart` each currently pass
`pieceLabel: food?.pieceLabel, pieceWeightGrams: food?.pieceWeightGrams`
to the widget. All three become one line: `altUnit: food?.alternateUnit`.
No other change to any of the three screens — the `LoggedQuantity`
they receive back (`grams`/`unitLabel`/`unitCount`) already flows through
unchanged into `logFood`/`addIngredient`/`updateQuantity` exactly as it
does for piece logging today.

### Display

`formatLoggedQuantity`
(`lib/features/food_logging/domain/quantity/logged_quantity_display.dart`)
gains one conditional: don't pluralize when the unit is mL.

```dart
final label = (unitCount == 1 || unitLabel == mlUnitLabel) ? unitLabel! : '${unitLabel}s';
```

This is the only change needed for both the diary meal list
(`meal_section_card.dart`) and the recipe ingredient lists
(`create_recipe_screen.dart`'s `_IngredientRow`, `recipe_detail_screen.dart`'s
ingredient expander) — both already call `formatLoggedQuantity` with
whatever `unitLabel`/`unitCount` the entry/ingredient carries, so "1 mL
(1g)" / "250 mL (258g)" fall out for free once the pluralization rule is
fixed. No other display code changes.

## Testing

- `Food.hasVolumeUnit` and `Food.alternateUnit` tests, mirroring the
  existing `hasPieceUnit` tests: returns the piece flavor when only piece
  fields are set, the volume flavor when only mL is set, null when
  neither is set. (A food with both set is untested as a case — per Non-
  goals, the UI never produces it; if it somehow occurred, `hasPieceUnit`
  taking priority is documented behavior, not a bug to guard against.)
- `mlDensityValidationError` tests: null is valid, a positive value is
  valid, zero and negative are both errors.
- `formatLoggedQuantity` tests: an mL count of 1 doesn't pluralize
  ("1 mL (1g)"), an mL count other than 1 still doesn't pluralize
  ("250 mL (258g)", not "250 mLs (258g)"), existing piece-label
  pluralization tests are unaffected.
- No new widget/golden tests, matching the precedent already set (and
  re-confirmed as an accepted gap) by the piece-logging feature.

## Design artifact sync

`ManualEntry.dc.html` needs the "Piece size" section replaced with the
broader "Alternate unit" section described above, with the new 3-way
selector and the Liquid density field — this must be updated and
explicitly confirmed before the Add/Edit Product screen task is
implemented, per `.claude/CLAUDE.md`. No other mockup needs a structural change: `FoodDetail.dc.html`,
`AddIngredient.dc.html`, and `Diary.dc.html`'s grams/alt-unit toggle and
formatted-quantity markup are already generic — the layout doesn't
special-case "piece," it just renders whatever label/count its sample
data hands it, so the same markup would show "mL" correctly if a mock
food used it. One latent inaccuracy, not worth fixing here: each
mockup's own JS pluralizes any count-other-than-1 unconditionally
(`count === 1 ? label : label + 's'`), matching the pre-mL
`formatLoggedQuantity` behavior — since none of these mockups' sample
data actually demonstrates an mL-labeled item, this never renders
visibly wrong, and fixing it isn't needed for this task's job (showing
the new Alternate Unit section on the Add/Edit Product screen).
