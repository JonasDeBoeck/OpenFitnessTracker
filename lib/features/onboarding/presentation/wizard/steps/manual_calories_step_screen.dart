import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/field_pill.dart';
import '../../../../home/presentation/theme/dashboard_colors.dart';
import '../../providers/onboarding_wizard_notifier.dart';
import '../widgets/wizard_step_scaffold.dart';

/// Shown instead of [ActivityLevelStepScreen] when the user picked "I know
/// my numbers" on the Path step — their entered figure stands in for the
/// calculated TDEE, so there's nothing an activity-level question would add.
class ManualCaloriesStepScreen extends ConsumerStatefulWidget {
  const ManualCaloriesStepScreen({super.key});

  @override
  ConsumerState<ManualCaloriesStepScreen> createState() => _ManualCaloriesStepScreenState();
}

class _ManualCaloriesStepScreenState extends ConsumerState<ManualCaloriesStepScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final kcal = ref.read(onboardingWizardProvider).manualMaintenanceCalories;
    _controller = TextEditingController(text: kcal?.toStringAsFixed(0) ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? get _parsed => double.tryParse(_controller.text);

  bool get _isValid {
    final kcal = _parsed;
    return kcal != null && kcal >= 800 && kcal <= 8000;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return WizardStepScaffold(
      currentStep: state.currentStep,
      title: "What's your maintenance calories?",
      canProceed: _isValid,
      onNext: () {
        notifier.setManualMaintenanceCalories(_parsed!);
        notifier.nextStep();
      },
      onBack: notifier.previousStep,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldPill(
            label: 'Maintenance calories',
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            suffixText: 'kcal',
            onChanged: (_) => setState(() {}),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Text(
              'The calories you eat to hold your current weight steady — '
              "we'll adjust from there for your goal.",
              style: TextStyle(fontSize: 12, color: DashboardColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
