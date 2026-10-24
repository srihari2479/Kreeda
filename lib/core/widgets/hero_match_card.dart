import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Data model representing a featured hero match banner in the home carousel.
class HeroBannerMatch {
  final String stage;
  final String badgeText;
  final Color badgeColor;
  final String team1Name;
  final String team1Score;
  final String team1Overs;
  final String team1Crest;
  final Color team1GlowColor;
  final Color team1BorderColor;
  final String team2Name;
  final String team2Score;
  final String team2Overs;
  final String team2Crest;
  final Color team2GlowColor;
  final Color team2BorderColor;
  final String equation;
  final String ctaText;

  const HeroBannerMatch({
    required this.stage,
    required this.badgeText,
    required this.badgeColor,
    required this.team1Name,
    required this.team1Score,
    required this.team1Overs,
    required this.team1Crest,
    required this.team1GlowColor,
    required this.team1BorderColor,
    required this.team2Name,
    required this.team2Score,
    required this.team2Overs,
    required this.team2Crest,
    required this.team2GlowColor,
    required this.team2BorderColor,
    required this.equation,
    this.ctaText = 'Watch Live',
  });
}

/// Interactive 3-Banner Hero Match Carousel showcasing featured live matches.
/// Features stadium daylight backdrop, dynamic team atmospheric radial glows,
/// live scoreboards, match status equations, '▶ Watch Live' CTA button,
/// and smooth horizontal swiping with synchronized animated indicators.
class HeroMatchCard extends StatefulWidget {
  final VoidCallback? onWatchLive;

  const HeroMatchCard({super.key, this.onWatchLive});

  @override
  State<HeroMatchCard> createState() => _HeroMatchCardState();
}

