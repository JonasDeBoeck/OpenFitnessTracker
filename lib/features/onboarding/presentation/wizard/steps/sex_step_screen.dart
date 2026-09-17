import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/sex.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

class SexStepScreen extends ConsumerWidget {
  const SexStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: "What's your sex?",
      canProceed: state.sex != null,
      onNext: notifier.nextStep,
      onBack: notifier.previousStep,
      body: RadioGroup<Sex>(
        groupValue: state.sex,
        onChanged: (value) => notifier.setSex(value!),
        child: Column(
          children: Sex.values.map((sex) {
            return RadioListTile<Sex>(title: Text(sex.label), value: sex);
          }).toList(),
        ),
      ),
    );
  }
}
