import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/labels/label_suggestions.dart';

/// Editable multiselect of free-text labels/tags — existing ones as
/// removable chips, plus a search field that offers already-used labels as
/// tappable suggestions and, only when nothing matches, an explicit "add
/// new" chip. Used by Create Recipe; the label text itself lives in the
/// caller's state, this widget is purely presentational.
class LabelChipsField extends StatefulWidget {
  const LabelChipsField({
    super.key,
    required this.labels,
    required this.existingLabels,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> labels;
  final List<String> existingLabels;
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

  void _select(String label) {
    widget.onAdd(label);
    _controller.clear();
    setState(() {});
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    final existingMatch = findExistingLabel(widget.existingLabels, text);
    widget.onAdd(existingMatch ?? text);
    _controller.clear();
    setState(() {});
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
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
          textCapitalization: TextCapitalization.words,
          style: DashboardTextStyles.mealItemName,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search or add a label',
            filled: true,
            fillColor: DashboardColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        Builder(
          builder: (context) {
            final suggestions = filterLabelSuggestions(
              existingLabels: widget.existingLabels,
              selectedLabels: widget.labels,
              draft: _controller.text,
            );
            final offerNew = shouldOfferNewLabel(
              existingLabels: widget.existingLabels,
              selectedLabels: widget.labels,
              draft: _controller.text,
            );
            if (suggestions.isEmpty && !offerNew) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final label in suggestions)
                    _SuggestionChip(label: label, onTap: () => _select(label)),
                  if (offerNew) _AddNewChip(label: _controller.text.trim(), onTap: _submit),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFB9D6BE), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: DashboardTextStyles.macroNums.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: DashboardColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddNewChip extends StatelessWidget {
  const _AddNewChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DashboardColors.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 13, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                'Add "$label"',
                style: DashboardTextStyles.macroNums.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
