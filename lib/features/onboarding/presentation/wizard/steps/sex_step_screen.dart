import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/choice_card.dart';
import '../../../domain/models/sex.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

IconData _iconFor(Sex sex) => switch (sex) {
  Sex.male => Icons.male,
  Sex.female => Icons.female,
};

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
      body: Row(
        children: [
          for (final sex in Sex.values) ...[
            if (sex != Sex.values.first) const SizedBox(width: 12),
            Expanded(
              child: OptionChip(
                icon: _iconFor(sex),
                label: sex.label,
                selected: state.sex == sex,
                onTap: () => notifier.setSex(sex),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
