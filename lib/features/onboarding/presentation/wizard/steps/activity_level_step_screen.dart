import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/choice_card.dart';
import '../../../domain/models/activity_level.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

IconData _iconFor(ActivityLevel level) => switch (level) {
  ActivityLevel.sedentary => Icons.weekend_outlined,
  ActivityLevel.light => Icons.directions_walk,
  ActivityLevel.moderate => Icons.directions_run,
  ActivityLevel.active => Icons.fitness_center,
  ActivityLevel.veryActive => Icons.bolt,
};

class ActivityLevelStepScreen extends ConsumerWidget {
  const ActivityLevelStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: 'How active are you?',
      canProceed: state.activityLevel != null,
      onNext: notifier.nextStep,
      onBack: notifier.previousStep,
      body: ListView.separated(
        itemCount: ActivityLevel.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final level = ActivityLevel.values[index];
          return ChoiceCard(
            icon: _iconFor(level),
            title: level.label,
            description: level.description,
            selected: state.activityLevel == level,
            onTap: () => notifier.setActivityLevel(level),
            iconSize: 36,
            iconRadius: 10,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            titleFontSize: 15.5,
          );
        },
      ),
    );
  }
}
