// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single source of truth for "is onboarding complete" — used by both the
/// router redirect and the home screen.

@ProviderFor(currentProfile)
final currentProfileProvider = CurrentProfileProvider._();

/// Single source of truth for "is onboarding complete" — used by both the
/// router redirect and the home screen.

final class CurrentProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile?>,
          UserProfile?,
          FutureOr<UserProfile?>
        >
    with $FutureModifier<UserProfile?>, $FutureProvider<UserProfile?> {
  /// Single source of truth for "is onboarding complete" — used by both the
  /// router redirect and the home screen.
  CurrentProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileHash();

  @$internal
  @override
  $FutureProviderElement<UserProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile?> create(Ref ref) {
    return currentProfile(ref);
  }
}

String _$currentProfileHash() => r'6808bd3351a7b5285b13219272efb5e6affffcb2';

@ProviderFor(ProfileSaveNotifier)
final profileSaveProvider = ProfileSaveNotifierProvider._();

final class ProfileSaveNotifierProvider
    extends $AsyncNotifierProvider<ProfileSaveNotifier, void> {
  ProfileSaveNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileSaveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileSaveNotifierHash();

  @$internal
  @override
  ProfileSaveNotifier create() => ProfileSaveNotifier();
}

String _$profileSaveNotifierHash() =>
    r'd1dd77f2af90bd5de8fddb5e47b40d7f4850dc6d';

abstract class _$ProfileSaveNotifier extends $AsyncNotifier<void> {
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
