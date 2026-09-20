// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trends_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which range the Trends screen is currently showing. Defaults to 7 days.

@ProviderFor(SelectedTrendsRange)
final selectedTrendsRangeProvider = SelectedTrendsRangeProvider._();

/// Which range the Trends screen is currently showing. Defaults to 7 days.
final class SelectedTrendsRangeProvider
    extends $NotifierProvider<SelectedTrendsRange, TrendsRange> {
  /// Which range the Trends screen is currently showing. Defaults to 7 days.
  SelectedTrendsRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTrendsRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTrendsRangeHash();

  @$internal
  @override
  SelectedTrendsRange create() => SelectedTrendsRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrendsRange value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrendsRange>(value),
    );
  }
}

String _$selectedTrendsRangeHash() =>
    r'a19e4a78fab36dda3dfc07dd0c844a0dbb496049';

/// Which range the Trends screen is currently showing. Defaults to 7 days.

abstract class _$SelectedTrendsRange extends $Notifier<TrendsRange> {
  TrendsRange build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TrendsRange, TrendsRange>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrendsRange, TrendsRange>,
              TrendsRange,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Derives the Trends view-model for [range] from the persisted
/// [UserProfile]'s targets plus the diary entries logged within it. Returns
/// null while there is no profile yet.

@ProviderFor(trends)
final trendsProvider = TrendsFamily._();

/// Derives the Trends view-model for [range] from the persisted
/// [UserProfile]'s targets plus the diary entries logged within it. Returns
/// null while there is no profile yet.

final class TrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<TrendsView?>,
          TrendsView?,
          FutureOr<TrendsView?>
        >
    with $FutureModifier<TrendsView?>, $FutureProvider<TrendsView?> {
  /// Derives the Trends view-model for [range] from the persisted
  /// [UserProfile]'s targets plus the diary entries logged within it. Returns
  /// null while there is no profile yet.
  TrendsProvider._({
    required TrendsFamily super.from,
    required TrendsRange super.argument,
  }) : super(
         retry: null,
         name: r'trendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trendsHash();

  @override
  String toString() {
    return r'trendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TrendsView?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TrendsView?> create(Ref ref) {
    final argument = this.argument as TrendsRange;
    return trends(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TrendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trendsHash() => r'b69fe198674dd092d0fd4545ed3439cc2fda6135';

/// Derives the Trends view-model for [range] from the persisted
/// [UserProfile]'s targets plus the diary entries logged within it. Returns
/// null while there is no profile yet.

final class TrendsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TrendsView?>, TrendsRange> {
  TrendsFamily._()
    : super(
        retry: null,
        name: r'trendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Derives the Trends view-model for [range] from the persisted
  /// [UserProfile]'s targets plus the diary entries logged within it. Returns
  /// null while there is no profile yet.

  TrendsProvider call(TrendsRange range) =>
      TrendsProvider._(argument: range, from: this);

  @override
  String toString() => r'trendsProvider';
}
