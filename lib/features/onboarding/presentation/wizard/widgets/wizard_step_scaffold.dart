import 'package:flutter/material.dart';

import '../../../../home/presentation/theme/dashboard_colors.dart';
import '../../../../home/presentation/theme/dashboard_text_styles.dart';
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
      backgroundColor: DashboardColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(onBack == null ? 24 : 12, 22, 20, 10),
              child: Row(
                children: [
                  if (onBack != null) ...[
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                        onPressed: onBack,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: currentStep / onboardingStepCount,
                        minHeight: 4,
                        backgroundColor: const Color(0xFFE4E0D0),
                        valueColor: const AlwaysStoppedAnimation(DashboardColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: DashboardTextStyles.sectionTitle.copyWith(fontSize: 25)),
                    const SizedBox(height: 24),
                    Expanded(child: body),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: DashboardColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: canProceed ? onNext : null,
                        child: Text(nextLabel, style: DashboardTextStyles.sheetButtonLabel.copyWith(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
