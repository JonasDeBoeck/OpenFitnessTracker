import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/choice_card.dart';
import '../../../domain/models/goal.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

IconData _iconFor(Goal goal) => switch (goal) {
  Goal.cut => Icons.trending_down,
  Goal.bulk => Icons.trending_up,
  Goal.maintain => Icons.trending_flat,
};

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
      body: Column(
        children: [
          for (final goal in Goal.values) ...[
            if (goal != Goal.values.first) const SizedBox(height: 10),
            ChoiceCard(
              icon: _iconFor(goal),
              title: goal.label,
              description: goal.description,
              selected: state.goal == goal,
              onTap: () => notifier.setGoal(goal),
            ),
          ],
        ],
      ),
    );
  }
}
