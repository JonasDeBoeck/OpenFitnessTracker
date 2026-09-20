import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../domain/models/trends_range.dart';

/// The 7D/30D/90D/All segmented range picker at the top of the Trends
/// screen, styled like Profile's choice-chip pattern.
class TrendsRangeSelector extends StatelessWidget {
  const TrendsRangeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TrendsRange value;
  final ValueChanged<TrendsRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final range in TrendsRange.values) ...[
          if (range != TrendsRange.values.first) const SizedBox(width: 8),
          Expanded(
            child: _RangeChip(
              range: range,
              selected: range == value,
              onTap: () => onChanged(range),
            ),
          ),
        ],
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.range,
    required this.selected,
    required this.onTap,
  });

  final TrendsRange range;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? DashboardColors.gaugeCardBackground
                : DashboardColors.card,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: selected
                  ? DashboardColors.primary
                  : DashboardColors.border,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Text(
            range.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected
                  ? DashboardColors.primaryDark
                  : DashboardColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
