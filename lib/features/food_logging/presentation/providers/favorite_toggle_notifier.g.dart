// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_toggle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FavoriteToggleNotifier)
final favoriteToggleProvider = FavoriteToggleNotifierProvider._();

final class FavoriteToggleNotifierProvider
    extends $AsyncNotifierProvider<FavoriteToggleNotifier, void> {
  FavoriteToggleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteToggleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteToggleNotifierHash();

  @$internal
  @override
  FavoriteToggleNotifier create() => FavoriteToggleNotifier();
}

String _$favoriteToggleNotifierHash() =>
    r'6ef723f7520a552b9c2c22d0bf9ed1870f41e91c';

abstract class _$FavoriteToggleNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
