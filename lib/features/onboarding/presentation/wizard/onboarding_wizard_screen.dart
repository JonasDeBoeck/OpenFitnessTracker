import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../results/onboarding_results_screen.dart';
import '../providers/onboarding_wizard_notifier.dart';
import 'steps/activity_level_step_screen.dart';
import 'steps/age_step_screen.dart';
import 'steps/goal_step_screen.dart';
import 'steps/height_weight_step_screen.dart';
import 'steps/name_step_screen.dart';
import 'steps/sex_step_screen.dart';

const List<Widget> _steps = [
  NameStepScreen(),
  SexStepScreen(),
  AgeStepScreen(),
  HeightWeightStepScreen(),
  ActivityLevelStepScreen(),
  GoalStepScreen(),
  OnboardingResultsScreen(),
];

class OnboardingWizardScreen extends ConsumerWidget {
  const OnboardingWizardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(
      onboardingWizardProvider.select((s) => s.currentStep),
    );
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return PopScope(
      canPop: currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) notifier.previousStep();
      },
      child: IndexedStack(index: currentStep, children: _steps),
    );
  }
}
