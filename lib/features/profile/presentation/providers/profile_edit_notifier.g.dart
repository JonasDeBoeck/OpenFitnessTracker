// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileEditNotifier)
final profileEditProvider = ProfileEditNotifierProvider._();

final class ProfileEditNotifierProvider
    extends $AsyncNotifierProvider<ProfileEditNotifier, ProfileEditState> {
  ProfileEditNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditNotifierHash();

  @$internal
  @override
  ProfileEditNotifier create() => ProfileEditNotifier();
}

String _$profileEditNotifierHash() =>
    r'dabc9b7681fd2687f4a8d78c4baf8897ad7834ea';

abstract class _$ProfileEditNotifier extends $AsyncNotifier<ProfileEditState> {
  FutureOr<ProfileEditState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProfileEditState>, ProfileEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileEditState>, ProfileEditState>,
              AsyncValue<ProfileEditState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
