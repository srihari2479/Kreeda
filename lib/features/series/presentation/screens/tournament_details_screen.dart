import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/cricket_mock_data.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/kreeda_button.dart';
import '../../../../core/widgets/kreeda_toast.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../../core/widgets/section_divider_title.dart';
import '../../../../core/widgets/team_crest_avatar.dart';
import '../../domain/models/tournament_model.dart';
import 'package:kreeda/features/matches/presentation/screens/match_details_screen.dart';

/// Comprehensive CricHeroes-Style Tournament Hub Screen.
/// Features Overview, Fixtures, Points Table with NRR, Teams & Squads,
/// Leaderboards (Orange/Purple Caps), and Venue/Rules.
class TournamentDetailsScreen extends StatefulWidget {
  final String tournamentId;

  const TournamentDetailsScreen({
    super.key,
    this.tournamentId = 'atbpl-t10-league',
  });

  @override
  State<TournamentDetailsScreen> createState() => _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState extends State<TournamentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFollowing = false;
  String _selectedStageFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                          '${team.city} • Owner: ${team.owner}',
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
              SectionDividerTitle(
                title: 'OFFICIAL SQUAD (${team.squadCount} PLAYERS)',
              ),
              const SizedBox(height: 8),
              NeumorphicContainer(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                borderRadius: 14.0,
                child: Column(
                  children: [
                    _buildSquadRow(context, team.captain, 'Captain & Batter', true),
                    _buildHairlineDivider(context),
                    _buildSquadRow(context, team.starPlayer, 'Star All-Rounder', false),
                    _buildHairlineDivider(context),
                    _buildSquadRow(context, 'R. Koushik', 'Fast Bowler (140+ km/h)', false),
                    _buildHairlineDivider(context),
                    _buildSquadRow(context, 'M. Bharath', 'Wicketkeeper Batter', false),
                    _buildHairlineDivider(context),
                    _buildSquadRow(context, 'S. Venkat', 'Off-Break Spinner', false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              KreedaButton(
                text: 'VIEW FULL TEAM PROFILE',
                isSecondary: true,
                onPressed: () => Navigator.pop(ctx),
                height: 44,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSquadRow(
    BuildContext context,
    String name,
    String role,
    bool isCaptain,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isCaptain ? AppColors.passGold : AppColors.primary(context),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: isCaptain ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        Text(
          role,
          style: AppTypography.caption(AppColors.textSecondary(context)),
        ),
      ],
    );
  }

  Widget _buildHairlineDivider(BuildContext context) {
    return Container(
      height: 0.5,
      color: AppColors.border(context).withValues(alpha: 0.35),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 1. App Bar
              SliverAppBar(
                backgroundColor: AppColors.surface(context),
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary(context),
                    size: 20,
                  ),
                ),
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ATBPL T10 TOURNAMENT',
                    style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() => _isFollowing = !_isFollowing);
                      KreedaToast.showSuccess(
                        context,
                        _isFollowing
                            ? 'Following ATBPL T10 Tournament'
                            : 'Unfollowed tournament',
                      );
                    },
                    icon: Icon(
                      _isFollowing ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: _isFollowing ? AppColors.primaryOrange : AppColors.textPrimary(context),
                    ),
                    tooltip: 'Follow Tournament',
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      KreedaToast.showInfo(context, 'Tournament link copied!');
                    },
                    icon: Icon(
                      Icons.share_rounded,
                      color: AppColors.textPrimary(context),
                      size: 20,
                    ),
                    tooltip: 'Share Tournament',
                  ),
                ],
              ),

              // 2. Tournament Hero Showcase Banner
              SliverToBoxAdapter(
                child: _buildHeroTournamentCard(context),
              ),

              // 3. Tab Bar Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary(context),
                    unselectedLabelColor: AppColors.textSecondary(context),
                    indicatorColor: AppColors.primary(context),
                    indicatorWeight: 3.0,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    tabs: const [
                      Tab(text: 'OVERVIEW'),
                      Tab(text: 'FIXTURES'),
                      Tab(text: 'POINTS TABLE'),
                      Tab(text: 'ALL 8 TEAMS'),
                      Tab(text: 'LEADERBOARD'),
                      Tab(text: 'VENUES & RULES'),
                    ],
                  ),
                  color: AppColors.surface(context),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context),
              _buildFixturesTab(context),
              _buildPointsTableTab(context),
              _buildTeamsTab(context),
              _buildLeaderboardsTab(context),
              _buildVenuesTab(context),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // HERO TOURNAMENT CARD
  // ----------------------------------------------------
  Widget _buildHeroTournamentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border(context).withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 3D Champions Trophy
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.passGold, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.passGold.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'Assets/champions_trophy_gold.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.emoji_events_rounded,
                      color: AppColors.passGold,
                      size: 32,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Tournament Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.liveRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'LIVE TOURNAMENT',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'EDITION 2026',
                            style: AppTypography.caption(AppColors.textMuted(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ATBPL T10 - LEAGUE STAGE',
                      style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dr. Y.S. Rajasekhara Reddy ACA Stadium, Visakhapatnam',
                        style: AppTypography.caption(AppColors.textSecondary(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 4 Key Stats Pills
          Row(
            children: [
              _buildStatPill(context, '8 TEAMS', Icons.groups_rounded, const Color(0xFF3B82F6)),
              const SizedBox(width: 6),
              _buildStatPill(context, '28 MATCHES', Icons.sports_cricket_rounded, const Color(0xFF10B981)),
              const SizedBox(width: 6),
              _buildStatPill(context, '₹5,00,000 PRIZE', Icons.military_tech_rounded, AppColors.passGold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(BuildContext context, String text, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // TAB 1: OVERVIEW
  // ----------------------------------------------------
  Widget _buildOverviewTab(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Live Match Snippet
          const SectionDividerTitle(
            title: 'MATCH OF THE DAY (LIVE)',
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchDetailsScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border(context),
                  width: 1,
                ),
                boxShadow: AppShadows.neumorphic(context),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: AppColors.liveRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '((•)) LIVE NOW',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'ATBPL T10 • MATCH 14',
                          style: AppTypography.caption(AppColors.textSecondary(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Middle Scoreboard & Team Crests matching Image 2
                  Row(
                    children: [
                      // Left: Telugu Knight Riders
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TeamCrestAvatar(
                              teamCode: 'TKR',
                              size: 44,
                              borderColor: Color(0xFFF59E0B),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'TELUGU\nKNIGHT RIDERS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary(context),
                                  height: 1.15,
                                  letterSpacing: 0.4,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center: Score & Equation Pill
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
                                        '86/4',
                                        style: AppTypography.scoreLarge(AppColors.primary(context))
                                            .copyWith(fontSize: 22, fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        '(8.2)',
                                        style: AppTypography.caption(
                                          AppColors.textSecondary(context),
                                        ).copyWith(fontSize: 10.5, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceElevated(context),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.border(context),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Text(
                                        'VS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textMuted(context),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '102/8',
                                        style: AppTypography.scoreLarge(AppColors.textPrimary(context))
                                            .copyWith(fontSize: 22, fontWeight: FontWeight.w900),
                                      ),
                                      Text(
                                        '(10.0)',
                                        style: AppTypography.caption(
                                          AppColors.textSecondary(context),
                                        ).copyWith(fontSize: 10.5, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated(context),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.border(context),
                                  width: 0.8,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Knight Riders need 17 runs in 10 balls',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary(context),
                                    letterSpacing: 0.2,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right: Telugu Strikers
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TeamCrestAvatar(
                              teamCode: 'TS',
                              size: 44,
                              borderColor: AppColors.primaryOrange,
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'TELUGU\nSTRIKERS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary(context),
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
                  const SizedBox(height: 12),
                  KreedaButton(
                    text: 'WATCH LIVE MATCH CENTER >',
                    height: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tournament Information Table
          const SectionDividerTitle(
            title: 'TOURNAMENT SPECIFICATIONS',
          ),
          const SizedBox(height: 8),
          NeumorphicContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            borderRadius: 14.0,
            child: Column(
              children: [
                _buildSpecRow(context, 'Format', 'T10 (10 Overs per side)'),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildSpecRow(context, 'Ball Type', 'Hard Tennis / Leather Match Ball'),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildSpecRow(context, 'Total Teams', '8 Regional Franchises'),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildSpecRow(context, 'Playoff Qualification', 'Top 4 advance to Playoffs'),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildSpecRow(context, 'Primary Stadium', 'Dr. Y.S. Rajasekhara Reddy ACA Stadium'),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildSpecRow(context, 'Governing Body', 'Andhra Premier Board & Kreeda Live'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Official Sponsors & Partners
          SectionDividerTitle(
            title: 'OFFICIAL PARTNERS',
            color: AppColors.textSecondary(context),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPartnerBadge(context, 'KREEDA PASS', AppColors.passGold),
              const SizedBox(width: 8),
              _buildPartnerBadge(context, 'ACA CRICKET', const Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              _buildPartnerBadge(context, 'VIZAG SPORTS', const Color(0xFF10B981)),
            ],
          ),

          context.bottomNavClearance,
        ],
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: AppTypography.bodySmall(AppColors.textSecondary(context)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            val,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerBadge(BuildContext context, String title, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // TAB 2: FIXTURES & SCHEDULE
  // ----------------------------------------------------
  Widget _buildFixturesTab(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;
    final stages = ['All', 'League Stage', 'Playoffs', 'Finals'];

    return Column(
      children: [
        // Stage Filter Pills
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: stages.map((stage) {
                final isSel = _selectedStageFilter == stage;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(stage),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                      color: isSel ? Colors.white : AppColors.textPrimary(context),
                    ),
                    selected: isSel,
                    selectedColor: AppColors.primaryOrange,
                    backgroundColor: AppColors.surfaceElevated(context),
                    onSelected: (val) {
                      if (val) setState(() => _selectedStageFilter = stage);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Fixtures List
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
            itemCount: CricketMockData.atbplUpcomingMatches.length,
            itemBuilder: (context, index) {
              final match = CricketMockData.atbplUpcomingMatches[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeumorphicContainer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MatchDetailsScreen(),
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(12),
                  borderRadius: 14.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${match.date} • ${match.time}',
                            style: AppTypography.caption(AppColors.primary(context))
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated(context),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border(context)),
                            ),
                            child: Text(
                              match.stage,
                              style: AppTypography.caption(AppColors.textSecondary(context))
                                  .copyWith(fontWeight: FontWeight.w700, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Team 1
                          Expanded(
                            child: Row(
                              children: [
                                TeamCrestAvatar(
                                  teamCode: match.team1.shortCode,
                                  size: 26,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    match.team1.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                      color: AppColors.textPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceElevated(context),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textMuted(context),
                                ),
                              ),
                            ),
                          ),
                          // Team 2
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    match.team2.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12.5,
                                      color: AppColors.textPrimary(context),
                                    ),
                                    textAlign: TextAlign.end,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TeamCrestAvatar(
                                  teamCode: match.team2.shortCode,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textMuted(context),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              match.venue,
                              style: AppTypography.caption(AppColors.textMuted(context)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // TAB 3: POINTS TABLE (CRICHEROES STYLE WITH NRR)
  // ----------------------------------------------------
  Widget _buildPointsTableTab(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'STANDINGS & NET RUN RATE (NRR)',
                  style: AppTypography.caption(AppColors.primary(context))
                      .copyWith(fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Top 4 Qualify',
                    style: AppTypography.caption(AppColors.textSecondary(context)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Points Table in Neumorphic Container
          NeumorphicContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            borderRadius: 14.0,
            child: Column(
              children: [
                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 22, child: Text('#', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      const Expanded(flex: 3, child: Text('TEAM', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      const Expanded(flex: 1, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      const Expanded(flex: 1, child: Text('W', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      const Expanded(flex: 1, child: Text('L', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      const Expanded(flex: 2, child: Text('NRR', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      const Expanded(flex: 2, child: Text('PTS', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11))),
                    ],
                  ),
                ),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                ),

                // Table Rows
                ...List.generate(CricketMockData.atbplPointsTable.length, (i) {
                  final row = CricketMockData.atbplPointsTable[i];
                  final isCutoff = i == 3; // Line after 4th team

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        color: row.isQualified
                            ? const Color(0xFF10B981).withValues(alpha: 0.05)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: Text(
                                '${row.rank}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: row.isQualified ? const Color(0xFF10B981) : AppColors.textPrimary(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  TeamCrestAvatar(
                                    teamCode: row.teamCode,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      row.teamCode,
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 1, child: Text('${row.played}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                            Expanded(flex: 1, child: Text('${row.won}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
                            Expanded(flex: 1, child: Text('${row.lost}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                            Expanded(
                              flex: 2,
                              child: Text(
                                (row.netRunRate >= 0 ? '+${row.netRunRate.toStringAsFixed(3)}' : row.netRunRate.toStringAsFixed(3)),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: row.netRunRate >= 0 ? const Color(0xFF10B981) : AppColors.liveRed,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${row.points}',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary(context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isCutoff)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Text(
                              '--------- PLAYOFF QUALIFICATION CUTOFF ---------',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF10B981), letterSpacing: 0.6),
                            ),
                          ),
                        )
                      else if (i < CricketMockData.atbplPointsTable.length - 1)
                        Container(
                          height: 1.0,
                          color: AppColors.border(context),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),

          context.bottomNavClearance,
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // TAB 4: ALL 8 TEAMS
  // ----------------------------------------------------
  Widget _buildTeamsTab(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      itemCount: CricketMockData.atbplTeams.length,
      itemBuilder: (context, index) {
        final team = CricketMockData.atbplTeams[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: NeumorphicContainer(
            onTap: () => _showTeamSquadModal(context, team),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            borderRadius: 14.0,
            child: Row(
              children: [
                TeamCrestAvatar(
                  teamCode: team.shortCode,
                  size: 46,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: AppTypography.titleMedium(AppColors.textPrimary(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${team.city} • Captain: ${team.captain}',
                        style: AppTypography.caption(AppColors.textSecondary(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Star: ${team.starPlayer} • ${team.squadCount} Squad Players',
                        style: AppTypography.caption(AppColors.primary(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: AppColors.textMuted(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------
  // TAB 5: LEADERBOARDS & STATS (CAPS)
  // ----------------------------------------------------
  Widget _buildLeaderboardsTab(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      itemCount: CricketMockData.atbplLeaderboards.length,
      itemBuilder: (context, index) {
        final leader = CricketMockData.atbplLeaderboards[index];

        // Parse primaryStat e.g. "284 Runs" -> "284" and "RUNS"
        final statParts = leader.primaryStat.split(' ');
        final statNumber = statParts.isNotEmpty ? statParts[0] : leader.primaryStat;
        final statUnit = statParts.length > 1 ? statParts.sublist(1).join(' ').toUpperCase() : '';

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: NeumorphicContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            borderRadius: 14.0,
            child: Row(
              children: [
                // 3D Cap Award Icon with Rank Badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: leader.capColor.withValues(alpha: 0.1),
                        border: Border.all(color: leader.capColor.withValues(alpha: 0.4), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: leader.capColor.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          leader.capType.toUpperCase().contains('ORANGE')
                              ? 'Assets/orange_cap_3d.jpg'
                              : 'Assets/purple_cap_3d.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) => Container(
                            color: leader.capColor.withValues(alpha: 0.15),
                            child: Icon(Icons.sports_baseball_rounded, color: leader.capColor, size: 22),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: leader.capColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.surface(context), width: 1.5),
                        ),
                        child: Text(
                          '#${leader.rank}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Player Info & Secondary Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: leader.capColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: leader.capColor.withValues(alpha: 0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          leader.capType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            color: leader.capColor,
                            letterSpacing: 0.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Player Name + Team Pill
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              leader.playerName,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated(context),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.border(context)),
                            ),
                            child: Text(
                              leader.teamCode,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Secondary Stats
                      Text(
                        leader.secondaryStat,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Dedicated High-Impact Stat Callout Badge
                Container(
                  constraints: const BoxConstraints(minWidth: 54),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: leader.capColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: leader.capColor.withValues(alpha: 0.25),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        statNumber,
                        style: AppTypography.displayLarge(leader.capColor).copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      if (statUnit.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          statUnit,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                            color: leader.capColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------
  // TAB 6: VENUES & RULES
  // ----------------------------------------------------
  Widget _buildVenuesTab(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionDividerTitle(
            title: 'HOST VENUE & STADIUM',
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'Assets/stadium_daylight_banner.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.50),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ACA-VDCA STADIUM • VISAKHAPATNAM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium',
            style: AppTypography.titleMedium(AppColors.textPrimary(context)),
          ),
          const SizedBox(height: 4),
          Text(
            'PM Palem, Visakhapatnam, Andhra Pradesh 530041',
            style: AppTypography.caption(AppColors.textSecondary(context)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildVenueSpec(context, 'CAPACITY', '27,500'),
              _buildVenueSpec(context, 'BOUNDARIES', '65m - 72m'),
              _buildVenueSpec(context, 'PITCH TYPE', 'Batting Paradise'),
            ],
          ),

          const SizedBox(height: 20),

          const SectionDividerTitle(
            title: 'T10 TOURNAMENT PLAYING REGULATIONS',
          ),
          const SizedBox(height: 8),
          NeumorphicContainer(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            borderRadius: 14.0,
            child: Column(
              children: [
                _buildRuleRow(
                  context,
                  num: '1',
                  title: 'MATCH DURATION & OVERS',
                  rule: '10 Overs Maximum per innings • Strict 45 minutes match duration.',
                  icon: Icons.timer_rounded,
                  color: AppColors.primaryOrange,
                ),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildRuleRow(
                  context,
                  num: '2',
                  title: 'BOWLER QUOTA',
                  rule: 'Maximum of 2 overs per individual bowler per innings.',
                  icon: Icons.sports_cricket_rounded,
                  color: const Color(0xFF3B82F6),
                ),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildRuleRow(
                  context,
                  num: '3',
                  title: 'POWERPLAY RESTRICTIONS',
                  rule: 'Overs 1–3: Maximum 2 fielders allowed outside 30-yard inner circle.',
                  icon: Icons.radar_rounded,
                  color: const Color(0xFF10B981),
                ),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildRuleRow(
                  context,
                  num: '4',
                  title: 'SUPER OVER TIE-BREAKER',
                  rule: 'One-over Eliminator Super Over played in event of a tied match score.',
                  icon: Icons.military_tech_rounded,
                  color: AppColors.passGold,
                ),
                Container(
                  height: 1.0,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                _buildRuleRow(
                  context,
                  num: '5',
                  title: 'NO-BALL & FREE HIT',
                  rule: 'Standard ICC T10 White Ball No-Ball Free Hit rules strictly enforced.',
                  icon: Icons.sports_baseball_rounded,
                  color: const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),

          context.bottomNavClearance,
        ],
      ),
    );
  }

  Widget _buildVenueSpec(BuildContext context, String label, String val) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: AppTypography.caption(AppColors.textMuted(context))),
          const SizedBox(height: 2),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(
    BuildContext context, {
    required String num,
    required String title,
    required String rule,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                rule,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color color;

  _SliverTabBarDelegate(this._tabBar, {required this.color});

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: color,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
