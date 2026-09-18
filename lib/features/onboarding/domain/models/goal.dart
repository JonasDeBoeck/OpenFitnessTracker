enum Goal {
  cut,
  bulk,
  maintain;

  /// Stable string key used for persistence. Do not derive this from [name]
  /// so renaming the enum value can never silently corrupt stored data.
  String get storageKey => switch (this) {
    Goal.cut => 'cut',
    Goal.bulk => 'bulk',
    Goal.maintain => 'maintain',
  };

  static Goal fromStorageKey(String key) => switch (key) {
    'cut' => Goal.cut,
    'bulk' => Goal.bulk,
    'maintain' => Goal.maintain,
    _ => throw ArgumentError('Unknown Goal storage key: $key'),
  };

  String get label => switch (this) {
    Goal.cut => 'Cut',
    Goal.bulk => 'Bulk',
    Goal.maintain => 'Maintain',
  };

  String get description => switch (this) {
    Goal.cut => 'Lose fat, ~1 lb/week',
    Goal.bulk => 'Gain muscle, ~0.5 lb/week',
    Goal.maintain => 'Maintain weight / recomposition',
  };
}