class _HeroMatchCardState extends State<HeroMatchCard> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  static const List<HeroBannerMatch> _banners = [
    // Banner 1: Telugu Knight Riders vs Telugu Strikers (League Derby)
    HeroBannerMatch(
      stage: 'ATBPL T10 • LEAGUE STAGE',
      badgeText: 'LIVE',
      badgeColor: AppColors.liveRed,
      team1Name: 'TELUGU\nKNIGHT RIDERS',
      team1Score: '86/4',
      team1Overs: '(8.2)',
      team1Crest: 'Assets/tkr_crest.jpg',
      team1GlowColor: Color(0xFF6B21A8),
      team1BorderColor: Color(0xFFF59E0B),
      team2Name: 'TELUGU\nSTRIKERS',
      team2Score: '102/8',
      team2Overs: '(10.0)',
      team2Crest: 'Assets/ts_crest.jpg',
      team2GlowColor: Color(0xFF1D4ED8),
      team2BorderColor: AppColors.primaryOrange,
      equation: 'Knight Riders need 17 runs in 10 balls',
    ),
    // Banner 2: Coastal Riders vs Vizag Strikers (Super Over Thriller)
    HeroBannerMatch(
      stage: 'ATBPL T10 • MATCH 15 (SUPER OVER)',
      badgeText: 'LIVE',
      badgeColor: AppColors.liveRed,
      team1Name: 'COASTAL\nRIDERS',
      team1Score: '118/5',
      team1Overs: '(10.0)',
      team1Crest: 'Assets/cr_crest.jpg',
      team1GlowColor: Color(0xFF0284C7),
      team1BorderColor: Color(0xFF38BDF8),
      team2Name: 'VIZAG\nSTRIKERS',
      team2Score: '118/7',
      team2Overs: '(10.0)',
      team2Crest: 'Assets/vzs_crest.jpg',
      team2GlowColor: Color(0xFFD97706),
      team2BorderColor: Color(0xFFF59E0B),
      equation: 'Match Tied • Super Over in Progress!',
    ),
    // Banner 3: Godavari Kings vs Rayalaseema Royals (Royal Blockbuster)
    HeroBannerMatch(
      stage: 'ATBPL T10 • MATCH 16 DERBY',
      badgeText: 'LIVE',
      badgeColor: AppColors.liveRed,
      team1Name: 'GODAVARI\nKINGS',
      team1Score: '94/3',
      team1Overs: '(7.4)',
      team1Crest: 'Assets/gk_crest.jpg',
      team1GlowColor: Color(0xFFD97706),
      team1BorderColor: Color(0xFFF59E0B),
      team2Name: 'RAYALASEEMA\nROYALS',
      team2Score: '126/6',
      team2Overs: '(10.0)',
      team2Crest: 'Assets/rr_crest.jpg',
      team2GlowColor: Color(0xFFDC2626),
      team2BorderColor: Color(0xFFEF4444),
      equation: 'Godavari Kings need 33 runs in 14 balls',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return AspectRatio(
      aspectRatio: 16 / 10.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.border(context) : const Color(0xFFCBD5E1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0x180F172A),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.2),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Swipable Carousel PageView
              PageView.builder(
                controller: _pageController,
                itemCount: _banners.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _buildBannerSlide(_banners[index], isDark);
                },
              ),

              // 2. Synchronized Animated Carousel Indicator Dots
              Positioned(
                bottom: 7,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_banners.length, (i) {
                    final isActive = i == _currentPage;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _pageController.animateToPage(
                          i,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: isActive ? 16 : 5,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryOrange
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.4)
                                  : const Color(0xFF94A3B8).withValues(alpha: 0.6)),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlide(HeroBannerMatch banner, bool isDark) {
    // Theme-responsive color palette for Hero Match Banner:
    // Dark Theme: Deep Stadium Midnight with glowing floodlight aura and crisp white typography.
    // Light Theme: Sunlit Sports Turf Canvas with clean white/glass scrim, deep slate navy typography,
    // and team-tinted atmospheric glows.
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark ? Colors.white.withValues(alpha: 0.75) : AppColors.textSecondaryLight;
    final mutedTextColor = isDark ? Colors.white.withValues(alpha: 0.5) : AppColors.textMutedLight;
    final stageTextColor = isDark ? Colors.white.withValues(alpha: 0.85) : AppColors.textSecondaryLight;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Stadium daylight background
        Image.asset(
          'Assets/stadium_daylight_banner.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: isDark ? const Color(0xFF0F1E3E) : const Color(0xFFE2E8F0),
          ),
        ),

        // Theme-responsive stadium contrast scrim
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF050B18).withValues(alpha: 0.88),
                      const Color(0xFF0A142A).withValues(alpha: 0.82),
                      const Color(0xFF0F1E3E).withValues(alpha: 0.75),
                      const Color(0xFF050B18).withValues(alpha: 0.88),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.94),
                      const Color(0xFFF8FAFC).withValues(alpha: 0.88),
                      const Color(0xFFF1F5F9).withValues(alpha: 0.85),
                      Colors.white.withValues(alpha: 0.94),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Left atmospheric glow (Team 1)
        Positioned(
          top: 0,
          bottom: 0,
          left: -20,
          width: 140,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.centerLeft,
                radius: 0.9,
                colors: [
                  banner.team1GlowColor.withValues(alpha: isDark ? 0.45 : 0.16),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Right atmospheric glow (Team 2)
        Positioned(
          top: 0,
          bottom: 0,
          right: -20,
          width: 140,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.centerRight,
                radius: 0.9,
                colors: [
                  banner.team2GlowColor.withValues(alpha: isDark ? 0.45 : 0.16),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Content Stack
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Bar: ((•)) LIVE badge and Stage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live Broadcasting Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: banner.badgeColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: banner.badgeColor.withValues(alpha: 0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sensors_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          banner.badgeText,
                          style: AppTypography.liveBadge(Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Tournament Stage Subtitle
                  Flexible(
                    child: Text(
                      banner.stage,
                      style: AppTypography.caption(stageTextColor)
                          .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.6),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Middle Scoreboard & Team Crests
              Row(
                children: [
                  // Left Team
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: banner.team1BorderColor, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.35)
                                    : banner.team1GlowColor.withValues(alpha: 0.25),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              banner.team1Crest,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Icon(
                                Icons.shield_rounded,
                                color: banner.team1BorderColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            banner.team1Name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: primaryTextColor,
                              height: 1.15,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center: Score & Equation
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    banner.team1Score,
                                    style: AppTypography.scoreLarge(primaryTextColor)
                                        .copyWith(fontSize: 24),
                                  ),
                                  Text(
                                    banner.team1Overs,
                                    style: AppTypography.caption(secondaryTextColor)
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'VS',
                                  style: AppTypography.caption(mutedTextColor)
                                      .copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    banner.team2Score,
                                    style: AppTypography.scoreLarge(primaryTextColor)
                                        .copyWith(fontSize: 24),
                                  ),
                                  Text(
                                    banner.team2Overs,
                                    style: AppTypography.caption(secondaryTextColor)
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.35)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : const Color(0xFFCBD5E1),
                              width: 0.8,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              banner.equation,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: primaryTextColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Team
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: banner.team2BorderColor, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.35)
                                    : banner.team2GlowColor.withValues(alpha: 0.25),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              banner.team2Crest,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, st) => Icon(
                                Icons.flash_on_rounded,
                                color: banner.team2BorderColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            banner.team2Name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: primaryTextColor,
                              height: 1.15,
                              letterSpacing: 0.4,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom: '▶ Watch Live' CTA Button (spaced for indicator dots)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (widget.onWatchLive != null) widget.onWatchLive!();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6600), AppColors.primaryOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withValues(alpha: isDark ? 0.45 : 0.32),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          banner.ctaText,
                          style: AppTypography.button(Colors.white)
                              .copyWith(fontSize: 13, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
