import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/cricket_mock_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/kreeda_button.dart';
import 'package:kreeda/features/auth/presentation/screens/login_screen.dart';
import 'package:kreeda/features/auth/presentation/screens/signup_screen.dart';

/// Comprehensive Player Profile & Cricket Resume Screen.
class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key});

  final profile = CricketMockData.playerProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          'CRICKETER RESUME',
          style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts_rounded),
            tooltip: 'Account & Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveHorizontalPadding,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Hero Player Profile Header Container
              _buildPlayerHeroHeader(context),

              const SizedBox(height: 12),

              // 2. Recent Form Guide Container
              _buildFormGuide(context),

              const SizedBox(height: 12),

              // 3. Career Metric Highlights (2x2 Container Grid)
              _buildCareerMetricsGrid(context),

              const SizedBox(height: 12),

              // 4. Batting Career Table Container
              _buildBattingTable(context),

              const SizedBox(height: 12),

              // 5. Bowling Career Table Container
              _buildBowlingTable(context),

              const SizedBox(height: 12),

              // 6. Milestone Awards & Badges Container
              _buildAwardsSection(context),

              const SizedBox(height: 12),

              // 7. Account Management & Switch Profile Container
              _buildAccountActions(context),

              // Bottom Dock clearance
              context.bottomNavClearance,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerHeroHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Row(
        children: [
          // Player Avatar with Jersey Number
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryOrange,
                    width: 2.2,
                  ),
                  boxShadow: AppShadows.orangeGlow,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'Assets/player_avatar_default.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primaryOrange,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.passGold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${profile.jerseyNumber}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Player Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    profile.teamName,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary(context),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${profile.role} • ${profile.battingStyle}',
                    style: AppTypography.caption(AppColors.textSecondary(context)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormGuide(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Row(
        children: [
          Text(
            'RECENT FORM:',
            style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: profile.recentInnings.map((score) {
                  final isBigScore = score.contains('1') || score.contains('8') || score.contains('6');
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isBigScore
                          ? AppColors.primaryOrange.withValues(alpha: 0.18)
                          : AppColors.surfaceElevated(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBigScore ? AppColors.primaryOrange.withValues(alpha: 0.6) : AppColors.border(context),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      score,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: isBigScore ? AppColors.primaryOrange : AppColors.textPrimary(context),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerMetricsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMetricTile(context, 'MATCHES', '${profile.matches}', 'All Formats')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricTile(context, 'TOTAL RUNS', '${profile.totalRuns}', 'SR ${profile.strikeRate}')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildMetricTile(context, 'BATTING AVG', '${profile.battingAverage}', 'HS: ${profile.highestScore}*')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricTile(context, '100s / 50s', '${profile.hundreds} / ${profile.fifties}', '80 Centuries')),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.caption(AppColors.textMuted(context))
                .copyWith(fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.scoreLarge(AppColors.textPrimary(context)).copyWith(fontSize: 22),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              sub,
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.primary(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattingTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports_cricket_rounded, size: 16, color: AppColors.primary(context)),
              const SizedBox(width: 6),
              Text(
                'BATTING CAREER STATS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: AppColors.primary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStatRow(context, 'Innings Played', '498'),
          _buildStatRow(context, 'Total Runs Scored', '${profile.totalRuns}'),
          _buildStatRow(context, 'Batting Average', '${profile.battingAverage}'),
          _buildStatRow(context, 'Strike Rate', '${profile.strikeRate}'),
          _buildStatRow(context, 'Highest Score', '${profile.highestScore}*'),
          _buildStatRow(context, 'Centuries (100s)', '${profile.hundreds}'),
          _buildStatRow(context, 'Half-Centuries (50s)', '${profile.fifties}', isLast: true),
        ],
      ),
    );
  }

  Widget _buildBowlingTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports_baseball_rounded, size: 16, color: AppColors.primary(context)),
              const SizedBox(width: 6),
              Text(
                'BOWLING CAREER STATS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: AppColors.primary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildStatRow(context, 'Wickets Taken', '${profile.wickets}'),
          _buildStatRow(context, 'Bowling Average', '${profile.bowlingAverage}'),
          _buildStatRow(context, 'Economy Rate', '${profile.economy}'),
          _buildStatRow(context, 'Best Bowling Figures', profile.bestBowling, isLast: true),
        ],
      ),
    );
  }

  Widget _buildAwardsSection(BuildContext context) {
    final awardDetails = [
      (
        title: 'ICC Player of the Decade',
        sub: 'Global ICC Cricket Award • Decade 2011–2020',
        asset: 'Assets/champions_trophy_gold.jpg',
        badgeColor: AppColors.passGold,
      ),
      (
        title: '2x ICC ODI Player of the Year',
        sub: 'World MVP Honors • 2017 & 2018',
        asset: 'Assets/kreeda_vip_pass_badge.jpg',
        badgeColor: const Color(0xFFF59E0B),
      ),
      (
        title: 'Most Centuries in ODI Cricket',
        sub: 'Historic All-Time Record • 50+ ODI Tons',
        asset: 'Assets/orange_cap_3d.jpg',
        badgeColor: AppColors.primaryOrange,
      ),
      (
        title: 'Padma Shri & Khel Ratna',
        sub: 'Highest Sporting & Civilian Honor of India',
        asset: 'Assets/ind_crest.jpg',
        badgeColor: const Color(0xFF3B82F6),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.military_tech_rounded, color: AppColors.passGold, size: 20),
              const SizedBox(width: 6),
              Text(
                'AWARDS & RECOGNITION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: AppColors.primary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...awardDetails.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    // 3D Award Badge
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: a.badgeColor, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: a.badgeColor.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          a.asset,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => Container(
                            color: a.badgeColor.withValues(alpha: 0.15),
                            child: Icon(Icons.emoji_events_rounded, color: a.badgeColor, size: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              a.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            a.sub,
                            style: AppTypography.caption(AppColors.textSecondary(context)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary(context),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(
            height: 0.5,
            color: AppColors.border(context).withValues(alpha: 0.25),
          ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          width: 0.8,
        ),
        boxShadow: AppShadows.neumorphic(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ACCOUNT & AUTHENTICATION',
                  style: AppTypography.titleMedium(AppColors.textPrimary(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.verified_user_rounded,
                size: 20,
                color: AppColors.primary(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Switch between cricketer profiles or log in to sync matches & scorer credentials.',
            style: AppTypography.bodySmall(AppColors.textSecondary(context)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: KreedaButton(
                  text: 'LOG IN / SWITCH',
                  icon: Icons.login_rounded,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KreedaButton(
                  text: 'NEW RESUME',
                  isSecondary: true,
                  icon: Icons.person_add_alt_1_rounded,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
