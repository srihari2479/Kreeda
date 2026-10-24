import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Subtle Neumorphic and Material 3 elevation shadows for Kreeda.
class AppShadows {
  // Light Mode Subtle Neumorphism (Soft dual-layer specular & diffuse shadows)
  static const List<BoxShadow> neumorphicLight = [
    BoxShadow(
      color: Colors.white,
      offset: Offset(-3, -3),
      blurRadius: 7,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Color(0xFFD3DCE8),
      offset: Offset(3, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Dark Mode Subtle Neumorphism (Gleam highlight & deep stadium shadow)
  static const List<BoxShadow> neumorphicDark = [
    BoxShadow(
      color: Color(0xFF1C273E),
      offset: Offset(-2, -2),
      blurRadius: 5,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0xFF04070D),
      offset: Offset(3, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Dynamic Neumorphic Shadow depending on current theme context
  static List<BoxShadow> neumorphic(BuildContext context) {
    return AppColors.isDark(context) ? neumorphicDark : neumorphicLight;
  }

  // Active / Pressed Neumorphic State (Flat/inset feel)
  static List<BoxShadow> pressed(BuildContext context) {
    final isDark = AppColors.isDark(context);
    return [
      BoxShadow(
        color: isDark ? const Color(0xFF060911) : const Color(0xFFE2E8F0),
        offset: const Offset(1, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
    ];
  }

  // Floating Brand Glow (e.g. for Orange CTA buttons, Live badge)
  static List<BoxShadow> orangeGlow = [
    BoxShadow(
      color: AppColors.primaryOrange.withValues(alpha: 0.38),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Kreeda Pass Golden Glow
  static List<BoxShadow> goldGlow = [
    BoxShadow(
      color: AppColors.passGold.withValues(alpha: 0.35),
      offset: const Offset(0, 4),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];
}
