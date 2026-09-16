import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/models/user_profile.dart';
import '../providers/onboarding_wizard_notifier.dart';
import '../providers/onboarding_wizard_state.dart';
import '../providers/profile_providers.dart';

class OnboardingResultsScreen extends ConsumerWidget {
  const OnboardingResultsScreen({super.key});

  Future<void> _confirmAndSave(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    await ref.read(profileSaveProvider.notifier).save(profile);

    final saveState = ref.read(profileSaveProvider);
    if (saveState.hasError) return;
    if (!context.mounted) return;
    context.goNamed(AppRoutes.homeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);
    final saveState = ref.watch(profileSaveProvider);
    final profile = wizardState.result;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: notifier.previousStep,
        ),
        title: LinearProgressIndicator(
          value: (wizardState.currentStep + 1) / onboardingStepCount,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your targets, ${profile.name}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _ResultRow(
                      label: 'BMR',
                      value: '${profile.bmr.toStringAsFixed(0)} kcal',
                    ),
                    _ResultRow(
                      label: 'TDEE',
                      value: '${profile.tdee.toStringAsFixed(0)} kcal',
                    ),
                    _ResultRow(
                      label: 'Target calories',
                      value:
                          '${profile.targetCalories.toStringAsFixed(0)} kcal',
                    ),
                    _ResultRow(
                      label: 'Protein',
                      value: '${profile.proteinGrams.toStringAsFixed(1)} g',
                    ),
                    _ResultRow(
                      label: 'Fat',
                      value: '${profile.fatGrams.toStringAsFixed(1)} g',
                    ),
                    _ResultRow(
                      label: 'Carbs',
                      value: '${profile.carbGrams.toStringAsFixed(1)} g',
                    ),
                  ],
                ),
              ),
              if (saveState.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Could not save your profile. Please try again.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: saveState.isLoading
                      ? null
                      : () => _confirmAndSave(context, ref, profile),
                  child: saveState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm & save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
