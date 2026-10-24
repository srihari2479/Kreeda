import 'package:flutter/material.dart';

/// Global ValueNotifier for reactive Theme switching across the entire app.
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier([super.mode = ThemeMode.light]);

  bool get isDarkMode => value == ThemeMode.dark;

  void toggleTheme() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  void setTheme(ThemeMode mode) {
    value = mode;
  }

  void setThemeMode(ThemeMode mode) {
    value = mode;
  }
}

/// Global singleton theme notifier instance
final themeNotifier = ThemeNotifier();
