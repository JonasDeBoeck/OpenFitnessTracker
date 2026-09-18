import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_colors.dart';

/// Text styles for the home/profile/add-food dashboard screens: Manrope for
/// display/headings, Roboto for body text, matching the approved design.
abstract final class DashboardTextStyles {
  static TextStyle greeting = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: DashboardColors.primary,
  );

  static TextStyle greetingDate = GoogleFonts.roboto(
    fontSize: 13,
    color: DashboardColors.textSecondary,
  );

  static TextStyle sectionTitle = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    color: DashboardColors.textPrimary,
  );

  static TextStyle gaugeValue = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    color: DashboardColors.primaryDark,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle gaugeSub = GoogleFonts.roboto(
    fontSize: 12,
    color: const Color(0xFF2C4A37),
  );

  static TextStyle gaugeRemaining = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 13.5,
    color: DashboardColors.primaryDark,
  );

  static TextStyle macroName = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: DashboardColors.textPrimary,
  );

  static TextStyle macroNums = GoogleFonts.roboto(
    fontSize: 12.5,
    color: DashboardColors.textSecondary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle mealTitle = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
    color: DashboardColors.textPrimary,
  );

  static TextStyle mealKcal = GoogleFonts.roboto(
    fontSize: 12.5,
    color: DashboardColors.textSecondary,
  );

  static TextStyle mealItemName = GoogleFonts.roboto(
    fontSize: 13.5,
    color: DashboardColors.textPrimary,
  );

  static TextStyle mealItemKcal = GoogleFonts.roboto(
    fontSize: 13,
    color: DashboardColors.textSecondary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle mealEmpty = GoogleFonts.roboto(
    fontSize: 13,
    fontStyle: FontStyle.italic,
    color: DashboardColors.textMuted,
  );

  static TextStyle addFoodButton = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 13.5,
    color: DashboardColors.primary,
  );

  static TextStyle navLabel = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 11,
  );

  static TextStyle tooltipTitle = GoogleFonts.roboto(
    fontWeight: FontWeight.w700,
    fontSize: 13,
    color: DashboardColors.tooltipText,
  );

  static TextStyle tooltipBody = GoogleFonts.roboto(
    fontSize: 12,
    height: 1.5,
    color: DashboardColors.tooltipText,
  );
}
