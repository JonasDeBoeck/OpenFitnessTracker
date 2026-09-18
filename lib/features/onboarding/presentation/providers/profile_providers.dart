import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/onboarding_repository.dart';
import '../../domain/models/user_profile.dart';

part 'profile_providers.g.dart';

/// Single source of truth for "is onboarding complete" — used by both the
/// router redirect and the home screen.
@riverpod
Future<UserProfile?> currentProfile(Ref ref) {
  return ref.watch(onboardingRepositoryProvider).getProfile();
}

@riverpod
class ProfileSaveNotifier extends _$ProfileSaveNotifier {
  @override
  Future<void> build() async {}

  Future<void> save(UserProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(onboardingRepositoryProvider).saveProfile(profile);
      // ref.invalidate() (not ref.refresh()) so the router redirect and home
      // screen both pick up the freshly-saved row on their next read, rather
      // than an immediately-forced rebuild here.
      ref.invalidate(currentProfileProvider);
    });
  }
}
