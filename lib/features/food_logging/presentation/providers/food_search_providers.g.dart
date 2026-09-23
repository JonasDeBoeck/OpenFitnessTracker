// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(foodSearchResults)
final foodSearchResultsProvider = FoodSearchResultsFamily._();

final class FoodSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          FutureOr<List<Food>>
        >
    with $FutureModifier<List<Food>>, $FutureProvider<List<Food>> {
  FoodSearchResultsProvider._({
    required FoodSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'foodSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$foodSearchResultsHash();

  @override
  String toString() {
    return r'foodSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Food>> create(Ref ref) {
    final argument = this.argument as String;
    return foodSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodSearchResultsHash() => r'0361407e5c7c9debfc2d5f2da2ac8f35a1cffce4';

final class FoodSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Food>>, String> {
  FoodSearchResultsFamily._()
    : super(
        retry: null,
        name: r'foodSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FoodSearchResultsProvider call(String query) =>
      FoodSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'foodSearchResultsProvider';
}

@ProviderFor(recentFoods)
final recentFoodsProvider = RecentFoodsProvider._();

final class RecentFoodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          FutureOr<List<Food>>
        >
    with $FutureModifier<List<Food>>, $FutureProvider<List<Food>> {
  RecentFoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentFoodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentFoodsHash();

  @$internal
  @override
  $FutureProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Food>> create(Ref ref) {
    return recentFoods(ref);
  }
}

String _$recentFoodsHash() => r'e7d4808f7692bd8a4e8465de1f90e8eb15e920fd';

/// Every food in the catalog, sorted alphabetically — the unfiltered state
/// of a search-filtered A–Z list (e.g. Add Ingredient), as opposed to
/// [foodsGroupedAlphabeticallyProvider]'s letter-sectioned Browse Foods view.

@ProviderFor(allFoodsSorted)
final allFoodsSortedProvider = AllFoodsSortedProvider._();

/// Every food in the catalog, sorted alphabetically — the unfiltered state
/// of a search-filtered A–Z list (e.g. Add Ingredient), as opposed to
/// [foodsGroupedAlphabeticallyProvider]'s letter-sectioned Browse Foods view.

final class AllFoodsSortedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          FutureOr<List<Food>>
        >
    with $FutureModifier<List<Food>>, $FutureProvider<List<Food>> {
  /// Every food in the catalog, sorted alphabetically — the unfiltered state
  /// of a search-filtered A–Z list (e.g. Add Ingredient), as opposed to
  /// [foodsGroupedAlphabeticallyProvider]'s letter-sectioned Browse Foods view.
  AllFoodsSortedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allFoodsSortedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allFoodsSortedHash();

  @$internal
  @override
  $FutureProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Food>> create(Ref ref) {
    return allFoodsSorted(ref);
  }
}

String _$allFoodsSortedHash() => r'8c07bcb6c13c5b429c161709c4c2bafe9a9d032f';

@ProviderFor(favoriteFoods)
final favoriteFoodsProvider = FavoriteFoodsProvider._();

final class FavoriteFoodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Food>>,
          List<Food>,
          FutureOr<List<Food>>
        >
    with $FutureModifier<List<Food>>, $FutureProvider<List<Food>> {
  FavoriteFoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteFoodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteFoodsHash();

  @$internal
  @override
  $FutureProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Food>> create(Ref ref) {
    return favoriteFoods(ref);
  }
}

String _$favoriteFoodsHash() => r'91099b4ebedac485b4c40ef94527a686f0574a58';

@ProviderFor(foodByBarcode)
final foodByBarcodeProvider = FoodByBarcodeFamily._();

final class FoodByBarcodeProvider
    extends $FunctionalProvider<AsyncValue<Food?>, Food?, FutureOr<Food?>>
    with $FutureModifier<Food?>, $FutureProvider<Food?> {
  FoodByBarcodeProvider._({
    required FoodByBarcodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'foodByBarcodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$foodByBarcodeHash();

  @override
  String toString() {
    return r'foodByBarcodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Food?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Food?> create(Ref ref) {
    final argument = this.argument as String;
    return foodByBarcode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodByBarcodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$foodByBarcodeHash() => r'468d221f033cf85dd7b3204da466a8dd86764ea0';

final class FoodByBarcodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Food?>, String> {
  FoodByBarcodeFamily._()
    : super(
        retry: null,
        name: r'foodByBarcodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FoodByBarcodeProvider call(String barcode) =>
      FoodByBarcodeProvider._(argument: barcode, from: this);

  @override
  String toString() => r'foodByBarcodeProvider';
}
