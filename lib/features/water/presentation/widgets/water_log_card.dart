import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/water_entry.dart';

/// Quick-add chips (+250/+500/+1000 mL) plus a custom-amount slider and the
/// day's logged entries, each deletable. Reused on Home (today) and Diary
/// (whichever day is selected).
class WaterLogCard extends StatelessWidget {
  const WaterLogCard({
    super.key,
    required this.entries,
    required this.onQuickAdd,
    required this.onCustomAdd,
    required this.onDelete,
  });

  final List<WaterEntry> entries;
  final ValueChanged<double> onQuickAdd;
  final ValueChanged<double> onCustomAdd;
  final ValueChanged<int> onDelete;

  Future<void> _openCustomSheet(BuildContext context) async {
    final value = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: DashboardColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CustomAmountSheet(onConfirm: (v) => Navigator.of(context).pop(v)),
    );
    if (value != null) onCustomAdd(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log water', style: DashboardTextStyles.mealTitle),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _QuickAddChip(label: '+250 mL', onTap: () => onQuickAdd(250))),
              const SizedBox(width: 8),
              Expanded(child: _QuickAddChip(label: '+500 mL', onTap: () => onQuickAdd(500))),
              const SizedBox(width: 8),
              Expanded(child: _QuickAddChip(label: '+1000 mL', onTap: () => onQuickAdd(1000))),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAddChip(
                  label: 'Custom',
                  color: DashboardColors.water,
                  onTap: () => _openCustomSheet(context),
                ),
              ),
            ],
          ),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: DashboardColors.border),
              _WaterEntryRow(entry: entries[i], onDelete: () => onDelete(entries[i].id!)),
            ],
          ],
        ],
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({required this.label, required this.onTap, this.color});

  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 38),
        side: BorderSide(color: color ?? DashboardColors.border),
        foregroundColor: color ?? DashboardColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: FittedBox(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _WaterEntryRow extends StatelessWidget {
  const _WaterEntryRow({required this.entry, required this.onDelete});

  final WaterEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(entry.loggedAt).format(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${entry.milliliters.toStringAsFixed(0)} mL · $time',
            style: DashboardTextStyles.mealItemName,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close, size: 15),
            color: DashboardColors.textMuted,
            iconSize: 15,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Delete entry',
          ),
        ],
      ),
    );
  }
}

class _CustomAmountSheet extends StatefulWidget {
  const _CustomAmountSheet({required this.onConfirm});

  final ValueChanged<double> onConfirm;

  @override
  State<_CustomAmountSheet> createState() => _CustomAmountSheetState();
}

class _CustomAmountSheetState extends State<_CustomAmountSheet> {
  double _value = 250;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Custom amount', style: DashboardTextStyles.mealTitle),
          const SizedBox(height: 14),
          Text(
            '${_value.toStringAsFixed(0)} mL',
            textAlign: TextAlign.center,
            style: DashboardTextStyles.gaugeValue.copyWith(color: DashboardColors.water),
          ),
          Slider(
            value: _value,
            min: 0,
            max: 500,
            divisions: 50,
            activeColor: DashboardColors.water,
            onChanged: (v) => setState(() => _value = v),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: DashboardColors.water),
            onPressed: () => widget.onConfirm(_value),
            child: Text('Log ${_value.toStringAsFixed(0)} mL'),
          ),
        ],
      ),
    );
  }
}
