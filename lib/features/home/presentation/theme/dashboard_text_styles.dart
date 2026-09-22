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

  static TextStyle mealItemGrams = GoogleFonts.roboto(
    fontSize: 11.5,
    color: DashboardColors.textMuted,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle waterEntryAmount = GoogleFonts.roboto(
    fontSize: 13,
    color: DashboardColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle waterEntryTime = GoogleFonts.roboto(
    fontSize: 12.5,
    color: DashboardColors.textSecondary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle mealMacroChip = GoogleFonts.roboto(
    fontSize: 11.5,
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

  static TextStyle dialogTitle = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: DashboardColors.textPrimary,
  );

  static TextStyle confirmMessage = GoogleFonts.roboto(
    fontSize: 13.5,
    color: DashboardColors.textSecondary,
    height: 1.4,
  );

  static TextStyle dialogButtonLabel = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static TextStyle sheetButtonLabel = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.white,
  );

  static TextStyle editKcalPreview = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: DashboardColors.textPrimary,
  );

  static TextStyle topbarTitle = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: DashboardColors.textPrimary,
  );

  static TextStyle resultLabel = GoogleFonts.roboto(
    fontSize: 15,
    color: DashboardColors.textSecondary,
  );

  static TextStyle resultValue = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: DashboardColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle resultTooltip = GoogleFonts.roboto(
    fontSize: 12.5,
    height: 1.42,
    color: DashboardColors.tooltipText,
  );

  static TextStyle heroLabel = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 12.5,
    color: const Color(0xFF12281B),
    letterSpacing: 0.3,
  );

  static TextStyle heroValue = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 34,
    color: DashboardColors.primaryDark,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle macroTileLabel = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 10.5,
    color: DashboardColors.textSecondary,
    letterSpacing: 0.4,
  );

  static TextStyle macroTileValue = GoogleFonts.roboto(
    fontWeight: FontWeight.w700,
    fontSize: 17,
    color: DashboardColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle targetsTitle = GoogleFonts.roboto(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: DashboardColors.primaryDark,
  );

  static TextStyle targetsKcal = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 26,
    color: DashboardColors.primaryDark,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle sheetValue = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 26,
    color: DashboardColors.water,
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

  static TextStyle listHeading = GoogleFonts.manrope(
    fontWeight: FontWeight.w700,
    fontSize: 12.5,
    color: DashboardColors.textSecondary,
    letterSpacing: 0.4,
  );
}
