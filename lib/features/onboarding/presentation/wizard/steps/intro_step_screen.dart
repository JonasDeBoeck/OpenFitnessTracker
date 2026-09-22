import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/app_mark.dart';
import '../../../../home/presentation/theme/dashboard_colors.dart';
import '../../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../providers/onboarding_wizard_notifier.dart';

/// The welcome screen shown before any onboarding questions — no progress
/// bar or back button, matching the design (it's a standalone splash, not
/// one of the numbered wizard steps).
class IntroStepScreen extends ConsumerWidget {
  const IntroStepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingWizardProvider.notifier);

    return Scaffold(
      backgroundColor: DashboardColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 11),
              Container(
                width: 72,
                height: 72,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: DashboardColors.gaugeCardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(18),
                child: const AppMark(size: 36, color: DashboardColors.primaryDark),
              ),
              Text(
                'Your plan,\npersonalized.',
                style: DashboardTextStyles.sectionTitle.copyWith(fontSize: 30, height: 1.2),
              ),
              const SizedBox(height: 12),
              Text(
                "Answer a few quick questions and we'll calculate your daily "
                'calories and macros — built around your body and your goal.',
                style: DashboardTextStyles.mealKcal.copyWith(fontSize: 15, height: 1.5),
              ),
              const Spacer(flex: 9),
              const Column(
                children: [
                  _FeatureRow(
                    icon: Icons.track_changes_outlined,
                    text: 'Calorie & macro targets built for your goal',
                  ),
                  SizedBox(height: 16),
                  _FeatureRow(icon: Icons.schedule, text: 'Takes about a minute'),
                  SizedBox(height: 16),
                  _FeatureRow(
                    icon: Icons.shield_outlined,
                    text: 'Your numbers stay on your device',
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: DashboardColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: notifier.nextStep,
                  child: Text(
                    'Get started',
                    style: DashboardTextStyles.sheetButtonLabel.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: DashboardColors.card,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: DashboardColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: DashboardColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
