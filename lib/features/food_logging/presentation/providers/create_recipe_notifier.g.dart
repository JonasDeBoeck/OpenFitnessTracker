// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_recipe_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateRecipeNotifier)
final createRecipeProvider = CreateRecipeNotifierProvider._();

final class CreateRecipeNotifierProvider
    extends $NotifierProvider<CreateRecipeNotifier, CreateRecipeFormState> {
  CreateRecipeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createRecipeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createRecipeNotifierHash();

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
}

String _$createRecipeNotifierHash() =>
    r'80e3bad6ea292a501041cc68a1b17eb96e8b7b22';

abstract class _$CreateRecipeNotifier extends $Notifier<CreateRecipeFormState> {
  CreateRecipeFormState build();
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
    return element.handleCreate(ref, build);
  }
}
