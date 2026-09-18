// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_label_ocr_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nutritionLabelOcrService)
final nutritionLabelOcrServiceProvider = NutritionLabelOcrServiceProvider._();

final class NutritionLabelOcrServiceProvider
    extends
        $FunctionalProvider<
          NutritionLabelOcrService,
          NutritionLabelOcrService,
          NutritionLabelOcrService
        >
    with $Provider<NutritionLabelOcrService> {
  NutritionLabelOcrServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionLabelOcrServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionLabelOcrServiceHash();

  @$internal
  @override
  $ProviderElement<NutritionLabelOcrService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NutritionLabelOcrService create(Ref ref) {
    return nutritionLabelOcrService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutritionLabelOcrService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutritionLabelOcrService>(value),
    );
  }
}

String _$nutritionLabelOcrServiceHash() =>
    r'826e2a23d2c37b9a108ac9a65e1d0f9080999525';
