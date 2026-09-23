import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/utils/number_format.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/choice_card.dart';
import '../../../core/widgets/exit_confirmation_scope.dart';
import '../../../core/widgets/field_pill.dart';
import '../../home/presentation/theme/dashboard_colors.dart';
import '../../home/presentation/theme/dashboard_text_styles.dart';
import '../../onboarding/domain/calculations/nutrition_calculator.dart';
import '../../onboarding/domain/models/activity_level.dart';
import '../../onboarding/domain/models/goal.dart';
import '../../onboarding/domain/models/sex.dart';
import '../../onboarding/domain/models/user_profile.dart';
import 'providers/profile_edit_notifier.dart';

const int _minAge = 13;
const int _maxAge = 120;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _kcalController = TextEditingController();
  final _proteinRateController = TextEditingController();
  final _fatRateController = TextEditingController();
  final _waterController = TextEditingController();
  bool _controllersSeeded = false;
  bool _kcalCustom = false;
  bool _macrosCustom = false;
  bool _waterCustom = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _kcalController.dispose();
    _proteinRateController.dispose();
    _fatRateController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _seedControllers(UserProfile draft) {
    _weightController.text = _formatNumber(draft.weightKg);
    _heightController.text = _formatNumber(draft.heightCm);
    _ageController.text = draft.age.toString();
    _kcalController.text = draft.targetCalories.toStringAsFixed(0);
    final defaultRates = macroRatesFor(draft.goal);
    _proteinRateController.text = _formatNumber(
      draft.customProteinPerKg ?? defaultRates.proteinPerKg,
    );
    _fatRateController.text = _formatNumber(
      draft.customFatPerKg ?? defaultRates.fatPerKg,
    );
    _waterController.text = draft.waterTargetMl.toStringAsFixed(0);
    _kcalCustom = draft.customTargetCalories != null;
    _macrosCustom =
        draft.customProteinPerKg != null || draft.customFatPerKg != null;
    _waterCustom = draft.customWaterTargetMl != null;
    _controllersSeeded = true;
  }

  double? get _weight => double.tryParse(_weightController.text);
  double? get _height => double.tryParse(_heightController.text);
  int? get _age => int.tryParse(_ageController.text);
  double? get _kcal => double.tryParse(_kcalController.text);
  double? get _proteinRate => double.tryParse(_proteinRateController.text);
  double? get _fatRate => double.tryParse(_fatRateController.text);
  double? get _water => double.tryParse(_waterController.text);

  bool get _fieldsValid {
    final weight = _weight;
    final height = _height;
    final age = _age;
    final kcal = _kcal;
    final proteinRate = _proteinRate;
    final fatRate = _fatRate;
    final water = _water;
    if (height == null || height <= 0 || height >= 300) return false;
    if (weight == null || weight <= 0 || weight >= 500) return false;
    if (age == null || age < _minAge || age > _maxAge) return false;
    if (kcal == null || kcal < 500 || kcal > 10000) return false;
    if (proteinRate == null || proteinRate < 0 || proteinRate > 10) {
      return false;
    }
    if (fatRate == null || fatRate < 0 || fatRate > 10) return false;
    if (water == null || water < 0 || water > 15000) return false;
    final proteinCalories = proteinRate * weight * 4;
    final fatCalories = fatRate * weight * 9;
    if (proteinCalories + fatCalories > kcal) return false;
    return true;
  }

  UserProfile? get _draft => ref.read(profileEditProvider).value?.draft;

  void _onKcalFieldChanged() => setState(() => _kcalCustom = true);
  void _onMacroFieldChanged() => setState(() => _macrosCustom = true);
  void _onWaterFieldChanged() => setState(() => _waterCustom = true);

  void _resetKcal() {
    final draft = _draft;
    if (draft == null) return;
    final bmr = calculateBmr(
      sex: draft.sex,
      age: _age ?? draft.age,
      heightCm: _height ?? draft.heightCm,
      weightKg: _weight ?? draft.weightKg,
    );
    final tdee = calculateTdee(bmr: bmr, activityLevel: draft.activityLevel);
    final calculated = calculateTargetCalories(tdee: tdee, goal: draft.goal);
    setState(() {
      _kcalCustom = false;
      _kcalController.text = calculated.toStringAsFixed(0);
    });
  }

  void _resetMacros() {
    final draft = _draft;
    if (draft == null) return;
    final rates = macroRatesFor(draft.goal);
    setState(() {
      _macrosCustom = false;
      _proteinRateController.text = _formatNumber(rates.proteinPerKg);
      _fatRateController.text = _formatNumber(rates.fatPerKg);
    });
  }

  void _resetWater() {
    final draft = _draft;
    if (draft == null) return;
    final calculated = calculateWaterTargetMl(
      weightKg: _weight ?? draft.weightKg,
    );
    setState(() {
      _waterCustom = false;
      _waterController.text = calculated.toStringAsFixed(0);
    });
  }

  Future<void> _save() async {
    final notifier = ref.read(profileEditProvider.notifier);
    notifier.setWeightKg(_weight!);
    notifier.setHeightCm(_height!);
    notifier.setAge(_age!);
    notifier.setCustomTargetCalories(_kcalCustom ? _kcal : null);
    notifier.setCustomProteinPerKg(_macrosCustom ? _proteinRate : null);
    notifier.setCustomFatPerKg(_macrosCustom ? _fatRate : null);
    notifier.setCustomWaterTargetMl(_waterCustom ? _water : null);
    final success = await notifier.save();
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final editAsync = ref.watch(profileEditProvider);

    return ExitConfirmationScope(
      child: Scaffold(
        backgroundColor: DashboardColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Profile', style: DashboardTextStyles.greeting),
                ),
              ),
              Expanded(
                child: editAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('Could not load your profile: $error'),
                  ),
                  data: (editState) {
                    if (!_controllersSeeded) _seedControllers(editState.draft);
                    return _ProfileForm(
                      draft: editState.draft,
                      isSaving: editState.isSaving,
                      saveError: editState.saveError,
                      weightController: _weightController,
                      heightController: _heightController,
                      ageController: _ageController,
                      kcalController: _kcalController,
                      proteinRateController: _proteinRateController,
                      fatRateController: _fatRateController,
                      waterController: _waterController,
                      kcalCustom: _kcalCustom,
                      macrosCustom: _macrosCustom,
                      waterCustom: _waterCustom,
                      canSave: _fieldsValid,
                      onFieldChanged: () => setState(() {}),
                      onKcalFieldChanged: _onKcalFieldChanged,
                      onMacroFieldChanged: _onMacroFieldChanged,
                      onWaterFieldChanged: _onWaterFieldChanged,
                      onResetKcal: _resetKcal,
                      onResetMacros: _resetMacros,
                      onResetWater: _resetWater,
                      onSave: _save,
                      previewHeightCm: _height,
                      previewWeightKg: _weight,
                      previewAge: _age,
                      previewKcal: _kcalCustom ? _kcal : null,
                      previewProteinRate: _macrosCustom ? _proteinRate : null,
                      previewFatRate: _macrosCustom ? _fatRate : null,
                      previewWater: _waterCustom ? _water : null,
                    );
                  },
                ),
              ),
              const AppBottomNavBar(currentTab: AppNavTab.profile),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatNumber(double value) {
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toString();
}

