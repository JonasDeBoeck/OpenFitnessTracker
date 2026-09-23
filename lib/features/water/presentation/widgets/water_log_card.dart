import 'package:flutter/material.dart';

import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/water_entry.dart';

/// Quick-add chips (+250/+500/+1000 mL) plus a custom-amount slider and the
/// day's logged entries, each deletable. Reused on Home (today) and Diary
/// (whichever day is selected).
class WaterLogCard extends StatefulWidget {
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

  @override
  State<WaterLogCard> createState() => _WaterLogCardState();
}

class _WaterLogCardState extends State<WaterLogCard> {
  // Ids dismissed locally but not yet reflected in `widget.entries`, since
  // that list only updates once the async delete + provider refresh
  // completes. Without this, a Dismissible whose entry is still present in
  // the next rebuild trips "A dismissed Dismissible widget is still part of
  // the tree" (or, in release builds, just reappears instead of erroring).
  final _pendingDeleteIds = <int>{};

  @override
  void didUpdateWidget(WaterLogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentIds = widget.entries.map((e) => e.id).toSet();
    _pendingDeleteIds.removeWhere((id) => !currentIds.contains(id));
  }

  Future<void> _openCustomSheet(BuildContext context) async {
    final value = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: DashboardColors.surface,
      barrierColor: DashboardColors.dialogBackdrop,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          _CustomAmountSheet(onConfirm: (v) => Navigator.of(context).pop(v)),
    );
    if (value != null) widget.onCustomAdd(value);
  }

  @override
  Widget build(BuildContext context) {
    final visibleEntries = widget.entries
        .where((e) => !_pendingDeleteIds.contains(e.id))
        .toList();

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
              Expanded(
                child: _QuickAddChip(
                  label: '+250 mL',
                  onTap: () => widget.onQuickAdd(250),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAddChip(
                  label: '+500 mL',
                  onTap: () => widget.onQuickAdd(500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAddChip(
                  label: '+1000 mL',
                  onTap: () => widget.onQuickAdd(1000),
                ),
              ),
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
          if (visibleEntries.isNotEmpty) ...[
            const SizedBox(height: 10),
            Column(
              spacing: 8,
              children: [
                for (final entry in visibleEntries)
                  _WaterEntryRow(
                    entry: entry,
                    onDelete: () {
                      setState(() => _pendingDeleteIds.add(entry.id!));
                      widget.onDelete(entry.id!);
                    },
                  ),
              ],
            ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Dismissible(
        key: ValueKey(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 14),
          color: DashboardColors.destructive,
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 18,
          ),
        ),
        confirmDismiss: (_) => showConfirmDeleteDialog(
          context,
          title: 'Delete this item?',
          message:
              '${entry.milliliters.toStringAsFixed(0)} mL will be removed from your log.',
        ),
        onDismissed: (_) => onDelete(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: DashboardColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${entry.milliliters.toStringAsFixed(0)} mL',
                style: DashboardTextStyles.waterEntryAmount,
              ),
              Text(time, style: DashboardTextStyles.waterEntryTime),
            ],
          ),
        ),
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
          Text('Custom amount', style: DashboardTextStyles.dialogTitle),
          const SizedBox(height: 14),
          Text(
            '${_value.toStringAsFixed(0)} mL',
            textAlign: TextAlign.center,
            style: DashboardTextStyles.sheetValue,
          ),
          Slider(
            value: _value,
            min: 0,
            max: 500,
            divisions: 50,
            activeColor: DashboardColors.water,
            onChanged: (v) => setState(() => _value = v),
          ),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: DashboardColors.water,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => widget.onConfirm(_value),
              child: Text(
                'Log ${_value.toStringAsFixed(0)} mL',
                style: DashboardTextStyles.sheetButtonLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
