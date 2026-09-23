# Piece-based food logging — design

## Summary

Let a food optionally define an average weight per piece (e.g. "1 carrot ≈
60g") with a custom unit label (e.g. "carrot", "slice", "clove"). Foods that
define this get a grams/piece toggle wherever an amount is entered — logging
to the diary and adding as a recipe ingredient — instead of always entering
grams. Nutrition math is completely unaffected: piece count is converted to
grams once, at save time, using the existing per-100g scaling. Foods that
don't define a piece size behave exactly as today.

## Goals

- Let the user log foods that are naturally counted ("1 carrot", "2 eggs")
  without mentally estimating grams.
- Remember what was actually logged ("2 carrots") for diary and recipe
  ingredient display, not just the resulting grams.
- Reuse the same piece unit for both diary logging and recipe ingredients.
- Zero behavior change for any food that doesn't opt in.

## Non-goals

- No per-package weight entry (e.g. "this bag has 6 carrots, weighs 900g" →
  auto-divide). Rejected during design — the user chose to keep only a
  direct "weight per piece" field.
- No multiple named units per food (e.g. "slice" *and* "cup" on the same
  food). One optional piece unit per food, matching how `Recipe.servings` is
  also a single number today.
- No OpenFoodFacts/external nutrition source — this app has no such
  integration (confirmed: no `OpenFoodFacts`/`ProductService` code exists).
- No retroactive recompute of past entries if a food's piece weight is later
  edited — matches the existing snapshot pattern (see below).

## Data model changes

### `Food` (`lib/features/food_logging/domain/models/food.dart`)

Two new optional fields, both-or-neither:

```dart
String? pieceLabel,        // e.g. "carrot", "slice", "clove"
double? pieceWeightGrams,  // e.g. 60.0
```

`null`/`null` (the default) means "grams only", identical to every food
today. A helper getter `bool get hasPieceUnit => pieceLabel != null &&
pieceWeightGrams != null;` centralizes the both-or-neither check so callers
don't duplicate the null-pair test.

### `RecipeIngredient` (`lib/features/food_logging/domain/models/recipe.dart`)

Two new optional fields, snapshotted at add-time exactly like
`caloriesPer100g` etc. already are:

```dart
String? unitLabel,  // the food's pieceLabel at the moment it was added, or null
double? unitCount,  // how many pieces were added, or null
```

`grams` remains the required, authoritative quantity — `unitLabel`/
`unitCount` are display-only. If a food's `pieceLabel`/`pieceWeightGrams`
change later, existing recipe ingredients keep showing what was actually
added, same as they already keep the old `caloriesPer100g`.

### `DiaryEntry` (`lib/features/food_logging/domain/models/diary_entry.dart`)

Same pattern, on the diary side:

```dart
String? loggedUnitLabel,
double? loggedUnitCount,
```

`quantityGrams` stays authoritative for nutrition; these two are display-only
and only ever set when the entry was a `Food` logged in piece mode (never
set for recipe entries, since recipes don't get a piece unit).
`DiaryEntry.snapshotFrom` gains two optional parameters (`unitLabel`,
`unitCount`) that just get assigned straight onto the returned entry —
no new computation happens there, the caller has already resolved
`quantityGrams` before calling it, same as today.

### Database (drift)

`schemaVersion` bumps from 5 to 6. Three tables each gain two nullable
columns (nullable additions never need backfill, following the pattern
already used for `from < 4`/`from < 5` in `app_database.dart`):

```dart
// foods_table.dart
TextColumn get pieceLabel => text().nullable()();
RealColumn get pieceWeightGrams => real().nullable()();

// recipe_ingredients_table.dart
TextColumn get unitLabel => text().nullable()();
RealColumn get unitCount => real().nullable()();

// diary_entries_table.dart
TextColumn get loggedUnitLabel => text().nullable()();
RealColumn get loggedUnitCount => real().nullable()();
```

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

`FoodRepository`, `RecipeRepository`, and `DiaryRepository`'s
`_toCompanion`/`_fromRow` (or equivalent) methods each need the two new
fields added to their existing field-by-field mapping — no structural change
to those methods.

## UI changes

### Add/Edit Product screen (defining a food)

New optional "Piece size" section (placed near the other per-100g nutrition
fields): a text field for the label and a number field for weight in grams.
Validation: if either is filled, the other becomes required (inline error,
matching this screen's existing `_NumberField`/`_LabeledNumberField`
validation style); if both are empty, the food is saved as grams-only, same
as today.

### Shared widget: grams/piece amount control

A new widget, e.g. `PieceAwareQuantityField`, generalizes the toggle pattern
that already exists privately in `recipe_detail_screen.dart` as
`_AmountUnit`/`_pickUnit`/`_incAmount`/`_decAmount`/`_effectiveGrams`: a
segmented grams/piece toggle, a text field showing the current amount, +/−
step buttons (step = 25g in grams mode, 1 in piece mode, mirroring the
existing grams/0.5-serving step sizes), and a conversion function
(`count * pieceWeightGrams`). Unlike the recipe screen's version, this
widget is extracted and reusable — it doesn't know about `Recipe` or
`Food` specifically, just an optional `(String label, double weightPerUnit)`
pair describing the alternate unit, plus the resulting grams callback. It
only renders the toggle at all when that pair is non-null; otherwise it
degrades to the existing plain `QuantityStepper` behavior.

`QuantityStepper` itself stays as the plain grams-only widget it is today
(still used as-is for any future grams-only case); the new widget sits
alongside it rather than replacing it, since not every caller needs
piece-awareness.

### Food Detail screen (logging a food to the diary)

Where `QuantityStepper` is used today (`food_detail_screen.dart`), swap to
`PieceAwareQuantityField`, passing the food's `pieceLabel`/`pieceWeightGrams`
when `food.hasPieceUnit`. On save, `DiaryEntry.snapshotFrom` is called with
the resolved grams as always, plus `unitLabel`/`unitCount` set only when the
piece toggle was the active mode at save time.

### Add Ingredient screen (adding a food to a recipe)

Same swap in `add_ingredient_screen.dart`. On save, the constructed
`RecipeIngredient` gets `unitLabel`/`unitCount` set the same way, `grams`
computed the same way.

### Edit Diary Entry sheet (editing an already-logged entry)

`edit_diary_entry_sheet.dart` is a third, previously-unlisted caller of
`QuantityStepper` — it opens when tapping an already-logged meal row to
adjust its quantity. For consistency (an entry logged as "2 carrots" should
still be editable as "2 carrots", not silently forced into grams-only), it
gets the same `PieceAwareQuantityField` swap, seeded from
`entry.loggedUnitLabel`/`entry.loggedUnitCount` when present. This requires
`DiaryEntryController.updateQuantity` and `DiaryRepository.updateEntry` to
accept/persist the (possibly now-changed) `unitLabel`/`unitCount` alongside
`newGrams`, instead of only `newGrams` as today.

### Display

- Diary/meal list rows: when `loggedUnitCount != null`, show
  `"${count} ${label}${count == 1 ? '' : 's'} (${grams}g)"` (e.g.
  "2 carrots (120g)"); otherwise show `"${grams}g"` as today.
- Recipe ingredient list rows: identical pattern using `unitCount`/
  `unitLabel`/`grams`.
- A small pure formatting function, e.g.
  `lib/features/food_logging/domain/quantity/logged_quantity_display.dart`
  → `formatLoggedQuantity({required double grams, String? unitLabel, double?
  unitCount})`, is shared by both call sites and unit-tested — following the
  precedent set by `label_suggestions.dart`'s extraction of pure, testable
  display/filter logic out of widgets. Plural handling ("1 carrot" vs "2
  carrots") is naive (`+'s'`) since that already matches this app's existing
  english-only, no-i18n scope.

### Untouched

- The recipe-level grams/servings toggle in `recipe_detail_screen.dart`
  (logging a *whole recipe* by servings) is a separate mechanic tied to
  `Recipe.servings`/`gramsPerServing` and is not touched by this feature.
- Any food without both `pieceLabel` and `pieceWeightGrams` set behaves
  identically to today everywhere.

## Testing

- Unit tests for `formatLoggedQuantity` covering: no unit (grams only),
  singular ("1 carrot (60g)"), plural ("2 carrots (120g)").
- Unit tests for the grams↔piece conversion helper used by
  `PieceAwareQuantityField` (piece count × weight = grams, and the reverse
  for initializing the field when switching modes).
- Existing golden tests are unaffected (no default-visible UI changes for
  foods without a piece unit); if the Add/Edit Product screen's layout
  shifts enough to affect any existing golden, regenerate it.
- `flutter analyze` / `flutter test` clean, per this project's standard bar.

## Design artifact sync

The Design canvas artifact has no mockups yet for: the Add/Edit Product
screen's new "Piece size" section, the grams/piece toggle on Food Detail and
Add Ingredient screens, and the new diary/recipe-ingredient display strings.
Per `.claude/CLAUDE.md`, these mockups must be created/updated in the Design
artifact and confirmed with the user *before* implementing the corresponding
UI — this happens during implementation, screen by screen, not as part of
this spec.
