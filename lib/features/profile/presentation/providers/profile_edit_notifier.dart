import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../onboarding/domain/calculations/nutrition_calculator.dart';
import '../../../onboarding/domain/models/activity_level.dart';
import '../../../onboarding/domain/models/goal.dart';
import '../../../onboarding/domain/models/sex.dart';
import '../../../onboarding/domain/models/user_profile.dart';
import '../../../onboarding/presentation/providers/profile_providers.dart';

part 'profile_edit_notifier.g.dart';

class ProfileEditState {
  const ProfileEditState({
    required this.draft,
    this.isSaving = false,
    this.saveError,
  });

  /// Editable copy of the persisted profile. Its `bmr`/`tdee`/
  /// `targetCalories`/macro fields are recomputed on [ProfileEditNotifier.save],
  /// not live on every field edit — the screen computes its own live preview.
  final UserProfile draft;
  final bool isSaving;
  final Object? saveError;

  ProfileEditState copyWith({
    UserProfile? draft,
    bool? isSaving,
    Object? saveError,
  }) {
    return ProfileEditState(
      draft: draft ?? this.draft,
      isSaving: isSaving ?? this.isSaving,
      saveError: saveError,
    );
  }
}

@riverpod
class ProfileEditNotifier extends _$ProfileEditNotifier {
  @override
  Future<ProfileEditState> build() async {
    final profile = await ref.watch(currentProfileProvider.future);
    return ProfileEditState(draft: profile!);
  }

  void setGoal(Goal goal) => _updateDraft((d) => d.copyWith(goal: goal));

  void setSex(Sex sex) => _updateDraft((d) => d.copyWith(sex: sex));

  void setAge(int age) => _updateDraft((d) => d.copyWith(age: age));

  void setHeightCm(double heightCm) =>
      _updateDraft((d) => d.copyWith(heightCm: heightCm));

  void setWeightKg(double weightKg) =>
      _updateDraft((d) => d.copyWith(weightKg: weightKg));

  void setActivityLevel(ActivityLevel activityLevel) =>
      _updateDraft((d) => d.copyWith(activityLevel: activityLevel));

  void setCustomTargetCalories(double? customTargetCalories) => _updateDraft(
    (d) => d.copyWith(customTargetCalories: customTargetCalories),
  );

  void setCustomProteinPerKg(double? customProteinPerKg) => _updateDraft(
    (d) => d.copyWith(customProteinPerKg: customProteinPerKg),
  );

  void setCustomFatPerKg(double? customFatPerKg) =>
      _updateDraft((d) => d.copyWith(customFatPerKg: customFatPerKg));

  void setCustomWaterTargetMl(double? customWaterTargetMl) => _updateDraft(
    (d) => d.copyWith(customWaterTargetMl: customWaterTargetMl),
  );

  void _updateDraft(UserProfile Function(UserProfile draft) update) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(draft: update(current.draft), saveError: null),
    );
  }

  Future<bool> save() async {
    final current = state.value;
    if (current == null) return false;

    state = AsyncData(current.copyWith(isSaving: true, saveError: null));

    final recalculated = buildUserProfile(
      name: current.draft.name,
      sex: current.draft.sex,
      age: current.draft.age,
      heightCm: current.draft.heightCm,
      weightKg: current.draft.weightKg,
      activityLevel: current.draft.activityLevel,
      goal: current.draft.goal,
      customTargetCalories: current.draft.customTargetCalories,
      customProteinPerKg: current.draft.customProteinPerKg,
      customFatPerKg: current.draft.customFatPerKg,
      customWaterTargetMl: current.draft.customWaterTargetMl,
    ).copyWith(id: current.draft.id, createdAt: current.draft.createdAt);

    try {
      await ref.read(profileSaveProvider.notifier).save(recalculated);
      state = AsyncData(
        current.copyWith(draft: recalculated, isSaving: false),
      );
      return true;
    } catch (error) {
      state = AsyncData(
        current.copyWith(isSaving: false, saveError: error),
      );
      return false;
    }
  }
}
