// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeById)
final recipeByIdProvider = RecipeByIdFamily._();

final class RecipeByIdProvider
    extends $FunctionalProvider<AsyncValue<Recipe?>, Recipe?, FutureOr<Recipe?>>
    with $FutureModifier<Recipe?>, $FutureProvider<Recipe?> {
  RecipeByIdProvider._({
    required RecipeByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recipeByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeByIdHash();

  @override
  String toString() {
    return r'recipeByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Recipe?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Recipe?> create(Ref ref) {
    final argument = this.argument as int;
    return recipeById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeByIdHash() => r'06d1848de81f562255989e5410fcde47d92e74ad';

final class RecipeByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Recipe?>, int> {
  RecipeByIdFamily._()
    : super(
        retry: null,
        name: r'recipeByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipeByIdProvider call(int recipeId) =>
      RecipeByIdProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeByIdProvider';
}
