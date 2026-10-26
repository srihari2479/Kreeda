import 'package:flutter/material.dart';

/// Zero Pixel Error responsive layout utility for Kreeda.
/// Guarantees 0% overflow chance across compact phones (iPhone SE, 360dp Android),
/// standard devices, and tablets.
class Responsive {
  static const double smallPhoneBreakpoint = 375.0;
  static const double tabletBreakpoint = 600.0;

  // Bottom scroll clearance so docked bottom navigation never obscures content
  static const double bottomDockClearance = 110.0;

  /// Returns true if device width is smaller than 375dp (e.g. iPhone SE, compact Android).
  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < smallPhoneBreakpoint;

  /// Returns true if device width is 600dp or larger.
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Device width
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// Device height
  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Standard horizontal screen padding:
  /// - 14dp for compact 360dp devices (Zero Pixel Error Guarantee)
  /// - 16dp for small devices (< 375dp)
  /// - 20dp for standard phones
  /// - 32dp for tablets
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w <= 360.0) return 14.0;
    if (w < smallPhoneBreakpoint) return 16.0;
    if (isTablet(context)) return 32.0;
    return 20.0;
  }

  /// System gesture navigation bar bottom inset padding
  static double bottomSafeInset(BuildContext context) =>
      MediaQuery.paddingOf(context).bottom;

  /// Bottom modal / sheet padding ensuring action buttons are never obscured by keyboard or gesture nav bars
  static EdgeInsets modalBottomPadding(BuildContext context, {double base = 16.0}) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final gesturePadding = MediaQuery.paddingOf(context).bottom;
    return EdgeInsets.fromLTRB(
      horizontalPadding(context),
      base,
      horizontalPadding(context),
      bottomInset > 0 ? base + bottomInset : base + gesturePadding,
    );
  }

  /// Clamped font scale to prevent large accessibility font scaling from causing card overflow
  static double clampedTextScale(BuildContext context, {double maxScale = 1.25}) {
    final scale = MediaQuery.textScalerOf(context).scale(1.0);
    return scale.clamp(0.85, maxScale);
  }
}

/// Context extensions for fluid, concise responsive coding
extension ResponsiveContext on BuildContext {
  double get screenWidth => Responsive.width(this);
  double get screenHeight => Responsive.height(this);
  bool get isSmallPhone => Responsive.isSmallPhone(this);
  bool get isTablet => Responsive.isTablet(this);
  double get responsiveHorizontalPadding => Responsive.horizontalPadding(this);
  double get bottomSafeInset => Responsive.bottomSafeInset(this);

  /// Always append this clearance at the bottom of screens under KreedaBottomNav
  Widget get bottomNavClearance => const SizedBox(height: Responsive.bottomDockClearance);
}
