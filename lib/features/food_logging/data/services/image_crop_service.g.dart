// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_crop_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageCropService)
final imageCropServiceProvider = ImageCropServiceProvider._();

final class ImageCropServiceProvider
    extends
        $FunctionalProvider<
          ImageCropService,
          ImageCropService,
          ImageCropService
        >
    with $Provider<ImageCropService> {
  ImageCropServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageCropServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageCropServiceHash();

  @$internal
  @override
  $ProviderElement<ImageCropService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageCropService create(Ref ref) {
    return imageCropService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageCropService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageCropService>(value),
    );
  }
}

String _$imageCropServiceHash() => r'abdd955ff9d7d073185590034b6cecd7da2cf423';
