import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central Typography system for Kreeda.
/// Uses [Bebas Neue] globally for athletic display headlines, match scores,
/// badges, and banners, paired with [Inter] for crisp legible body text.
class AppTypography {
  // Bebas Neue base builder with offline/low-network fallback
  static TextStyle bebas({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 1.0,
    double? height,
  }) {
    return GoogleFonts.bebasNeue(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    ).copyWith(
      fontFamilyFallback: const ['Impact', 'Arial Black', 'sans-serif'],
    );
  }

  // Inter body builder with offline/low-network fallback
  static TextStyle bodyText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    ).copyWith(
      fontFamilyFallback: const ['Roboto', 'Segoe UI', 'Arial', 'sans-serif'],
    );
  }

  // Preset Athletic Display & Headline Styles (Bebas Neue)
  static TextStyle displayLarge(Color color) => bebas(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: color,
      );

  static TextStyle displayMedium(Color color) => bebas(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: color,
      );

  static TextStyle headlineLarge(Color color) => bebas(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        color: color,
      );

  static TextStyle headlineMedium(Color color) => bebas(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: color,
      );

  static TextStyle headlineSmall(Color color) => bebas(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: color,
      );

  // Cricket Match Specific Presets
  static TextStyle scoreLarge(Color color) => bebas(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: color,
      );

  static TextStyle teamCode(Color color) => bebas(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: color,
      );

  static TextStyle liveBadge(Color color) => bebas(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
        color: color,
      );

  static TextStyle buttonLabel(Color color) => bebas(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color,
      );

  static TextStyle button(Color color) => buttonLabel(color);

  // Body & Caption Presets (Inter)
  static TextStyle titleMedium(Color color) => bodyText(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleSmall(Color color) => bodyText(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyLarge(Color color) => bodyText(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.4,
      );

  static TextStyle bodyMedium(Color color) => bodyText(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.35,
      );

  static TextStyle bodySmall(Color color) => bodyText(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.35,
      );

  static TextStyle caption(Color color) => bodyText(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.2,
      );
}