class _ProfileForm extends ConsumerWidget {
  const _ProfileForm({
    required this.draft,
    required this.isSaving,
    required this.saveError,
    required this.weightController,
    required this.heightController,
    required this.ageController,
    required this.kcalController,
    required this.proteinRateController,
    required this.fatRateController,
    required this.waterController,
    required this.kcalCustom,
    required this.macrosCustom,
    required this.waterCustom,
    required this.canSave,
    required this.onFieldChanged,
    required this.onKcalFieldChanged,
    required this.onMacroFieldChanged,
    required this.onWaterFieldChanged,
    required this.onResetKcal,
    required this.onResetMacros,
    required this.onResetWater,
    required this.onSave,
    required this.previewHeightCm,
    required this.previewWeightKg,
    required this.previewAge,
    required this.previewKcal,
    required this.previewProteinRate,
    required this.previewFatRate,
    required this.previewWater,
  });

  final UserProfile draft;
  final bool isSaving;
  final Object? saveError;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController ageController;
  final TextEditingController kcalController;
  final TextEditingController proteinRateController;
  final TextEditingController fatRateController;
  final TextEditingController waterController;
  final bool kcalCustom;
  final bool macrosCustom;
  final bool waterCustom;
  final bool canSave;
  final VoidCallback onFieldChanged;
  final VoidCallback onKcalFieldChanged;
  final VoidCallback onMacroFieldChanged;
  final VoidCallback onWaterFieldChanged;
  final VoidCallback onResetKcal;
  final VoidCallback onResetMacros;
  final VoidCallback onResetWater;
  final VoidCallback onSave;
  final double? previewHeightCm;
  final double? previewWeightKg;
  final int? previewAge;
  final double? previewKcal;
  final double? previewProteinRate;
  final double? previewFatRate;
  final double? previewWater;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileEditProvider.notifier);
    final preview = buildUserProfile(
      name: draft.name,
      sex: draft.sex,
      age: previewAge ?? draft.age,
      heightCm: previewHeightCm ?? draft.heightCm,
      weightKg: previewWeightKg ?? draft.weightKg,
      activityLevel: draft.activityLevel,
      goal: draft.goal,
      customTargetCalories: previewKcal,
      customProteinPerKg: previewProteinRate,
      customFatPerKg: previewFatRate,
      customWaterTargetMl: previewWater,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionLabel('Goal'),
          const SizedBox(height: 8),
          _GoalPicker(value: draft.goal, onChanged: notifier.setGoal),
          const SizedBox(height: 20),
          _SectionLabel('Weight (kg)'),
          const SizedBox(height: 8),
          _NumberField(
            label: 'Weight',
            controller: weightController,
            suffixText: 'kg',
            onChanged: onFieldChanged,
          ),
          const SizedBox(height: 20),
          _SectionLabel('Height (cm)'),
          const SizedBox(height: 8),
          _NumberField(
            label: 'Height',
            controller: heightController,
            suffixText: 'cm',
            onChanged: onFieldChanged,
          ),
          const SizedBox(height: 20),
          _SectionLabel('Age'),
          const SizedBox(height: 8),
          _NumberField(
            label: 'Age',
            controller: ageController,
            allowDecimal: false,
            onChanged: onFieldChanged,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Text(
              'Between $_minAge and $_maxAge',
              style: TextStyle(
                fontSize: 12,
                color: DashboardColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionLabel('Gender'),
          const SizedBox(height: 8),
          _SexPicker(value: draft.sex, onChanged: notifier.setSex),
          const SizedBox(height: 20),
          _SectionLabel('Activity level'),
          const SizedBox(height: 8),
          _ActivityLevelPicker(
            value: draft.activityLevel,
            onChanged: notifier.setActivityLevel,
          ),
          const SizedBox(height: 20),
          _SectionHeaderRow(
            label: 'Daily calories',
            showReset: kcalCustom,
            onReset: onResetKcal,
          ),
          const SizedBox(height: 8),
          _NumberField(
            label: 'Calories',
            controller: kcalController,
            suffixText: 'kcal',
            allowDecimal: false,
            onChanged: onKcalFieldChanged,
          ),
          const SizedBox(height: 20),
          _SectionHeaderRow(
            label: 'Macro distribution',
            showReset: macrosCustom,
            onReset: onResetMacros,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _NumberField(
                  label: 'Protein',
                  controller: proteinRateController,
                  suffixText: 'g/kg',
                  onChanged: onMacroFieldChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NumberField(
                  label: 'Fat',
                  controller: fatRateController,
                  suffixText: 'g/kg',
                  onChanged: onMacroFieldChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Carbs fill the rest.',
            style: TextStyle(fontSize: 12, color: DashboardColors.textMuted),
          ),
          const SizedBox(height: 20),
          _SectionHeaderRow(
            label: 'Water goal (mL)',
            showReset: waterCustom,
            onReset: onResetWater,
          ),
          const SizedBox(height: 8),
          _NumberField(
            label: 'Water',
            controller: waterController,
            suffixText: 'mL',
            allowDecimal: false,
            onChanged: onWaterFieldChanged,
          ),
          const SizedBox(height: 24),
          _TargetsSummaryCard(profile: preview),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: DashboardColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: canSave && !isSaving ? onSave : null,
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save changes'),
          ),
          if (saveError != null) ...[
            const SizedBox(height: 10),
            Text(
              'Could not save: $saveError',
              style: DashboardTextStyles.mealEmpty.copyWith(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: DashboardTextStyles.sectionTitle);
  }
}

class _SectionHeaderRow extends StatelessWidget {
  const _SectionHeaderRow({
    required this.label,
    required this.showReset,
    required this.onReset,
  });

  final String label;
  final bool showReset;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionLabel(label),
        if (showReset)
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Reset to calculated',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.suffixText,
    this.allowDecimal = true,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final String? suffixText;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return FieldPill(
      label: label,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      suffixText: suffixText,
      onChanged: (_) => onChanged(),
    );
  }
}

IconData _iconForGoal(Goal goal) => switch (goal) {
  Goal.cut => Icons.trending_down,
  Goal.bulk => Icons.trending_up,
  Goal.maintain => Icons.trending_flat,
};

IconData _iconForSex(Sex sex) => switch (sex) {
  Sex.male => Icons.male,
  Sex.female => Icons.female,
};

IconData _iconForActivityLevel(ActivityLevel level) => switch (level) {
  ActivityLevel.sedentary => Icons.weekend_outlined,
  ActivityLevel.light => Icons.directions_walk,
  ActivityLevel.moderate => Icons.directions_run,
  ActivityLevel.active => Icons.fitness_center,
  ActivityLevel.veryActive => Icons.bolt,
};

class _GoalPicker extends StatelessWidget {
  const _GoalPicker({required this.value, required this.onChanged});

  final Goal value;
  final ValueChanged<Goal> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final goal in Goal.values) ...[
          if (goal != Goal.values.first) const SizedBox(height: 10),
          ChoiceCard(
            icon: _iconForGoal(goal),
            title: goal.label,
            description: goal.description,
            selected: value == goal,
            onTap: () => onChanged(goal),
          ),
        ],
      ],
    );
  }
}

