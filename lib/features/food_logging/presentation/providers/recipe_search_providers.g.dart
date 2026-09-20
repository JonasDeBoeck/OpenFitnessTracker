// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeSearchResults)
final recipeSearchResultsProvider = RecipeSearchResultsFamily._();

final class RecipeSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          FutureOr<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $FutureProvider<List<Recipe>> {
  RecipeSearchResultsProvider._({
    required RecipeSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipeSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeSearchResultsHash();

  @override
  String toString() {
    return r'recipeSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipe>> create(Ref ref) {
    final argument = this.argument as String;
    return recipeSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeSearchResultsHash() =>
    r'739ad0b3126738075f3484eaea165df5c4017ef7';

final class RecipeSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Recipe>>, String> {
  RecipeSearchResultsFamily._()
    : super(
        retry: null,
        name: r'recipeSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipeSearchResultsProvider call(String query) =>
      RecipeSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'recipeSearchResultsProvider';
}

@ProviderFor(recentRecipes)
final recentRecipesProvider = RecentRecipesProvider._();

final class RecentRecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          FutureOr<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $FutureProvider<List<Recipe>> {
  RecentRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentRecipesHash();

  @$internal
  @override
  $FutureProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipe>> create(Ref ref) {
    return recentRecipes(ref);
  }
}

String _$recentRecipesHash() => r'b3fe5fe3ca85363f00357f542e868b47aaf7a88e';

@ProviderFor(favoriteRecipes)
final favoriteRecipesProvider = FavoriteRecipesProvider._();

final class FavoriteRecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          FutureOr<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $FutureProvider<List<Recipe>> {
  FavoriteRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteRecipesHash();

  @$internal
  @override
  $FutureProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipe>> create(Ref ref) {
    return favoriteRecipes(ref);
  }
}

String _$favoriteRecipesHash() => r'3d938e5d0dd9c614fd18f19a1218f073e028b613';
