import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/activity_level.dart';
import '../../domain/models/goal.dart';
import '../../domain/models/sex.dart';
import '../../domain/models/user_profile.dart';

part 'onboarding_wizard_state.freezed.dart';

const int onboardingStepCount = 7;

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
    UserProfile? result,
    @Default(false) bool isSaving,
    String? saveError,
  }) = _OnboardingWizardState;
}
