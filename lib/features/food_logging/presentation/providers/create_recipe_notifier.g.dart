// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_recipe_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateRecipeNotifier)
final createRecipeProvider = CreateRecipeNotifierFamily._();

final class CreateRecipeNotifierProvider
    extends $NotifierProvider<CreateRecipeNotifier, CreateRecipeFormState> {
  CreateRecipeNotifierProvider._({
    required CreateRecipeNotifierFamily super.from,
    required Recipe? super.argument,
  }) : super(
         retry: null,
         name: r'createRecipeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createRecipeNotifierHash();

  @override
  String toString() {
    return r'createRecipeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CreateRecipeNotifier create() => CreateRecipeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateRecipeFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateRecipeFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CreateRecipeNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createRecipeNotifierHash() =>
    r'3d775380558c286a437425d7d08bd7c5fbf64dfd';

final class CreateRecipeNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CreateRecipeNotifier,
          CreateRecipeFormState,
          CreateRecipeFormState,
          CreateRecipeFormState,
          Recipe?
        > {
  CreateRecipeNotifierFamily._()
    : super(
        retry: null,
        name: r'createRecipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateRecipeNotifierProvider call({Recipe? editingRecipe}) =>
      CreateRecipeNotifierProvider._(argument: editingRecipe, from: this);

  @override
  String toString() => r'createRecipeProvider';
}

abstract class _$CreateRecipeNotifier extends $Notifier<CreateRecipeFormState> {
  late final _$args = ref.$arg as Recipe?;
  Recipe? get editingRecipe => _$args;

  CreateRecipeFormState build({Recipe? editingRecipe});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CreateRecipeFormState, CreateRecipeFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateRecipeFormState, CreateRecipeFormState>,
              CreateRecipeFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(editingRecipe: _$args));
  }
}
