import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/cricket_mock_data.dart';
import '../../../../core/utils/responsive.dart';
import 'package:kreeda/features/matches/presentation/screens/match_details_screen.dart';
import 'tournament_details_screen.dart';

/// Tournament & Series Hub Screen with Points Table, Fixtures, and Leaderboards.
class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          'SERIES & TOURNAMENTS',
          style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Tournament Banner Selector
            _buildTournamentSelector(context),

            // 2. Tab Bar Header
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                border: Border(
                  bottom: BorderSide(color: AppColors.border(context), width: 1.0),
                ),
              ),
              child: TabBar(
                controller: _tabCtrl,
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
                  Tab(text: 'POINTS TABLE'),
                  Tab(text: 'FIXTURES'),
                  Tab(text: 'LEADERBOARD'),
                ],
              ),
            ),

            // 3. Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildPointsTableTab(context),
                  _buildFixturesTab(context),
                  _buildLeaderboardTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHairlineDivider(BuildContext context) {
    return Container(
      height: 0.5,
      color: AppColors.border(context).withValues(alpha: 0.35),
    );
  }

  Widget _buildTournamentSelector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TournamentDetailsScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: context.responsiveHorizontalPadding,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          border: Border(
            bottom: BorderSide(
              color: AppColors.border(context).withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.passGold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.passGold.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.5),
                child: Image.asset(
                  'Assets/champions_trophy_gold.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.emoji_events_rounded,
                    color: AppColors.passGold,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INDIA TOUR OF AUSTRALIA 2026',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Super 6 Stage • 5 Matches Played',
                    style: AppTypography.caption(AppColors.textSecondary(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary(context),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1: Points Table
  Widget _buildPointsTableTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveHorizontalPadding,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SizedBox(width: 24, child: Text('#', style: AppTypography.caption(AppColors.textMuted(context)))),
                Expanded(flex: 4, child: Text('TEAM', style: AppTypography.caption(AppColors.textMuted(context)))),
                Expanded(flex: 1, child: Text('P', textAlign: TextAlign.center, style: AppTypography.caption(AppColors.textMuted(context)))),
                Expanded(flex: 1, child: Text('W', textAlign: TextAlign.center, style: AppTypography.caption(AppColors.textMuted(context)))),
                Expanded(flex: 1, child: Text('L', textAlign: TextAlign.center, style: AppTypography.caption(AppColors.textMuted(context)))),
                Expanded(flex: 2, child: Text('NRR', textAlign: TextAlign.right, style: AppTypography.caption(AppColors.textMuted(context)))),
                Expanded(flex: 2, child: Text('PTS', textAlign: TextAlign.right, style: AppTypography.caption(AppColors.textMuted(context)))),
              ],
            ),
          ),
          _buildHairlineDivider(context),
          // Team Rows
          ...CricketMockData.pointsTable.map((row) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      // Rank
                      SizedBox(
                        width: 24,
                        child: Row(
                          children: [
                            Text(
                              '${row.rank}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: row.isQualified ? const Color(0xFF10B981) : AppColors.textSecondary(context),
                              ),
                            ),
                            if (row.isQualified)
                              Container(
                                width: 3,
                                height: 12,
                                margin: const EdgeInsets.only(left: 3),
                                color: const Color(0xFF10B981),
                              ),
                          ],
                        ),
                      ),
                      // Team Crest & Code
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: row.teamColor.withValues(alpha: 0.15),
                                border: Border.all(color: row.teamColor, width: 1.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                row.teamCode.substring(0, 1),
                                style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: row.teamColor),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                row.teamName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(flex: 1, child: Text('${row.played}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 1, child: Text('${row.won}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 1, child: Text('${row.lost}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                      Expanded(
                        flex: 2,
                        child: Text(
                          (row.netRunRate >= 0 ? '+' : '') + row.netRunRate.toStringAsFixed(3),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: row.netRunRate >= 0 ? const Color(0xFF10B981) : AppColors.liveRed,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${row.points}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildHairlineDivider(context),
              ],
            );
          }),

          const SizedBox(height: 14),

          // Qualification Legend
          Row(
            children: [
              Container(width: 8, height: 8, color: const Color(0xFF10B981)),
              const SizedBox(width: 6),
              Text(
                'Top 2 teams qualify for the Final Championship',
                style: AppTypography.caption(AppColors.textMuted(context)),
              ),
            ],
          ),

          context.bottomNavClearance,
        ],
      ),
    );
  }

  // Tab 2: Fixtures & Schedule
  Widget _buildFixturesTab(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveHorizontalPadding,
        vertical: 12,
      ),
      itemCount: CricketMockData.seriesFixtures.length,
      separatorBuilder: (_, _) => _buildHairlineDivider(context),
      itemBuilder: (context, index) {
        final fix = CricketMockData.seriesFixtures[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchDetailsScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top round & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${fix.matchRound} • ${fix.venue}',
                      style: AppTypography.caption(AppColors.textMuted(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (fix.isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.liveRed,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'LIVE NOW',
                          style: AppTypography.liveBadge(Colors.white).copyWith(fontSize: 9),
                        ),
                      )
                    else
                      Text(
                        fix.date,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary(context),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // Teams Matchup
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          fix.team1Code,
                          style: AppTypography.teamCode(AppColors.textPrimary(context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'vs',
                            style: AppTypography.headlineSmall(AppColors.textMuted(context)),
                          ),
                        ),
                        Text(
                          fix.team2Code,
                          style: AppTypography.teamCode(AppColors.textPrimary(context)),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primary(context),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  fix.statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fix.isLive ? AppColors.primary(context) : AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tab 3: Leaderboards
  Widget _buildLeaderboardTab(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveHorizontalPadding,
        vertical: 12,
      ),
      itemCount: CricketMockData.topPerformers.length,
      separatorBuilder: (_, _) => _buildHairlineDivider(context),
      itemBuilder: (context, index) {
        final performer = CricketMockData.topPerformers[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: performer.badgeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: performer.badgeColor, width: 1.5),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: performer.badgeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      performer.awardTitle,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: performer.badgeColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${performer.playerName} (${performer.teamCode})',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      performer.statLabel,
                      style: AppTypography.caption(AppColors.textSecondary(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