class _SexPicker extends StatelessWidget {
  const _SexPicker({required this.value, required this.onChanged});

  final Sex value;
  final ValueChanged<Sex> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final sex in Sex.values) ...[
          if (sex != Sex.values.first) const SizedBox(width: 12),
          Expanded(
            child: OptionChip(
              icon: _iconForSex(sex),
              label: sex.label,
              selected: value == sex,
              onTap: () => onChanged(sex),
            ),
          ),
        ],
      ],
    );
  }
}

class _ActivityLevelPicker extends StatelessWidget {
  const _ActivityLevelPicker({required this.value, required this.onChanged});

  final ActivityLevel value;
  final ValueChanged<ActivityLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final level in ActivityLevel.values) ...[
          if (level != ActivityLevel.values.first) const SizedBox(height: 10),
          ChoiceCard(
            icon: _iconForActivityLevel(level),
            title: level.label,
            description: level.description,
            selected: value == level,
            onTap: () => onChanged(level),
            iconSize: 36,
            iconRadius: 10,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            titleFontSize: 15.5,
          ),
        ],
      ],
    );
  }
}

class _TargetsSummaryCard extends StatelessWidget {
  const _TargetsSummaryCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: DashboardColors.gaugeCardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your daily targets',
                style: DashboardTextStyles.targetsTitle,
              ),
              InkWell(
                onTap: () => context.push(
                  AppRoutes.targetsCalculationPath,
                  extra: profile,
                ),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 15,
                        color: DashboardColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'How is this calculated?',
                        style: TextStyle(
                          fontSize: 12,
                          color: DashboardColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${groupedInt(profile.targetCalories)} kcal / day',
            style: DashboardTextStyles.targetsKcal,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _MacroFigure(
                'Protein',
                profile.proteinGrams,
                DashboardColors.macroProtein,
              ),
              _MacroFigure('Fat', profile.fatGrams, DashboardColors.macroFat),
              _MacroFigure(
                'Carbs',
                profile.carbGrams,
                DashboardColors.macroCarb,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MacroFigure(
            'Water',
            profile.waterTargetMl,
            DashboardColors.water,
            unit: 'mL',
          ),
        ],
      ),
    );
  }
}

class _MacroFigure extends StatelessWidget {
  const _MacroFigure(this.label, this.amount, this.color, {this.unit = 'g'});

  final String label;
  final double amount;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ${amount.toStringAsFixed(0)}$unit',
          style: DashboardTextStyles.macroNums,
        ),
      ],
    );
  }
}
