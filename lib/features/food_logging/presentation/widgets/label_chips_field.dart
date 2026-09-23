import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';

/// Editable list of free-text labels/tags — existing ones as removable
/// chips, plus a text field and add button for new ones. Used by Create
/// Recipe; the label text itself lives in the caller's state, this widget
/// is purely presentational.
class LabelChipsField extends StatefulWidget {
  const LabelChipsField({
    super.key,
    required this.labels,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> labels;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  State<LabelChipsField> createState() => _LabelChipsFieldState();
}

class _LabelChipsFieldState extends State<LabelChipsField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onAdd(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Labels', style: DashboardTextStyles.mealKcal),
        const SizedBox(height: 6),
        if (widget.labels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final label in widget.labels)
                  Chip(
                    label: Text(label),
                    labelStyle: DashboardTextStyles.macroNums.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: DashboardColors.primaryDark,
                    ),
                    backgroundColor: DashboardColors.gaugeCardBackground,
                    deleteIcon: const Icon(Icons.close, size: 14),
                    deleteIconColor: DashboardColors.primaryDark,
                    onDeleted: () => widget.onRemove(label),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(),
                textCapitalization: TextCapitalization.words,
                style: DashboardTextStyles.mealItemName,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'e.g. Meal prep',
                  filled: true,
                  fillColor: DashboardColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: DashboardColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add label',
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
