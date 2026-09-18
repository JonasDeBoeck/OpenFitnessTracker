import 'package:flutter/material.dart';

import '../../../onboarding/domain/calculations/nutrition_calculator.dart';
import '../../../onboarding/domain/models/activity_level.dart';
import '../../../onboarding/domain/models/goal.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_text_styles.dart';

/// "Today" section title with an info button that reveals a popover
/// explaining how the calorie/macro targets are calculated.
class TodaySectionHeader extends StatefulWidget {
  const TodaySectionHeader({super.key, required this.goal});

  /// The viewer's own goal, used to show their actual macro split in the
  /// popover rather than every goal's numbers.
  final Goal goal;

  @override
  State<TodaySectionHeader> createState() => _TodaySectionHeaderState();
}

class _TodaySectionHeaderState extends State<TodaySectionHeader> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  void _toggle() {
    if (_entry != null) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 8),
            child: _TargetsTooltip(goal: widget.goal),
          ),
        ],
      ),
    );
    overlay.insert(_entry!);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Today', style: DashboardTextStyles.sectionTitle),
        CompositedTransformTarget(
          link: _link,
          child: _InfoButton(onTap: _toggle),
        ),
      ],
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(
        side: BorderSide(color: DashboardColors.textMuted, width: 1.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.info_outline,
            size: 13,
            color: DashboardColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _TargetsTooltip extends StatelessWidget {
  const _TargetsTooltip({required this.goal});

  final Goal goal;

  static const Color _sectionLabelColor = Color(0xFF9FB8A8);
  static const Color _divider = Color(0x1EFBFAF2);

  @override
  Widget build(BuildContext context) {
    final macroRates = macroRatesFor(goal);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 274,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: DashboardColors.tooltipBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x38000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _divider)),
                ),
                child: Text(
                  'How your targets are calculated',
                  style: DashboardTextStyles.tooltipTitle,
                ),
              ),
            ),
            _Section(
              label: 'BMR · Mifflin-St Jeor',
              first: true,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormulaLine(
                    'Men: 10×weight + 6.25×height − 5×age + 5',
                  ),
                  _FormulaLine(
                    'Women: 10×weight + 6.25×height − 5×age − 161',
                  ),
                ],
              ),
            ),
            _Section(
              label: 'Activity multiplier → TDEE',
              child: Column(
                children: [
                  for (final level in ActivityLevel.values)
                    _ListRow(level.label, '×${level.multiplier}'),
                ],
              ),
            ),
            _Section(
              label: 'Goal adjustment',
              child: Column(
                children: [
                  for (final g in Goal.values)
                    _ListRow(g.label, _formatAdjustment(calorieAdjustmentFor(g))),
                ],
              ),
            ),
            _Section(
              label: 'Total calorie goal',
              child: const _FormulaLine(
                'Total kcal = BMR × activity multiplier + goal adjustment',
              ),
            ),
            _Section(
              label: 'Macro split — your ${goal.label} goal',
              child: Column(
                children: [
                  _ListRow('Protein · 4 kcal/g', '${macroRates.proteinPerKg} g/kg'),
                  _ListRow('Fat · 9 kcal/g', '${macroRates.fatPerKg} g/kg'),
                  const _ListRow('Carbs · 4 kcal/g', 'remainder'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatAdjustment(double kcal) {
    if (kcal == 0) return '±0 kcal';
    final sign = kcal > 0 ? '+' : '−';
    return '$sign${kcal.abs().toStringAsFixed(0)} kcal';
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child, this.first = false});

  final String label;
  final Widget child;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: first ? 0 : 12),
      padding: EdgeInsets.only(top: first ? 0 : 12),
      decoration: first
          ? null
          : const BoxDecoration(
              border: Border(
                top: BorderSide(color: _TargetsTooltip._divider),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: DashboardTextStyles.tooltipBody.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: _TargetsTooltip._sectionLabelColor,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _FormulaLine extends StatelessWidget {
  const _FormulaLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(text, style: DashboardTextStyles.tooltipBody),
    );
  }
}

class _ListRow extends StatelessWidget {
  const _ListRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: DashboardTextStyles.tooltipBody)),
          const SizedBox(width: 10),
          Text(
            value,
            style: DashboardTextStyles.tooltipBody.copyWith(
              fontWeight: FontWeight.w600,
              color: DashboardColors.tooltipText,
            ),
          ),
        ],
      ),
    );
  }
}
