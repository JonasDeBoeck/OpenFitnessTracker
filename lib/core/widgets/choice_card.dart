import 'package:flutter/material.dart';

import '../../features/home/presentation/theme/dashboard_colors.dart';
import '../../features/home/presentation/theme/dashboard_text_styles.dart';

/// A selectable card with a leading icon swatch, a title and an optional
/// description — the onboarding/profile "pick one" pattern (activity level,
/// goal, etc.), matching the design's `.choice-card`.
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.description,
    this.iconSize = 38,
    this.iconRadius = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.titleFontSize = 16,
  });

  final IconData icon;
  final String title;
  final String? description;
  final bool selected;
  final VoidCallback onTap;
  final double iconSize;
  final double iconRadius;
  final EdgeInsets padding;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? DashboardColors.gaugeCardBackground : DashboardColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? DashboardColors.primary : DashboardColors.border,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFC6E2CB) : DashboardColors.card,
                  borderRadius: BorderRadius.circular(iconRadius),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: iconSize * 0.5,
                  color: selected ? const Color(0xFF1F4A30) : DashboardColors.textSecondary,
                ),
              ),
              SizedBox(width: padding.horizontal / 2 - 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: selected ? const Color(0xFF12281B) : DashboardColors.textPrimary,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description!,
                        style: DashboardTextStyles.mealMacroChip.copyWith(
                          fontSize: 12.5,
                          height: 1.3,
                          color: selected ? const Color(0xFF2C4A37) : DashboardColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A selectable pill chip with a leading icon and centered label — the
/// design's `.choice-chip` (used for e.g. a two-way Male/Female picker).
class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? DashboardColors.gaugeCardBackground : DashboardColors.surface,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: selected ? DashboardColors.primary : DashboardColors.border,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? const Color(0xFF12281B) : DashboardColors.textPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? const Color(0xFF12281B) : DashboardColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
