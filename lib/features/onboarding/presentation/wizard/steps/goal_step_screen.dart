import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/goal.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

class GoalStepScreen extends ConsumerWidget {
  const GoalStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: "What's your goal?",
      canProceed: state.goal != null,
      nextLabel: 'See my targets',
      onNext: () {
        notifier.computeResults();
        notifier.nextStep();
      },
      onBack: notifier.previousStep,
      body: RadioGroup<Goal>(
        groupValue: state.goal,
        onChanged: (value) => notifier.setGoal(value!),
        child: Column(
          children: Goal.values.map((goal) {
            return RadioListTile<Goal>(
              title: Text(goal.label),
              subtitle: Text(goal.description),
              value: goal,
            );
          }).toList(),
        ),
      ),
    );
  }
}
