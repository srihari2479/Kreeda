import 'package:flutter/material.dart';

/// Central theme colors and dynamic tokens for Kreeda ("Cricket Lives Here").
/// Enforces 100% token-driven theming across the entire app with zero hardcoded colors.
class AppColors {
  // Brand Accents
  static const Color primaryOrange = Color(0xFFFF5500); // Energy Vermilion
  static const Color primaryOrangeLight = Color(0xFFFF661A);
  static const Color primaryNavy = Color(0xFF0A1128); // Stadium Navy

  // Cricket & Status Accents
  static const Color liveRed = Color(0xFFEF4444); // ((•)) LIVE badge
  static const Color pitchGreen = Color(0xFF10B981); // Turf Emerald Green
  static const Color passGold = Color(0xFFF59E0B); // Kreeda Pass Gold
  static const Color passGoldLight = Color(0xFFFBBF24);

  // Light Mode Tokens (Sports Ice Canvas)
  static const Color backgroundLight = Color(0xFFF8F9FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFF1F4F9);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFCBD5E1);
  static const Color activePillLight = Color(0xFFFFF2EC); // Warm peach tint

  // Dark Mode Tokens (Deep Stadium Midnight)
  static const Color backgroundDark = Color(0xFF0A0F1D);
  static const Color surfaceDark = Color(0xFF131B2E);
  static const Color surfaceElevatedDark = Color(0xFF1A243D);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textMutedDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF26334D);
  static const Color activePillDark = Color(0xFF2E1911); // Warm dark ember tint

  // Dynamic Theme State Helpers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // Dynamic Backgrounds & Surfaces
  static Color background(BuildContext context) =>
      isDark(context) ? backgroundDark : backgroundLight;

  static Color surface(BuildContext context) =>
      isDark(context) ? surfaceDark : surfaceLight;

  static Color surfaceElevated(BuildContext context) =>
      isDark(context) ? surfaceElevatedDark : surfaceElevatedLight;

  static Color activePill(BuildContext context) =>
      isDark(context) ? activePillDark : activePillLight;

  // Dynamic Typography
  static Color textPrimary(BuildContext context) =>
      isDark(context) ? textPrimaryDark : textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? textSecondaryDark : textSecondaryLight;

  static Color textMuted(BuildContext context) =>
      isDark(context) ? textMutedDark : textMutedLight;

  // Dynamic Outlines & Borders
  static Color border(BuildContext context) =>
      isDark(context) ? borderDark : borderLight;

  // Dynamic Brand Accents
  static Color primary(BuildContext context) =>
      isDark(context) ? primaryOrangeLight : primaryOrange;

  static Color primaryNavyAdaptive(BuildContext context) =>
      isDark(context) ? const Color(0xFFE2E8F0) : primaryNavy;

  // Dynamic Gradients
  static LinearGradient heroGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark(context)
          ? [Colors.transparent, const Color(0xDE0A0F1D), backgroundDark]
          : [Colors.transparent, const Color(0xB3000000), const Color(0xF00A1128)],
    );
  }

  static LinearGradient passBannerGradient(BuildContext context) {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF0F172A),
        Color(0xFF1E293B),
        Color(0xFFEA580C),
        primaryOrange,
      ],
      stops: [0.0, 0.40, 0.85, 1.0],
    );
  }
}
