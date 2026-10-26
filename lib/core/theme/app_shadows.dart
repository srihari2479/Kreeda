import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ultra-soft, low-opacity tactile elevation and neumorphic surfaces for Kreeda.
/// Enforces feather-light, modern ambient diffuse shadows across the entire app.
class AppShadows {
  // Light Mode Ultra-Soft Neumorphism (Soft diffuse ambient drop + specular top highlight)
  static const List<BoxShadow> neumorphicLight = [
    BoxShadow(
      color: Colors.white,
      offset: Offset(-2, -2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0C0F172A), // Low-opacity soft ambient shadow (4.7% slate)
      offset: Offset(0, 3),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  // Dark Mode Ultra-Soft Neumorphism (Specular top edge gleam + soft deep stadium shadow)
  static const List<BoxShadow> neumorphicDark = [
    BoxShadow(
      color: Color(0x0DFFFFFF), // 5% specular top gleam
      offset: Offset(-1, -1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x38000000), // 22% soft deep ambient shadow
      offset: Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  // Dynamic Neumorphic Shadow depending on current theme context
  static List<BoxShadow> neumorphic(BuildContext context) {
    return AppColors.isDark(context) ? neumorphicDark : neumorphicLight;
  }

  // Active / Pressed Neumorphic State (Flat/inset gentle feel)
  static List<BoxShadow> pressed(BuildContext context) {
    final isDark = AppColors.isDark(context);
    return [
      BoxShadow(
        color: isDark ? const Color(0x26000000) : const Color(0x0A0F172A),
        offset: const Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ];
  }

  // Floating Brand Glow (Softened 22% alpha)
  static List<BoxShadow> orangeGlow = [
    BoxShadow(
      color: AppColors.primaryOrange.withValues(alpha: 0.22),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Kreeda Pass Golden Glow (Softened 20% alpha)
  static List<BoxShadow> goldGlow = [
    BoxShadow(
      color: AppColors.passGold.withValues(alpha: 0.20),
      offset: const Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];
}
