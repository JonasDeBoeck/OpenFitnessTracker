import 'package:flutter/material.dart';

/// Fixed light palette for the home/profile/add-food dashboard screens,
/// matching the approved design. Deliberately not wired into the app-wide
/// [ThemeData] (which stays Material-3/seed-color for onboarding) and
/// deliberately not dark-mode aware, matching the source design.
abstract final class DashboardColors {
  static const Color pageBackground = Color(0xFFEFEBDD);
  static const Color surface = Color(0xFFFBFAF2);
  static const Color card = Color(0xFFF0EDE0);
  static const Color border = Color(0xFFDAD6C6);

  static const Color primary = Color(0xFF3C6E4F);
  static const Color primaryDark = Color(0xFF1F4A30);
  static const Color gaugeTrack = Color(0xFFBFDDC5);
  static const Color gaugeCardBackground = Color(0xFFDCEEDD);

  static const Color textPrimary = Color(0xFF1C1C17);
  static const Color textSecondary = Color(0xFF5B594C);
  static const Color textMuted = Color(0xFF9C9A8A);

  static const Color macroProtein = Color(0xFF3C6E4F);
  static const Color macroFat = Color(0xFFC77B2E);
  static const Color macroCarb = Color(0xFF5B7A99);
  static const Color water = Color(0xFF2E86C7);
  static const Color waterCardBackground = Color(0xFFDCEEF7);

  static const Color tooltipBackground = Color(0xFF1C1C17);
  static const Color tooltipText = Color(0xFFFBFAF2);

  static const Color favoriteActiveBackground = Color(0xFFFBF3E8);
}
