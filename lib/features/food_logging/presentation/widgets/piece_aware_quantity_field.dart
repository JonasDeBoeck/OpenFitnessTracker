// lib/features/food_logging/presentation/widgets/piece_aware_quantity_field.dart
import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/quantity/piece_conversion.dart';
import 'quantity_stepper.dart';

enum _QuantityUnit { grams, piece }

/// Grams/piece amount control, generalizing the grams/servings toggle that
/// already exists privately in [RecipeDetailScreen]. Renders exactly like
/// [QuantityStepper] (unchanged look, unchanged behavior) whenever
/// [pieceLabel] or [pieceWeightGrams] is null; only when a food has both
/// does it add the segmented grams/piece toggle. Always reports back
/// grams — plus the unit actually used, when applicable — via [onChanged].
class PieceAwareQuantityField extends StatefulWidget {
  const PieceAwareQuantityField({
    super.key,
    required this.grams,
    required this.onChanged,
    this.pieceLabel,
    this.pieceWeightGrams,
    this.initialUnitCount,
    this.label = 'Quantity',
    this.showCard = true,
    this.minGrams = 0,
    this.maxGrams = double.infinity,
  });

  final double grams;
  final ValueChanged<LoggedQuantity> onChanged;
  final String? pieceLabel;
  final double? pieceWeightGrams;
  /// When non-null (and a piece unit is available), the field starts in
  /// piece mode showing this count instead of starting in grams mode —
  /// used by the Edit Diary Entry sheet to reopen an entry the way it was
  /// originally logged.
  final double? initialUnitCount;
  final String label;
  final bool showCard;
  final double minGrams;
  final double maxGrams;

  @override
  State<PieceAwareQuantityField> createState() => _PieceAwareQuantityFieldState();
}

class _PieceAwareQuantityFieldState extends State<PieceAwareQuantityField> {
  late _QuantityUnit _unit = _startingUnit();
  late final _controller = TextEditingController(text: _initialText());

  bool get _hasPieceUnit => widget.pieceLabel != null && widget.pieceWeightGrams != null;

  _QuantityUnit _startingUnit() =>
      widget.initialUnitCount != null && _hasPieceUnit ? _QuantityUnit.piece : _QuantityUnit.grams;

  String _initialText() => _unit == _QuantityUnit.piece
      ? _trimTrailingZero(widget.initialUnitCount!)
      : widget.grams.toStringAsFixed(0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _value => double.tryParse(_controller.text.trim()) ?? 0;

  String _trimTrailingZero(double value) {
    final text = value.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  double _clamp(double value) => _unit == _QuantityUnit.grams
      ? value.clamp(widget.minGrams, widget.maxGrams)
      : value.clamp(1, double.infinity);

  void _setValue(double value) {
    final clamped = _clamp(value);
    setState(() {
      _controller.text =
          _unit == _QuantityUnit.grams ? clamped.toStringAsFixed(0) : _trimTrailingZero(clamped);
    });
    _notify(clamped);
  }

  void _notify(double value) {
    if (_unit == _QuantityUnit.piece && _hasPieceUnit) {
      widget.onChanged(LoggedQuantity(
        grams: gramsFromPieceCount(value, widget.pieceWeightGrams!),
        unitLabel: widget.pieceLabel,
        unitCount: value,
      ));
    } else {
      widget.onChanged(LoggedQuantity(grams: value));
    }
  }

  void _pickUnit(_QuantityUnit unit) {
    if (unit == _unit || !_hasPieceUnit) return;
    setState(() {
      _unit = unit;
      _controller.text = unit == _QuantityUnit.grams
          ? widget.grams.toStringAsFixed(0)
          : _trimTrailingZero(pieceCountFromGrams(widget.grams, widget.pieceWeightGrams!));
    });
    _notify(_value);
  }

  void _increment() => _setValue(_unit == _QuantityUnit.grams ? _value + 25 : _value + 1);

  void _decrement() => _setValue(_unit == _QuantityUnit.grams ? _value - 25 : _value - 1);

  @override
  Widget build(BuildContext context) {
    if (!_hasPieceUnit) {
      return QuantityStepper(
        grams: widget.grams,
        onChanged: (value) => widget.onChanged(LoggedQuantity(grams: value)),
        label: widget.label,
        showCard: widget.showCard,
        minGrams: widget.minGrams,
        maxGrams: widget.maxGrams,
      );
    }

    final pieceLabel = widget.pieceLabel!;
    final unitSuffix = _unit == _QuantityUnit.grams
        ? 'g'
        : (_value == 1 ? pieceLabel : '${pieceLabel}s');
    final pieceButtonLabel = '${pieceLabel[0].toUpperCase()}${pieceLabel.substring(1)}s';

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: _UnitButton(
                  label: 'Grams',
                  active: _unit == _QuantityUnit.grams,
                  onTap: () => _pickUnit(_QuantityUnit.grams),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _UnitButton(
                  label: pieceButtonLabel,
                  active: _unit == _QuantityUnit.piece,
                  onTap: () => _pickUnit(_QuantityUnit.piece),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: DashboardTextStyles.macroName),
            Row(
              children: [
                _StepButton(icon: Icons.remove, onTap: _decrement),
                const SizedBox(width: 10),
                SizedBox(
                  width: 52,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _setValue(_value),
                    style: DashboardTextStyles.macroName,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(unitSuffix, style: DashboardTextStyles.mealKcal),
                const SizedBox(width: 10),
                _StepButton(icon: Icons.add, onTap: _increment),
              ],
            ),
          ],
        ),
      ],
    );

    if (!widget.showCard) return content;

    return Container(
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: content,
    );
  }
}

class _UnitButton extends StatelessWidget {
  const _UnitButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashboardColors.primary : DashboardColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? DashboardColors.primary : DashboardColors.border,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: DashboardTextStyles.macroNums.copyWith(
              fontWeight: FontWeight.w600,
              color: active ? DashboardColors.surface : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(side: BorderSide(color: DashboardColors.primary, width: 1.5)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: DashboardColors.primary),
        ),
      ),
    );
  }
}
