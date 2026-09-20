enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive;

  /// Stable string key used for persistence. Do not derive this from [name]
  /// so renaming the enum value can never silently corrupt stored data.
  String get storageKey => switch (this) {
    ActivityLevel.sedentary => 'sedentary',
    ActivityLevel.light => 'light',
    ActivityLevel.moderate => 'moderate',
    ActivityLevel.active => 'active',
    ActivityLevel.veryActive => 'very_active',
  };

  static ActivityLevel fromStorageKey(String key) => switch (key) {
    'sedentary' => ActivityLevel.sedentary,
    'light' => ActivityLevel.light,
    'moderate' => ActivityLevel.moderate,
    'active' => ActivityLevel.active,
    'very_active' => ActivityLevel.veryActive,
    _ => throw ArgumentError('Unknown ActivityLevel storage key: $key'),
  };

  double get multiplier => switch (this) {
    ActivityLevel.sedentary => 1.2,
    ActivityLevel.light => 1.375,
    ActivityLevel.moderate => 1.55,
    ActivityLevel.active => 1.725,
    ActivityLevel.veryActive => 1.9,
  };

  String get label => switch (this) {
    ActivityLevel.sedentary => 'Sedentary',
    ActivityLevel.light => 'Light',
    ActivityLevel.moderate => 'Moderate',
    ActivityLevel.active => 'Active',
    ActivityLevel.veryActive => 'Very active',
  };

  String get description => switch (this) {
    ActivityLevel.sedentary => 'Desk job, little to no exercise',
    ActivityLevel.light => 'Light exercise 1-3 days/week',
    ActivityLevel.moderate => 'Moderate exercise 3-5 days/week',
    ActivityLevel.active => 'Heavy exercise 6-7 days/week',
    ActivityLevel.veryActive => 'Physical job + heavy training',
  };
}
