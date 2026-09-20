// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_favorite_toggle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecipeFavoriteToggleNotifier)
final recipeFavoriteToggleProvider = RecipeFavoriteToggleNotifierProvider._();

final class RecipeFavoriteToggleNotifierProvider
    extends $AsyncNotifierProvider<RecipeFavoriteToggleNotifier, void> {
  RecipeFavoriteToggleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeFavoriteToggleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeFavoriteToggleNotifierHash();

  @$internal
  @override
  RecipeFavoriteToggleNotifier create() => RecipeFavoriteToggleNotifier();
}

String _$recipeFavoriteToggleNotifierHash() =>
    r'f3287577767252b5e0035b8fdc1fe28fc7bb8997';

abstract class _$RecipeFavoriteToggleNotifier extends $AsyncNotifier<void> {
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
