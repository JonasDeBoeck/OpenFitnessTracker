import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/field_pill.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

class NameStepScreen extends ConsumerStatefulWidget {
  const NameStepScreen({super.key});

  @override
  ConsumerState<NameStepScreen> createState() => _NameStepScreenState();
}

class _NameStepScreenState extends ConsumerState<NameStepScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(onboardingWizardProvider).name,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingWizardProvider);
    final trimmedName = _controller.text.trim();

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: "What's your name?",
      canProceed: trimmedName.isNotEmpty,
      onNext: () {
        ref
            .read(onboardingWizardProvider.notifier)
            .setName(trimmedName);
        ref.read(onboardingWizardProvider.notifier).nextStep();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldPill(
            label: 'Name',
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }
}
