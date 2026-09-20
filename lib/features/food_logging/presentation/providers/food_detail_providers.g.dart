// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(foodById)
final foodByIdProvider = FoodByIdFamily._();

final class FoodByIdProvider
    extends $FunctionalProvider<AsyncValue<Food?>, Food?, FutureOr<Food?>>
    with $FutureModifier<Food?>, $FutureProvider<Food?> {
  FoodByIdProvider._({
    required FoodByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'foodByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$foodByIdHash();

  @override
  String toString() {
    return r'foodByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Food?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Food?> create(Ref ref) {
    final argument = this.argument as int;
    return foodById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodByIdHash() => r'96b76c54f9ba649280d679adac93a94b1cff68be';

final class FoodByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Food?>, int> {
  FoodByIdFamily._()
    : super(
        retry: null,
        name: r'foodByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FoodByIdProvider call(int foodId) =>
      FoodByIdProvider._(argument: foodId, from: this);

  @override
  String toString() => r'foodByIdProvider';
}

/// The quantity-in-grams the user is currently dialing in on the food
/// detail screen. Pure ephemeral UI state — nothing to persist here, the
/// quantity only matters once it's snapshotted into a [DiaryEntry].

@ProviderFor(FoodQuantityNotifier)
final foodQuantityProvider = FoodQuantityNotifierProvider._();

/// The quantity-in-grams the user is currently dialing in on the food
/// detail screen. Pure ephemeral UI state — nothing to persist here, the
/// quantity only matters once it's snapshotted into a [DiaryEntry].
final class FoodQuantityNotifierProvider
    extends $NotifierProvider<FoodQuantityNotifier, double> {
  /// The quantity-in-grams the user is currently dialing in on the food
  /// detail screen. Pure ephemeral UI state — nothing to persist here, the
  /// quantity only matters once it's snapshotted into a [DiaryEntry].
  FoodQuantityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodQuantityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodQuantityNotifierHash();

  @$internal
  @override
  FoodQuantityNotifier create() => FoodQuantityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$foodQuantityNotifierHash() =>
    r'e7a0516178e0da88d74c628b805c8b54571a8027';

/// The quantity-in-grams the user is currently dialing in on the food
/// detail screen. Pure ephemeral UI state — nothing to persist here, the
/// quantity only matters once it's snapshotted into a [DiaryEntry].

abstract class _$FoodQuantityNotifier extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
