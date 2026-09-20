import 'package:flutter/material.dart';

import '../../home/presentation/theme/dashboard_colors.dart';
import '../../home/presentation/theme/dashboard_text_styles.dart';
import '../../onboarding/domain/calculations/nutrition_calculator.dart';
import '../../onboarding/domain/models/sex.dart';
import '../../onboarding/domain/models/user_profile.dart';

/// Shows the viewer's own inputs substituted into the BMR/TDEE/macro
/// formulas, then the resulting targets. Reached from Profile's "How is
/// this calculated?" link; [profile] is the (possibly unsaved) draft being
/// edited there, so the figures always match what Profile is showing.
class TargetsCalculationScreen extends StatelessWidget {
  const TargetsCalculationScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 14, 24, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: DashboardColors.textPrimary,
                    ),
                    tooltip: 'Back to Profile',
                  ),
                  Expanded(
                    child: Text(
                      'How your targets are calculated',
                      style: DashboardTextStyles.sectionTitle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InputsCard(profile: profile),
                    const SizedBox(height: 20),
                    _FormulaCard(profile: profile),
                    const SizedBox(height: 20),
                    _ResultsCard(profile: profile),
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

String _fmt(double value) {
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DashboardColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: DashboardTextStyles.macroName),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InputsCard extends StatelessWidget {
  const _InputsCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Your inputs',
      children: [
        _Row('Sex', profile.sex.label),
        _Row('Age', '${profile.age}'),
        _Row('Height', '${_fmt(profile.heightCm)} cm'),
        _Row('Weight', '${_fmt(profile.weightKg)} kg'),
        _Row('Activity level', profile.activityLevel.label),
        _Row('Goal', profile.goal.label),
      ],
    );
  }
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final macroRates = macroRatesFor(profile.goal);
    final adjustment = calorieAdjustmentFor(profile.goal);
    final adjustmentText = adjustment == 0
        ? '±0'
        : '${adjustment > 0 ? '+' : '−'}${adjustment.abs().toStringAsFixed(0)}';
    final bmrFormula = profile.sex == Sex.male
        ? '10×${_fmt(profile.weightKg)} + 6.25×${_fmt(profile.heightCm)} − 5×${profile.age} + 5'
        : '10×${_fmt(profile.weightKg)} + 6.25×${_fmt(profile.heightCm)} − 5×${profile.age} − 161';
    final proteinKcal = profile.proteinGrams * 4;
    final fatKcal = profile.fatGrams * 9;

    return _Card(
      title: 'The formula, with your numbers',
      children: [
        _FormulaLine('BMR · Mifflin-St Jeor', '$bmrFormula = ${_fmt(profile.bmr)} kcal'),
        const SizedBox(height: 10),
        _FormulaLine(
          'TDEE',
          '${_fmt(profile.bmr)} × ${profile.activityLevel.multiplier} (${profile.activityLevel.label}) = ${_fmt(profile.tdee)} kcal',
        ),
        const SizedBox(height: 10),
        _FormulaLine(
          'Target calories',
          '${_fmt(profile.tdee)} $adjustmentText kcal (${profile.goal.label}) = ${_fmt(profile.targetCalories)} kcal',
        ),
        const SizedBox(height: 10),
        _FormulaLine(
          'Protein · 4 kcal/g',
          '${macroRates.proteinPerKg} g/kg × ${_fmt(profile.weightKg)} kg = ${_fmt(profile.proteinGrams)} g',
        ),
        const SizedBox(height: 10),
        _FormulaLine(
          'Fat · 9 kcal/g',
          '${macroRates.fatPerKg} g/kg × ${_fmt(profile.weightKg)} kg = ${_fmt(profile.fatGrams)} g',
        ),
        const SizedBox(height: 10),
        _FormulaLine(
          'Carbs · 4 kcal/g (remainder)',
          '(${_fmt(profile.targetCalories)} − ${_fmt(proteinKcal)} − ${_fmt(fatKcal)}) ÷ 4 = ${_fmt(profile.carbGrams)} g',
        ),
      ],
    );
  }
}

class _ResultsCard extends StatelessWidget {
  const _ResultsCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DashboardColors.gaugeCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your targets', style: DashboardTextStyles.macroName),
          const SizedBox(height: 10),
          Text(
            '${_fmt(profile.targetCalories)} kcal / day',
            style: DashboardTextStyles.gaugeValue,
          ),
          const SizedBox(height: 4),
          Text(
            'BMR ${_fmt(profile.bmr)} kcal · TDEE ${_fmt(profile.tdee)} kcal',
            style: DashboardTextStyles.gaugeSub,
          ),
          const SizedBox(height: 12),
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
        ],
      ),
    );
  }
}

class _MacroFigure extends StatelessWidget {
  const _MacroFigure(this.label, this.grams, this.color);

  final String label;
  final double grams;
  final Color color;

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
        Text('$label ${_fmt(grams)}g', style: DashboardTextStyles.macroNums),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: DashboardTextStyles.mealItemName),
          Text(
            value,
            style: DashboardTextStyles.mealItemName.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormulaLine extends StatelessWidget {
  const _FormulaLine(this.label, this.formula);

  final String label;
  final String formula;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: DashboardTextStyles.macroNums.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(formula, style: DashboardTextStyles.mealItemName),
      ],
    );
  }
}
