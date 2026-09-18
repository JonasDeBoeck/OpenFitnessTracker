// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_recipes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every recipe in the catalog, grouped by the first letter of its name —
/// the recipe counterpart of [foodsGroupedAlphabeticallyProvider].

@ProviderFor(recipesGroupedAlphabetically)
final recipesGroupedAlphabeticallyProvider =
    RecipesGroupedAlphabeticallyProvider._();

/// Every recipe in the catalog, grouped by the first letter of its name —
/// the recipe counterpart of [foodsGroupedAlphabeticallyProvider].

final class RecipesGroupedAlphabeticallyProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<Recipe>>>,
          Map<String, List<Recipe>>,
          FutureOr<Map<String, List<Recipe>>>
        >
    with
        $FutureModifier<Map<String, List<Recipe>>>,
        $FutureProvider<Map<String, List<Recipe>>> {
  /// Every recipe in the catalog, grouped by the first letter of its name —
  /// the recipe counterpart of [foodsGroupedAlphabeticallyProvider].
  RecipesGroupedAlphabeticallyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipesGroupedAlphabeticallyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipesGroupedAlphabeticallyHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<Recipe>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<Recipe>>> create(Ref ref) {
    return recipesGroupedAlphabetically(ref);
  }
}

String _$recipesGroupedAlphabeticallyHash() =>
    r'22578f4d49752010834c880bd45bf1146a9f3981';
