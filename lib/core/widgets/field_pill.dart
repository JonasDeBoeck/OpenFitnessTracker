import 'package:flutter/material.dart';

import '../../features/home/presentation/theme/dashboard_colors.dart';

/// A pill-shaped labeled text field — the design's `.field-label` +
/// `.field-pill`, with a green-bordered focus state. Used across onboarding
/// steps and Profile's editable numeric fields.
class FieldPill extends StatefulWidget {
  const FieldPill({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.suffixText,
    this.onChanged,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;

  @override
  State<FieldPill> createState() => _FieldPillState();
}

class _FieldPillState extends State<FieldPill> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            widget.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: DashboardColors.textSecondary),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _focused ? DashboardColors.surface : DashboardColors.card,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _focused ? DashboardColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            textAlign: widget.textAlign,
            textCapitalization: widget.textCapitalization,
            style: const TextStyle(
              fontSize: 16,
              color: DashboardColors.textPrimary,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              suffixText: widget.suffixText,
              suffixStyle: const TextStyle(fontSize: 15, color: DashboardColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
