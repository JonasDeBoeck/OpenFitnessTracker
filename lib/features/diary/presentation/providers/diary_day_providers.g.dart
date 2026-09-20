// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_day_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Derives a single day's diary view-model from the persisted [UserProfile]
/// plus that day's diary entries. [date] is normalized to day-only before
/// being used as a cache key, so callers don't need to pre-normalize it.
/// Returns null while there is no profile yet.

@ProviderFor(diaryDay)
final diaryDayProvider = DiaryDayFamily._();

/// Derives a single day's diary view-model from the persisted [UserProfile]
/// plus that day's diary entries. [date] is normalized to day-only before
/// being used as a cache key, so callers don't need to pre-normalize it.
/// Returns null while there is no profile yet.

final class DiaryDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<DiaryDayView?>,
          DiaryDayView?,
          FutureOr<DiaryDayView?>
        >
    with $FutureModifier<DiaryDayView?>, $FutureProvider<DiaryDayView?> {
  /// Derives a single day's diary view-model from the persisted [UserProfile]
  /// plus that day's diary entries. [date] is normalized to day-only before
  /// being used as a cache key, so callers don't need to pre-normalize it.
  /// Returns null while there is no profile yet.
  DiaryDayProvider._({
    required DiaryDayFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'diaryDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryDayHash();

  @override
  String toString() {
    return r'diaryDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DiaryDayView?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DiaryDayView?> create(Ref ref) {
    final argument = this.argument as DateTime;
    return diaryDay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiaryDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryDayHash() => r'8e94bab944405469cda6f1fb9c562c1cc4f1d114';

/// Derives a single day's diary view-model from the persisted [UserProfile]
/// plus that day's diary entries. [date] is normalized to day-only before
/// being used as a cache key, so callers don't need to pre-normalize it.
/// Returns null while there is no profile yet.

final class DiaryDayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DiaryDayView?>, DateTime> {
  DiaryDayFamily._()
    : super(
        retry: null,
        name: r'diaryDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Derives a single day's diary view-model from the persisted [UserProfile]
  /// plus that day's diary entries. [date] is normalized to day-only before
  /// being used as a cache key, so callers don't need to pre-normalize it.
  /// Returns null while there is no profile yet.

  DiaryDayProvider call(DateTime date) =>
      DiaryDayProvider._(argument: date, from: this);

  @override
  String toString() => r'diaryDayProvider';
}

/// The distinct dates within [range] that have at least one logged entry —
/// backs the "has entries" dots on the diary calendar.

@ProviderFor(loggedDatesInRange)
final loggedDatesInRangeProvider = LoggedDatesInRangeFamily._();

/// The distinct dates within [range] that have at least one logged entry —
/// backs the "has entries" dots on the diary calendar.

final class LoggedDatesInRangeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<DateTime>>,
          Set<DateTime>,
          FutureOr<Set<DateTime>>
        >
    with $FutureModifier<Set<DateTime>>, $FutureProvider<Set<DateTime>> {
  /// The distinct dates within [range] that have at least one logged entry —
  /// backs the "has entries" dots on the diary calendar.
  LoggedDatesInRangeProvider._({
    required LoggedDatesInRangeFamily super.from,
    required DateTimeRange<DateTime> super.argument,
  }) : super(
         retry: null,
         name: r'loggedDatesInRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loggedDatesInRangeHash();

  @override
  String toString() {
    return r'loggedDatesInRangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Set<DateTime>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<DateTime>> create(Ref ref) {
    final argument = this.argument as DateTimeRange<DateTime>;
    return loggedDatesInRange(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoggedDatesInRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loggedDatesInRangeHash() =>
    r'9946f2c2775010a256a3a5b6e107304a5b845317';

/// The distinct dates within [range] that have at least one logged entry —
/// backs the "has entries" dots on the diary calendar.

final class LoggedDatesInRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Set<DateTime>>,
          DateTimeRange<DateTime>
        > {
  LoggedDatesInRangeFamily._()
    : super(
        retry: null,
        name: r'loggedDatesInRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The distinct dates within [range] that have at least one logged entry —
  /// backs the "has entries" dots on the diary calendar.

  LoggedDatesInRangeProvider call(DateTimeRange<DateTime> range) =>
      LoggedDatesInRangeProvider._(argument: range, from: this);

  @override
  String toString() => r'loggedDatesInRangeProvider';
}
