import 'package:flutter/material.dart';

import '../../providers/onboarding_wizard_state.dart';

class WizardStepScaffold extends StatelessWidget {
  const WizardStepScaffold({
    super.key,
    required this.currentStep,
    required this.title,
    required this.body,
    required this.canProceed,
    required this.onNext,
    this.onBack,
    this.nextLabel = 'Next',
  });

  final int currentStep;
  final String title;
  final Widget body;
  final bool canProceed;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              ),
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: (currentStep + 1) / onboardingStepCount,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              Expanded(child: body),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canProceed ? onNext : null,
                  child: Text(nextLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
