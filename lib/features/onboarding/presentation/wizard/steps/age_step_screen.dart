import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

const int _minAge = 13;
const int _maxAge = 120;

class AgeStepScreen extends ConsumerStatefulWidget {
  const AgeStepScreen({super.key});

  @override
  ConsumerState<AgeStepScreen> createState() => _AgeStepScreenState();
}

class _AgeStepScreenState extends ConsumerState<AgeStepScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final age = ref.read(onboardingWizardProvider).age;
    _controller = TextEditingController(text: age?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? get _parsedAge => int.tryParse(_controller.text);

  bool get _isValid {
    final age = _parsedAge;
    return age != null && age >= _minAge && age <= _maxAge;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: 'How old are you?',
      canProceed: _isValid,
      onNext: () {
        notifier.setAge(_parsedAge!);
        notifier.nextStep();
      },
      onBack: notifier.previousStep,
      body: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Age',
          helperText: 'Between $_minAge and $_maxAge',
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
