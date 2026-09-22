import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/activity_level.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/sex.dart';
import '../../domain/models/user_profile.dart';

part 'onboarding_wizard_state.freezed.dart';

/// Denominator for the progress bar — the numbered steps from Name through
/// Results (Intro and Path aren't counted, matching the design: Name shows
/// 1/8, Results shows 8/8).
const int onboardingStepCount = 8;

/// Total number of screens in the wizard's [IndexedStack] (Intro, Name,
/// Path, Sex, Age, HeightWeight, ActivityLevel, Goal, Results) — used only
/// to bound [OnboardingWizardNotifier.nextStep]/`previousStep`.
const int onboardingScreenCount = 9;

@freezed
abstract class OnboardingWizardState with _$OnboardingWizardState {
  const factory OnboardingWizardState({
    @Default(0) int currentStep,
    String? name,
    Sex? sex,
    int? age,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    Goal? goal,
    @Default(false) bool manualCalorieMethod,
    double? manualMaintenanceCalories,
    UserProfile? result,
    @Default(false) bool isSaving,
    String? saveError,
  }) = _OnboardingWizardState;
}
