import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Complete Modern Material 3 ThemeData definition for Kreeda.
/// Globally integrates Bebas Neue for display/headline typography.
class AppTheme {
  // Light Theme (Material 3 + Subtle Neumorphism)
  static ThemeData get lightTheme {
    final bebasTheme = GoogleFonts.bebasNeueTextTheme();
    final interTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryOrange,
        onPrimary: Colors.white,
        secondary: AppColors.primaryNavy,
        onSecondary: Colors.white,
        error: AppColors.liveRed,
        onError: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.surfaceElevatedLight,
        outline: AppColors.borderLight,
      ),
      fontFamily: GoogleFonts.bebasNeue().fontFamily,
      textTheme: _buildTextTheme(
        bebasTheme: bebasTheme,
        interTheme: interTheme,
        primaryColor: AppColors.textPrimaryLight,
        secondaryColor: AppColors.textSecondaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 0.8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 0.8,
        space: 1,
      ),
    );
  }

  // Dark Theme (Material 3 Stadium Night)
  static ThemeData get darkTheme {
    final bebasTheme = GoogleFonts.bebasNeueTextTheme();
    final interTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryOrange,
        onPrimary: Colors.white,
        secondary: Color(0xFF1E293B),
        onSecondary: Colors.white,
        error: AppColors.liveRed,
        onError: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.surfaceElevatedDark,
        outline: AppColors.borderDark,
      ),
      fontFamily: GoogleFonts.bebasNeue().fontFamily,
      textTheme: _buildTextTheme(
        bebasTheme: bebasTheme,
        interTheme: interTheme,
        primaryColor: AppColors.textPrimaryDark,
        secondaryColor: AppColors.textSecondaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 0.8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 0.8,
        space: 1,
      ),
    );
  }

  // Hybrid Typography System: Bebas Neue for display/headlines, Inter for body
  static TextTheme _buildTextTheme({
    required TextTheme bebasTheme,
    required TextTheme interTheme,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      displayLarge: bebasTheme.displayLarge?.copyWith(
        color: primaryColor,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: bebasTheme.displayMedium?.copyWith(
        color: primaryColor,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: bebasTheme.displaySmall?.copyWith(
        color: primaryColor,
        letterSpacing: 1.0,
      ),
      headlineLarge: bebasTheme.headlineLarge?.copyWith(
        color: primaryColor,
        letterSpacing: 1.1,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: bebasTheme.headlineMedium?.copyWith(
        color: primaryColor,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: bebasTheme.headlineSmall?.copyWith(
        color: primaryColor,
        letterSpacing: 0.6,
      ),
      titleLarge: bebasTheme.titleLarge?.copyWith(
        color: primaryColor,
        letterSpacing: 0.8,
      ),
      titleMedium: interTheme.titleMedium?.copyWith(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: interTheme.titleSmall?.copyWith(
        color: secondaryColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: interTheme.bodyLarge?.copyWith(
        color: primaryColor,
      ),
      bodyMedium: interTheme.bodyMedium?.copyWith(
        color: secondaryColor,
      ),
      bodySmall: interTheme.bodySmall?.copyWith(
        color: secondaryColor,
      ),
      labelLarge: bebasTheme.labelLarge?.copyWith(
        color: primaryColor,
        letterSpacing: 1.2,
      ),
      labelMedium: interTheme.labelMedium?.copyWith(
        color: secondaryColor,
      ),
      labelSmall: interTheme.labelSmall?.copyWith(
        color: secondaryColor,
      ),
    );
  }
}
