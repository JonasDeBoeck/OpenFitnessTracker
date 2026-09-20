/// Which lookback window the Trends screen charts are showing.
enum TrendsRange {
  sevenDays,
  thirtyDays,
  ninetyDays,
  all;

  String get label => switch (this) {
    TrendsRange.sevenDays => '7D',
    TrendsRange.thirtyDays => '30D',
    TrendsRange.ninetyDays => '90D',
    TrendsRange.all => 'All',
  };

  /// How far back from today this range looks, inclusive of today. Null for
  /// [all], which is bounded by the profile's creation date instead.
  Duration? get lookback => switch (this) {
    TrendsRange.sevenDays => const Duration(days: 6),
    TrendsRange.thirtyDays => const Duration(days: 29),
    TrendsRange.ninetyDays => const Duration(days: 89),
    TrendsRange.all => null,
  };
}
