enum Sex {
  male,
  female;

  /// Stable string key used for persistence. Do not derive this from [name]
  /// so renaming the enum value can never silently corrupt stored data.
  String get storageKey => switch (this) {
    Sex.male => 'male',
    Sex.female => 'female',
  };

  static Sex fromStorageKey(String key) => switch (key) {
    'male' => Sex.male,
    'female' => Sex.female,
    _ => throw ArgumentError('Unknown Sex storage key: $key'),
  };

  String get label => switch (this) {
    Sex.male => 'Male',
    Sex.female => 'Female',
  };
}
