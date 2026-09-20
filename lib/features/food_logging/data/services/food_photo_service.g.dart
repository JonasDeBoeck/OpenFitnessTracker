// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_photo_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(foodPhotoService)
final foodPhotoServiceProvider = FoodPhotoServiceProvider._();

final class FoodPhotoServiceProvider
    extends
        $FunctionalProvider<
          FoodPhotoService,
          FoodPhotoService,
          FoodPhotoService
        >
    with $Provider<FoodPhotoService> {
  FoodPhotoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodPhotoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodPhotoServiceHash();

  @$internal
  @override
  $ProviderElement<FoodPhotoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FoodPhotoService create(Ref ref) {
    return foodPhotoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodPhotoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodPhotoService>(value),
    );
  }
}

String _$foodPhotoServiceHash() => r'03599ea213c90a0615f48a183c7c14818081e430';
