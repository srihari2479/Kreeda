import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/cricket_mock_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/hero_match_card.dart';
import '../../../../core/widgets/kreeda_toast.dart';
import '../../../../core/widgets/section_divider_title.dart';
import '../../../../core/widgets/team_crest_avatar.dart';
import '../../../../core/widgets/upcoming_match_card.dart';
import 'package:kreeda/features/matches/presentation/screens/match_details_screen.dart';
import 'package:kreeda/features/profile/presentation/screens/player_profile_screen.dart';
import 'package:kreeda/features/scoring/presentation/screens/scoring_console_screen.dart';
import 'package:kreeda/features/series/domain/models/tournament_model.dart';
import 'package:kreeda/features/series/presentation/screens/tournament_details_screen.dart';

/// Full-Featured Kreeda Home Feed Screen Matching New Screenshot Design.
/// Engineered for 360dp smallest width with zero pixel overflow guarantee.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openMatchDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MatchDetailsScreen(),
      ),
    );
  }

  void _openTournamentDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TournamentDetailsScreen(),
      ),
    );
  }

  void _showTeamSquadModal(BuildContext context, AtbplTeamModel team) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: Responsive.modalBottomPadding(context, base: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TeamCrestAvatar(
                    teamCode: team.shortCode,
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.name,
                          style: AppTypography.headlineMedium(
                            AppColors.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${team.city} • Captain: ${team.captain}',
                          style: AppTypography.caption(
                            AppColors.textSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SectionDividerTitle(
                title: 'FRANCHISE DETAILS',
              ),
              const SizedBox(height: 8),
              Text(
                'Star Player: ${team.starPlayer}\nOwner: ${team.owner}\nTotal Squad: ${team.squadCount} registered players',
                style: AppTypography.bodySmall(AppColors.textPrimary(context)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(left: padding, right: padding, top: 4, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Live Match Card (Telugu Knight Riders vs Strikers)
            HeroMatchCard(
              onWatchLive: () => _openMatchDetails(context),
            ),

            const SizedBox(height: 14),

            // 2. 3 Quick Action Navigation Cards Row (Live Matches, Tournaments, My Team)
            _buildQuickNavCardsRow(context),

            const SizedBox(height: 18),

            // 3. Upcoming Matches Section
            _buildSectionHeader(
              context,
              title: 'Upcoming Matches',
              onSeeAll: () => _openTournamentDetails(context),
            ),
            const SizedBox(height: 8),
            _buildUpcomingMatchesList(context),

            const SizedBox(height: 18),

            // 4. All 8 ATBPL Teams Section
            _buildSectionHeader(
              context,
              title: 'All 8 ATBPL Teams',
              onSeeAll: () => _openTournamentDetails(context),
            ),
            const SizedBox(height: 8),
            _buildTeamsAvatarList(context),

            const SizedBox(height: 18),

            // 5. Tournaments Section
            _buildSectionHeader(
              context,
              title: 'Tournaments',
              onSeeAll: () => _openTournamentDetails(context),
            ),
            const SizedBox(height: 8),
            _buildTournamentsList(context),

            const SizedBox(height: 18),

            // 6. Latest Highlights Section
            _buildSectionHeader(
              context,
              title: 'Latest Highlights',
              onSeeAll: () => KreedaToast.showInfo(context, 'Loading ATBPL 2026 highlights feed...'),
            ),
            const SizedBox(height: 8),
            _buildHighlightsList(context),

            const SizedBox(height: 18),

            // 7. Featured Section (5 Pastel Tinted Action Cards)
            Text(
              'Featured',
              style: AppTypography.titleMedium(AppColors.textPrimary(context))
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            const SizedBox(height: 8),
            _buildFeaturedActionsList(context),

            // Bottom Dock Clearance (110dp)
            context.bottomNavClearance,
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // SECTION HEADER WITH 'SEE ALL >'
  // ----------------------------------------------------
  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.titleMedium(AppColors.textPrimary(context))
                .copyWith(fontWeight: FontWeight.w800, fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onSeeAll();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: Color(0xFF2563EB),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // 2. 3 QUICK ACTION NAVIGATION CARDS
  // ----------------------------------------------------
  Widget _buildQuickNavCardsRow(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        children: [
          // Card 1: Live Matches
          _buildQuickActionCard(
            context,
            icon: Icons.live_tv_rounded,
            iconBg: const Color(0xFFFF5500),
            title: 'Live Matches',
            subtitle: 'Scores & Stream',
            onTap: () => _openMatchDetails(context),
          ),
          const SizedBox(width: 8),

          // Card 2: Tournaments
          _buildQuickActionCard(
            context,
            icon: Icons.calendar_month_rounded,
            iconBg: const Color(0xFF2563EB),
            title: 'Tournaments',
            subtitle: 'Fixtures & Tables',
            onTap: () => _openTournamentDetails(context),
          ),
          const SizedBox(width: 8),

          // Card 3: My Team
          _buildQuickActionCard(
            context,
            icon: Icons.groups_rounded,
            iconBg: const Color(0xFF7C3AED),
            title: 'My Team',
            subtitle: 'Squad & Resume',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayerProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 154,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border(context),
            width: 0.8,
          ),
          boxShadow: AppShadows.neumorphic(context),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 1),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
                      style: AppTypography.caption(AppColors.textMuted(context))
                          .copyWith(fontSize: 9.0),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.chevron_right_rounded,
              size: 14,
              color: AppColors.textMuted(context),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // 3. UPCOMING MATCHES HORIZONTAL LIST
  // ----------------------------------------------------
  Widget _buildUpcomingMatchesList(BuildContext context) {
    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: CricketMockData.atbplUpcomingMatches.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final m = CricketMockData.atbplUpcomingMatches[index];

          return UpcomingMatchCard(
            date: m.date,
            time: m.time,
            team1: m.team1.shortCode,
            team2: m.team2.shortCode,
            team1Color: m.team1.primaryColor,
            team2Color: m.team2.primaryColor,
            team1Icon: m.team1.icon,
            team2Icon: m.team2.icon,
            series: m.stage,
            venue: m.venue,
            onTap: () => _openMatchDetails(context),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------
  // 4. ALL 8 ATBPL TEAMS CIRCLE AVATARS
  // ----------------------------------------------------
  Widget _buildTeamsAvatarList(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: CricketMockData.atbplTeams.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final team = CricketMockData.atbplTeams[index];

          return GestureDetector(
            onTap: () => _showTeamSquadModal(context, team),
            child: SizedBox(
              width: 66,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular Emblem with border ring
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: team.primaryColor.withValues(alpha: 0.6),
                        width: 1.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: (team.id == 'tkr' || team.shortCode == 'TKR')
                          ? Image.asset('Assets/tkr_crest.jpg', fit: BoxFit.cover)
                          : (team.id == 'ts' || team.shortCode == 'TS')
                              ? Image.asset('Assets/ts_crest.jpg', fit: BoxFit.cover)
                              : (team.id == 'cr' || team.shortCode == 'CR')
                                  ? Image.asset('Assets/cr_crest.jpg', fit: BoxFit.cover)
                                  : Container(
                                      color: team.primaryColor.withValues(alpha: 0.12),
                                      child: Icon(
                                        team.icon,
                                        color: team.primaryColor,
                                        size: 26,
                                      ),
                                    ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    team.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(context),
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------
  // 5. TOURNAMENTS HORIZONTAL CARDS
  // ----------------------------------------------------
  Widget _buildTournamentsList(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: CricketMockData.atbplTournaments.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final t = CricketMockData.atbplTournaments[index];
          final isDark = AppColors.isDark(context);

          return GestureDetector(
            onTap: () => _openTournamentDetails(context),
            child: Container(
              width: 175,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: t.isLive
                    ? (isDark ? const Color(0xFF231812) : const Color(0xFFFFF7ED))
                    : AppColors.surface(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: t.isLive
                      ? AppColors.primaryOrange
                      : AppColors.border(context),
                  width: 0.8,
                ),
                boxShadow: AppShadows.neumorphic(context),
              ),
              child: Row(
                children: [
                  // Trophy Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: t.badgeColor.withValues(alpha: 0.4)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.asset(
                        'Assets/champions_trophy_gold.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.emoji_events_rounded,
                          color: t.badgeColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.name,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${t.stage}\n${t.timeline}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary(context),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: t.badgeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            t.isLive ? '▶ LIVE >' : (t.status == 'UPCOMING' ? 'View Details >' : 'Coming Soon >'),
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: t.badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------
  // 6. LATEST HIGHLIGHTS (VIDEOS)
  // ----------------------------------------------------
  Widget _buildHighlightsList(BuildContext context) {
    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: CricketMockData.atbplHighlights.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final hl = CricketMockData.atbplHighlights[index];

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              KreedaToast.showInfo(context, 'Playing "${hl.title}"');
            },
            child: SizedBox(
              width: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 16:9 Thumbnail Box
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'Assets/stadium_daylight_banner.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF0F1E3E),
                            ),
                          ),
                          Container(
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                          Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.65),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                hl.duration,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hl.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    hl.timeAgo,
                    style: AppTypography.caption(AppColors.textMuted(context))
                        .copyWith(fontSize: 9.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------
  // 7. FEATURED PASTEL ACTION CARDS (5 ITEMS)
  // ----------------------------------------------------
  Widget _buildFeaturedActionsList(BuildContext context) {
    final actions = [
      {
        'title': 'Live Scoring',
        'subtitle': 'Score your match',
        'icon': Icons.bar_chart_rounded,
        'color': const Color(0xFF10B981),
        'bg': const Color(0xFFE8FDF3),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScoringConsoleScreen(),
            ),
          );
        },
      },
      {
        'title': 'Create Tournament',
        'subtitle': 'Manage fixtures',
        'icon': Icons.groups_rounded,
        'color': const Color(0xFF2563EB),
        'bg': const Color(0xFFEEF5FF),
        'onTap': () => _openTournamentDetails(context),
      },
      {
        'title': 'Player Stats',
        'subtitle': 'View rankings',
        'icon': Icons.person_rounded,
        'color': const Color(0xFFFF5500),
        'bg': const Color(0xFFFFF2EB),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlayerProfileScreen(),
            ),
          );
        },
      },
      {
        'title': 'Grounds',
        'subtitle': 'Find & book',
        'icon': Icons.place_rounded,
        'color': const Color(0xFF7C3AED),
        'bg': const Color(0xFFF5EFFF),
        'onTap': () {
          KreedaToast.showInfo(context, 'Visakhapatnam & ACA Grounds directory loaded');
        },
      },
      {
        'title': 'Fantasy',
        'subtitle': 'Play & Win',
        'icon': Icons.emoji_events_rounded,
        'color': const Color(0xFFE11D48),
        'bg': const Color(0xFFFEE8ED),
        'onTap': () {
          KreedaToast.showSuccess(context, 'ATBPL T10 Fantasy League active! Win cash prizes.');
        },
      },
    ];

    final isDark = AppColors.isDark(context);

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final act = actions[index];
          final color = act['color'] as Color;
          final lightBg = act['bg'] as Color;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              (act['onTap'] as VoidCallback)();
            },
            child: Container(
              width: 116,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? color.withValues(alpha: 0.12)
                    : lightBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withValues(alpha: 0.22),
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(act['icon'] as IconData, color: color, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    act['title'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    act['subtitle'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
