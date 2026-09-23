// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddProductNotifier)
final addProductProvider = AddProductNotifierFamily._();

final class AddProductNotifierProvider
    extends $NotifierProvider<AddProductNotifier, AddProductFormState> {
  AddProductNotifierProvider._({
    required AddProductNotifierFamily super.from,
    required ({
      String? prefillBarcode,
      MealType? presetMealType,
      Food? editingFood,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'addProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addProductNotifierHash();

  @override
  String toString() {
    return r'addProductProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  AddProductNotifier create() => AddProductNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddProductFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddProductFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddProductNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addProductNotifierHash() =>
    r'e9ec05f2265f348468f36d2206aea8910002923a';

final class AddProductNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AddProductNotifier,
          AddProductFormState,
          AddProductFormState,
          AddProductFormState,
          ({
            String? prefillBarcode,
            MealType? presetMealType,
            Food? editingFood,
          })
        > {
  AddProductNotifierFamily._()
    : super(
        retry: null,
        name: r'addProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddProductNotifierProvider call({
    String? prefillBarcode,
    MealType? presetMealType,
    Food? editingFood,
  }) => AddProductNotifierProvider._(
    argument: (
      prefillBarcode: prefillBarcode,
      presetMealType: presetMealType,
      editingFood: editingFood,
    ),
    from: this,
  );

  @override
  String toString() => r'addProductProvider';
}

abstract class _$AddProductNotifier extends $Notifier<AddProductFormState> {
  late final _$args =
      ref.$arg
          as ({
            String? prefillBarcode,
            MealType? presetMealType,
            Food? editingFood,
          });
  String? get prefillBarcode => _$args.prefillBarcode;
  MealType? get presetMealType => _$args.presetMealType;
  Food? get editingFood => _$args.editingFood;

  AddProductFormState build({
    String? prefillBarcode,
    MealType? presetMealType,
    Food? editingFood,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AddProductFormState, AddProductFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddProductFormState, AddProductFormState>,
              AddProductFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(
        prefillBarcode: _$args.prefillBarcode,
        presetMealType: _$args.presetMealType,
        editingFood: _$args.editingFood,
      ),
    );
  }
}
