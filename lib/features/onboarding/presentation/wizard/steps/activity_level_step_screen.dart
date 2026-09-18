import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/activity_level.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

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
      body: RadioGroup<ActivityLevel>(
        groupValue: state.activityLevel,
        onChanged: (value) => notifier.setActivityLevel(value!),
        child: ListView(
          children: ActivityLevel.values.map((level) {
            return RadioListTile<ActivityLevel>(
              title: Text(level.label),
              subtitle: Text(level.description),
              value: level,
            );
          }).toList(),
        ),
      ),
    );
  }
}
