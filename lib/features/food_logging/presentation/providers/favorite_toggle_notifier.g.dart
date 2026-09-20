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
        isAutoDispose: true,
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
    r'faf54839c7e1d0adfd8dbb2425d42739dffe9827';

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
