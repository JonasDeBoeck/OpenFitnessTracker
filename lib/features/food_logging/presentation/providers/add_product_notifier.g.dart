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
    required ({String? prefillBarcode, MealType? presetMealType})
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
    r'd5561138e6a4b7788d70b63efe3d95a564499bcd';

final class AddProductNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AddProductNotifier,
          AddProductFormState,
          AddProductFormState,
          AddProductFormState,
          ({String? prefillBarcode, MealType? presetMealType})
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
  }) => AddProductNotifierProvider._(
    argument: (prefillBarcode: prefillBarcode, presetMealType: presetMealType),
    from: this,
  );

  @override
  String toString() => r'addProductProvider';
}

abstract class _$AddProductNotifier extends $Notifier<AddProductFormState> {
  late final _$args =
      ref.$arg as ({String? prefillBarcode, MealType? presetMealType});
  String? get prefillBarcode => _$args.prefillBarcode;
  MealType? get presetMealType => _$args.presetMealType;

  AddProductFormState build({String? prefillBarcode, MealType? presetMealType});
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
      ),
    );
  }
}
