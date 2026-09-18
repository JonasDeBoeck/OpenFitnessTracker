enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks;

  String get label => switch (this) {
    MealType.breakfast => 'Breakfast',
    MealType.lunch => 'Lunch',
    MealType.dinner => 'Dinner',
    MealType.snacks => 'Snacks',
  };

  String get storageKey => switch (this) {
    MealType.breakfast => 'breakfast',
    MealType.lunch => 'lunch',
    MealType.dinner => 'dinner',
    MealType.snacks => 'snacks',
  };

  static MealType fromStorageKey(String key) => switch (key) {
    'breakfast' => MealType.breakfast,
    'lunch' => MealType.lunch,
    'dinner' => MealType.dinner,
    'snacks' => MealType.snacks,
    _ => throw ArgumentError('Unknown MealType storage key: $key'),
  };
}
