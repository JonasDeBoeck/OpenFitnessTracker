// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(waterEntriesForDate)
final waterEntriesForDateProvider = WaterEntriesForDateFamily._();

final class WaterEntriesForDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterEntry>>,
          List<WaterEntry>,
          FutureOr<List<WaterEntry>>
        >
    with $FutureModifier<List<WaterEntry>>, $FutureProvider<List<WaterEntry>> {
  WaterEntriesForDateProvider._({
    required WaterEntriesForDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'waterEntriesForDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$waterEntriesForDateHash();

  @override
  String toString() {
    return r'waterEntriesForDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WaterEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WaterEntry>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return waterEntriesForDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WaterEntriesForDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$waterEntriesForDateHash() =>
    r'64cd2ad2cf4a00883f200405be5c62e9a8869ee4';

final class WaterEntriesForDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WaterEntry>>, DateTime> {
  WaterEntriesForDateFamily._()
    : super(
        retry: null,
        name: r'waterEntriesForDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WaterEntriesForDateProvider call(DateTime date) =>
      WaterEntriesForDateProvider._(argument: date, from: this);

  @override
  String toString() => r'waterEntriesForDateProvider';
}

/// Derives a single day's water view-model from the persisted
/// [UserProfile]'s target plus that day's logged entries. [date] is
/// normalized to day-only before being used as a cache key. Returns null
/// while there is no profile yet.

@ProviderFor(waterDay)
final waterDayProvider = WaterDayFamily._();

/// Derives a single day's water view-model from the persisted
/// [UserProfile]'s target plus that day's logged entries. [date] is
/// normalized to day-only before being used as a cache key. Returns null
/// while there is no profile yet.

final class WaterDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterDayView?>,
          WaterDayView?,
          FutureOr<WaterDayView?>
        >
    with $FutureModifier<WaterDayView?>, $FutureProvider<WaterDayView?> {
  /// Derives a single day's water view-model from the persisted
  /// [UserProfile]'s target plus that day's logged entries. [date] is
  /// normalized to day-only before being used as a cache key. Returns null
  /// while there is no profile yet.
  WaterDayProvider._({
    required WaterDayFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'waterDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$waterDayHash();

  @override
  String toString() {
    return r'waterDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WaterDayView?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WaterDayView?> create(Ref ref) {
    final argument = this.argument as DateTime;
    return waterDay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WaterDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$waterDayHash() => r'9d41c71225eb818a984b140ada69369cd4436319';

/// Derives a single day's water view-model from the persisted
/// [UserProfile]'s target plus that day's logged entries. [date] is
/// normalized to day-only before being used as a cache key. Returns null
/// while there is no profile yet.

final class WaterDayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WaterDayView?>, DateTime> {
  WaterDayFamily._()
    : super(
        retry: null,
        name: r'waterDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Derives a single day's water view-model from the persisted
  /// [UserProfile]'s target plus that day's logged entries. [date] is
  /// normalized to day-only before being used as a cache key. Returns null
  /// while there is no profile yet.

  WaterDayProvider call(DateTime date) =>
      WaterDayProvider._(argument: date, from: this);

  @override
  String toString() => r'waterDayProvider';
}

/// Logs and deletes water entries for a given date, invalidating
/// [waterEntriesForDateProvider] (and therefore [waterDayProvider], which
/// watches it) so the UI reflects the change. `keepAlive` because nothing
/// watches this provider's own state — an autoDispose notifier with no
/// listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.

@ProviderFor(WaterLogController)
final waterLogControllerProvider = WaterLogControllerProvider._();

/// Logs and deletes water entries for a given date, invalidating
/// [waterEntriesForDateProvider] (and therefore [waterDayProvider], which
/// watches it) so the UI reflects the change. `keepAlive` because nothing
/// watches this provider's own state — an autoDispose notifier with no
/// listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.
final class WaterLogControllerProvider
    extends $AsyncNotifierProvider<WaterLogController, void> {
  /// Logs and deletes water entries for a given date, invalidating
  /// [waterEntriesForDateProvider] (and therefore [waterDayProvider], which
  /// watches it) so the UI reflects the change. `keepAlive` because nothing
  /// watches this provider's own state — an autoDispose notifier with no
  /// listener can be torn down mid-`await` here, silently dropping the
  /// invalidation that follows.
  WaterLogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterLogControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterLogControllerHash();

  @$internal
  @override
  WaterLogController create() => WaterLogController();
}

String _$waterLogControllerHash() =>
    r'fc6391c855a21378755a3be68012c0844ffca2ce';

/// Logs and deletes water entries for a given date, invalidating
/// [waterEntriesForDateProvider] (and therefore [waterDayProvider], which
/// watches it) so the UI reflects the change. `keepAlive` because nothing
/// watches this provider's own state — an autoDispose notifier with no
/// listener can be torn down mid-`await` here, silently dropping the
/// invalidation that follows.

abstract class _$WaterLogController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
