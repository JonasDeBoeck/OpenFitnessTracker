import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/number_format.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/user_profile.dart';
import '../providers/onboarding_wizard_notifier.dart';
import '../providers/onboarding_wizard_state.dart';
import '../providers/profile_providers.dart';

class OnboardingResultsScreen extends ConsumerStatefulWidget {
  const OnboardingResultsScreen({super.key});

  @override
  ConsumerState<OnboardingResultsScreen> createState() => _OnboardingResultsScreenState();
}

class _OnboardingResultsScreenState extends ConsumerState<OnboardingResultsScreen> {
  bool _bmrOpen = false;
  bool _tdeeOpen = false;

  Future<void> _confirmAndSave(UserProfile profile) async {
    await ref.read(profileSaveProvider.notifier).save(profile);

    final saveState = ref.read(profileSaveProvider);
    if (saveState.hasError) return;
    if (!mounted) return;
    context.goNamed(AppRoutes.homeName);
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(onboardingWizardProvider);
    final notifier = ref.read(onboardingWizardProvider.notifier);
    final saveState = ref.watch(profileSaveProvider);
    final profile = wizardState.result;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: DashboardColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 22, 20, 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                      onPressed: notifier.previousStep,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: wizardState.currentStep / onboardingStepCount,
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
                    Text('Your targets, ${profile.name}', style: DashboardTextStyles.sectionTitle.copyWith(fontSize: 23)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            children: [
                              _ResultRow(
                                label: 'BMR',
                                value: '${groupedInt(profile.bmr)} kcal',
                                infoOpen: _bmrOpen,
                                onToggleInfo: () => setState(() {
                                  _bmrOpen = !_bmrOpen;
                                  _tdeeOpen = false;
                                }),
                                tooltip: const _InfoTooltip(
                                  title: 'Basal Metabolic Rate',
                                  body:
                                      ' — the calories your body burns at rest just to keep organs, breathing and circulation running.',
                                ),
                                showDivider: true,
                              ),
                              _ResultRow(
                                label: 'TDEE',
                                value: '${groupedInt(profile.tdee)} kcal',
                                infoOpen: _tdeeOpen,
                                onToggleInfo: () => setState(() {
                                  _tdeeOpen = !_tdeeOpen;
                                  _bmrOpen = false;
                                }),
                                tooltip: const _InfoTooltip(
                                  title: 'Total Daily Energy Expenditure',
                                  body:
                                      ' — your BMR plus the calories burned from daily activity and exercise.',
                                ),
                                showDivider: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                            decoration: BoxDecoration(
                              color: DashboardColors.gaugeCardBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TARGET CALORIES', style: DashboardTextStyles.heroLabel),
                                const SizedBox(height: 4),
                                Text(
                                  '${groupedInt(profile.targetCalories)} kcal',
                                  style: DashboardTextStyles.heroValue,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.7,
                            children: [
                              _MacroTile(
                                color: DashboardColors.macroProtein,
                                label: 'PROTEIN',
                                value: '${profile.proteinGrams.toStringAsFixed(1)} g',
                              ),
                              _MacroTile(
                                color: DashboardColors.macroFat,
                                label: 'FAT',
                                value: '${profile.fatGrams.toStringAsFixed(1)} g',
                              ),
                              _MacroTile(
                                color: DashboardColors.macroCarb,
                                label: 'CARBS',
                                value: '${profile.carbGrams.toStringAsFixed(1)} g',
                              ),
                              _MacroTile(
                                color: DashboardColors.water,
                                label: 'WATER',
                                value: '${groupedInt(profile.waterTargetMl)} mL',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (saveState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Could not save your profile. Please try again.',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: DashboardColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: saveState.isLoading ? null : () => _confirmAndSave(profile),
                        child: saveState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                'Confirm & save',
                                style: DashboardTextStyles.sheetButtonLabel.copyWith(fontSize: 16),
                              ),
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.infoOpen,
    required this.onToggleInfo,
    required this.tooltip,
    required this.showDivider,
  });

  final String label;
  final String value;
  final bool infoOpen;
  final VoidCallback onToggleInfo;
  final Widget tooltip;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: DashboardColors.border))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(label, style: DashboardTextStyles.resultLabel),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(
                        side: BorderSide(color: DashboardColors.textMuted, width: 1.5),
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onToggleInfo,
                        child: const Icon(
                          Icons.info_outline,
                          size: 11,
                          color: DashboardColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(value, style: DashboardTextStyles.resultValue),
            ],
          ),
          if (infoOpen)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(alignment: Alignment.centerLeft, child: tooltip),
            ),
        ],
      ),
    );
  }
}

class _InfoTooltip extends StatelessWidget {
  const _InfoTooltip({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: DashboardColors.tooltipBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          style: DashboardTextStyles.resultTooltip,
          children: [
            TextSpan(text: title, style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: body),
          ],
        ),
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({required this.color, required this.label, required this.value});

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 6),
          Text(label, style: DashboardTextStyles.macroTileLabel),
          Text(value, style: DashboardTextStyles.macroTileValue),
        ],
      ),
    );
  }
}
