import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/calculations/nutrition_calculator.dart';
import '../../domain/models/activity_level.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/sex.dart';
import 'onboarding_wizard_state.dart';

part 'onboarding_wizard_notifier.g.dart';

@riverpod
class OnboardingWizardNotifier extends _$OnboardingWizardNotifier {
  @override
  OnboardingWizardState build() => const OnboardingWizardState();

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setSex(Sex sex) {
    state = state.copyWith(sex: sex);
  }

  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  void setHeightAndWeight({required double heightCm, required double weightKg}) {
    state = state.copyWith(heightCm: heightCm, weightKg: weightKg);
  }

  void setActivityLevel(ActivityLevel activityLevel) {
    state = state.copyWith(activityLevel: activityLevel);
  }

  void setGoal(Goal goal) {
    state = state.copyWith(goal: goal);
  }

  void setCalorieMethod(bool manual) {
    state = state.copyWith(manualCalorieMethod: manual);
  }

  void setManualMaintenanceCalories(double kcal) {
    state = state.copyWith(manualMaintenanceCalories: kcal);
  }

  void nextStep() {
    if (state.currentStep < onboardingScreenCount - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// Computes the final profile from the answers gathered so far. Must only
  /// be called once all required answers are set.
  void computeResults() {
    final result = buildUserProfile(
      name: state.name!,
      sex: state.sex!,
      age: state.age!,
      heightCm: state.heightCm!,
      weightKg: state.weightKg!,
      // The activity-level question is replaced by a direct maintenance-
      // calorie entry on the manual path, so there's no real answer to
      // fall back on — `moderate` is a neutral placeholder that has no
      // effect on the target since `manualMaintenanceCalories` overrides
      // the TDEE it would otherwise feed into.
      activityLevel: state.activityLevel ?? ActivityLevel.moderate,
      goal: state.goal!,
      manualMaintenanceCalories:
          state.manualCalorieMethod ? state.manualMaintenanceCalories : null,
    );
    state = state.copyWith(result: result);
  }

  void setSaving(bool isSaving) {
    state = state.copyWith(isSaving: isSaving, saveError: null);
  }

  void setSaveError(String error) {
    state = state.copyWith(isSaving: false, saveError: error);
  }
}
