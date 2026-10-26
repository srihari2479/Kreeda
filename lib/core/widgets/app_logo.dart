import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Supported aspect ratios and display modes for the official Kreeda brand logo.
enum AppLogoRatio {
  /// 4:1 (3:1 cropped) horizontal logo for Top App Header, navigation bars, and compact toolbars.
  header,

  /// 2:1 large showcase logo with 'KREEDA - CRICKET LIVES HERE' for Welcome / Auth / Splash showcases.
  welcomeShowcase,
}

/// Central Official Brand Logo Widget for Kreeda.
/// Dynamically selects between:
/// - **4:1 Header Ratio** (`Assets/4_1_ratio.png` / `Assets/4_1_ratio_dark.png`) for Top App Bars & Navbars.
/// - **2:1 Welcome Showcase Ratio** (`Assets/2_1_ratio.png` / `Assets/2_1_ratio_dark.png`) for Welcome & Auth hero displays.
/// Implements automatic cross-theme contrast parity: crisp Stadium Navy letters in Light Mode,
/// and radiant metallic silver-white chrome letters in Dark Mode.
class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final AppLogoRatio ratio;
  final bool showTagline;
  final bool useWordmark;
  final BoxFit fit;

  /// Default constructor (defaults to 4:1 header format).
  const AppLogo({
    super.key,
    this.height = 28.0,
    this.width,
    this.ratio = AppLogoRatio.header,
    this.showTagline = false,
    this.useWordmark = false,
    this.fit = BoxFit.contain,
  });

  /// Specialized constructor for Top App Header / Navbar (4:1 horizontal ratio).
  const AppLogo.header({
    super.key,
    this.height = 28.0,
    this.width,
    this.fit = BoxFit.contain,
  })  : ratio = AppLogoRatio.header,
        showTagline = false,
        useWordmark = false;

  /// Specialized constructor for Welcome Showcase screens (2:1 hero banner ratio).
  const AppLogo.welcomeShowcase({
    super.key,
    this.width = 220.0,
    this.height,
    this.fit = BoxFit.contain,
  })  : ratio = AppLogoRatio.welcomeShowcase,
        showTagline = true,
        useWordmark = false;

  @override
  Widget build(BuildContext context) {
    if (useWordmark) {
      return _buildVectorFallback(context);
    }

    final isDark = AppColors.isDark(context);

    // Select the appropriate asset based on ratio and theme
    final String assetPath;
    final double? targetWidth;
    final double? targetHeight;

    switch (ratio) {
      case AppLogoRatio.header:
        assetPath = isDark ? 'Assets/4_1_ratio_dark.png' : 'Assets/4_1_ratio.png';
        targetHeight = height ?? 28.0;
        targetWidth = width ?? (targetHeight * 3.0);
        break;
      case AppLogoRatio.welcomeShowcase:
        assetPath = isDark ? 'Assets/2_1_ratio_dark.png' : 'Assets/2_1_ratio.png';
        targetWidth = width ?? 220.0;
        targetHeight = height ?? (targetWidth / 2.0);
        break;
    }

    return SizedBox(
      width: targetWidth,
      height: targetHeight,
      child: Image.asset(
        assetPath,
        width: targetWidth,
        height: targetHeight,
        fit: fit,
        filterQuality: FilterQuality.high,
        errorBuilder: (context, error, stackTrace) {
          // If dark variant fails, attempt primary asset, then vector fallback
          final fallbackPath = ratio == AppLogoRatio.header
              ? 'Assets/4_1_ratio.png'
              : 'Assets/2_1_ratio.png';
          return Image.asset(
            fallbackPath,
            width: targetWidth,
            height: targetHeight,
            fit: fit,
            filterQuality: FilterQuality.high,
            errorBuilder: (ctx, err, stackTrace) => _buildVectorFallback(context),
          );
        },
      ),
    );
  }

  /// High-impact vector wordmark fallback combining the energetic flame 'K'
  /// emblem with Bebas Neue typography.
  Widget _buildVectorFallback(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final fallbackHeight = height ?? 28.0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stylized energetic flame 'K' emblem
          Container(
            width: fallbackHeight * 0.85,
            height: fallbackHeight * 0.85,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A00), AppColors.primaryOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(fallbackHeight * 0.22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.20),
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'K',
              style: AppTypography.bebas(
                fontSize: fallbackHeight * 0.62,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KREEDA',
                style: AppTypography.bebas(
                  fontSize: fallbackHeight * 0.66,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.6,
                  color: isDark ? Colors.white : AppColors.primaryNavy,
                ),
              ),
              if (showTagline)
                Text(
                  'CRICKET LIVES HERE',
                  style: TextStyle(
                    fontSize: fallbackHeight * 0.22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary(context),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
