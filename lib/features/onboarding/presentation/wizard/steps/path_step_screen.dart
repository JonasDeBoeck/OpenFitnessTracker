import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/choice_card.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

/// Lets the user choose between entering their maintenance calories
/// directly ("I know my numbers") or answering the body-stat questions that
/// follow so the app can estimate them ("Estimate for me"). Either way Sex,
/// Age and Height/Weight are still asked (needed for macros and water), but
/// the Activity-level question is swapped for a direct calorie entry on the
/// manual path — see [ManualCaloriesStepScreen].
class PathStepScreen extends ConsumerWidget {
  const PathStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: 'How should we set your calories?',
      canProceed: true,
      onNext: notifier.nextStep,
      onBack: notifier.previousStep,
      body: Column(
        children: [
          ChoiceCard(
            icon: Icons.edit_note,
            title: 'I know my numbers',
            description: 'Enter your maintenance calories directly',
            selected: state.manualCalorieMethod,
            onTap: () => notifier.setCalorieMethod(true),
          ),
          const SizedBox(height: 12),
          ChoiceCard(
            icon: Icons.search,
            title: 'Estimate for me',
            description: 'Answer a few quick questions about your body and activity',
            selected: !state.manualCalorieMethod,
            onTap: () => notifier.setCalorieMethod(false),
          ),
        ],
      ),
    );
  }
}
