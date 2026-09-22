# OpenFitnessTracker

## Commands
- `flutter pub get` — install dependencies
- `dart run build_runner build --delete-conflicting-outputs` — generate code
- `flutter analyze` — run linter
- `flutter test` — run tests

## Architecture
Feature-first folder structure. Each feature lives in lib/features/<name>/.
Navigation: GoRouter with named routes defined in lib/core/router/.
Models: Freezed + JsonSerializable. Run build_runner after any model change.

## Conventions
- Use ref.invalidate() not ref.refresh()
- No business logic in widgets — all logic goes in notifiers or repositories
- Widget files contain only one public widget per file
- Barrel exports via feature.dart in each feature root
- Prefix private widgets with an underscore

## What NOT to do
- Do not add new packages without asking first
- Do not modify *.g.dart or *.freezed.dart files directly — regenerate with build_runner
- Do not put API calls directly in notifiers — always go through the repository layer

## Design
The app's design lives in a Claude "Design" canvas Artifact (https://claude.ai/artifact/GoiswZcxUzWMAKqGGEF214), with one mockup file per screen under `project/*.dc.html`.
- After making a UI change, check the affected screen's implementation against its mockup in the Design artifact (colors, spacing, radii, font sizes/weights, copy, layout) before considering the change done.
- If a feature or screen has no mockup in the Design artifact yet, stop and ask the user to plan and verify a design there first — don't invent new UI from scratch without one.