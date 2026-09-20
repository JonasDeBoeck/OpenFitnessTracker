// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_foods_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every food in the catalog, grouped by the first letter of its name.
/// Since [FoodRepository.getAllSortedByName] already returns names sorted,
/// the groups come out alphabetical for free — this is a pure derived
/// transform, so it lives here rather than in the repository or a widget.

@ProviderFor(foodsGroupedAlphabetically)
final foodsGroupedAlphabeticallyProvider =
    FoodsGroupedAlphabeticallyProvider._();

/// Every food in the catalog, grouped by the first letter of its name.
/// Since [FoodRepository.getAllSortedByName] already returns names sorted,
/// the groups come out alphabetical for free — this is a pure derived
/// transform, so it lives here rather than in the repository or a widget.

final class FoodsGroupedAlphabeticallyProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<Food>>>,
          Map<String, List<Food>>,
          FutureOr<Map<String, List<Food>>>
        >
    with
        $FutureModifier<Map<String, List<Food>>>,
        $FutureProvider<Map<String, List<Food>>> {
  /// Every food in the catalog, grouped by the first letter of its name.
  /// Since [FoodRepository.getAllSortedByName] already returns names sorted,
  /// the groups come out alphabetical for free — this is a pure derived
  /// transform, so it lives here rather than in the repository or a widget.
  FoodsGroupedAlphabeticallyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodsGroupedAlphabeticallyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodsGroupedAlphabeticallyHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<Food>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<Food>>> create(Ref ref) {
    return foodsGroupedAlphabetically(ref);
  }
}

String _$foodsGroupedAlphabeticallyHash() =>
    r'54b7a1dd75013a4d654977cbf7052f337ed35911';
