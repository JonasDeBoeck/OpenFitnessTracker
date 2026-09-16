import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

class HeightWeightStepScreen extends ConsumerStatefulWidget {
  const HeightWeightStepScreen({super.key});

  @override
  ConsumerState<HeightWeightStepScreen> createState() =>
      _HeightWeightStepScreenState();
}

class _HeightWeightStepScreenState
    extends ConsumerState<HeightWeightStepScreen> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final wizardState = ref.read(onboardingWizardProvider);
    _heightController = TextEditingController(
      text: wizardState.heightCm?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: wizardState.weightKg?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  double? get _height => double.tryParse(_heightController.text);
  double? get _weight => double.tryParse(_weightController.text);

  bool get _isValid {
    final height = _height;
    final weight = _weight;
    return height != null &&
        height > 0 &&
        height < 300 &&
        weight != null &&
        weight > 0 &&
        weight < 500;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: 'Height & weight',
      canProceed: _isValid,
      onNext: () {
        notifier.setHeightAndWeight(heightCm: _height!, weightKg: _weight!);
        notifier.nextStep();
      },
      onBack: notifier.previousStep,
      body: Column(
        children: [
          TextField(
            controller: _heightController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(labelText: 'Height (cm)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }
}
