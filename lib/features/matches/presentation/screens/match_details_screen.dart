import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/cricket_mock_data.dart';
import 'package:kreeda/features/matches/domain/models/match_model.dart';
import 'package:kreeda/features/scoring/presentation/screens/scoring_console_screen.dart';

/// Full Interactive Match Center & Scorecard screen.
/// Includes Summary, Complete Scorecard, Ball-by-Ball Commentary, and 360° Wagon Wheel.
class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({super.key});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _wagonWheelFilter = 0; // 0: All, 1: Boundaries, 2: Off Side, 3: Leg Side

  final match = CricketMockData.liveMatch;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'MATCH CENTER',
          style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
        ),
        centerTitle: false,
        actions: [
          // Quick Button to open the Scorer Keypad Console
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScoringConsoleScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_note_rounded, size: 16),
              label: Text(
                'SCORER',
                style: AppTypography.buttonLabel(Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Sticky Scoreboard Header
            _buildStickyScoreboardHeader(context),

            // 2. Tab Bar Header (Summary, Scorecard, Commentary, Wagon Wheel)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                border: Border(
                  bottom: BorderSide(color: AppColors.border(context), width: 1.0),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelColor: AppColors.primary(context),
                unselectedLabelColor: AppColors.textSecondary(context),
                indicatorColor: AppColors.primary(context),
                indicatorWeight: 3.0,
                labelStyle: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'SUMMARY'),
                  Tab(text: 'SCORECARD'),
                  Tab(text: 'COMMENTARY'),
                  Tab(text: 'WAGON WHEEL'),
                ],
              ),
            ),

            // 3. Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSummaryTab(context),
                  _buildScorecardTab(context),
                  _buildCommentaryTab(context),
                  _buildWagonWheelTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sticky Match Scoreboard Header — Edge-to-Edge Broadcast Canvas
  Widget _buildStickyScoreboardHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border(context).withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          // Live badge, venue & CRR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.liveRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sensors_rounded, size: 10, color: Colors.white),
                          const SizedBox(width: 3),
                          Text('LIVE', style: AppTypography.liveBadge(Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${match.matchNumber} • MCG',
                        style: AppTypography.caption(AppColors.textSecondary(context)).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'CRR 8.88',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary(context),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Scores Row (Spacious & Clean, Edge-to-Edge)
          Row(
            children: [
              // Team 1
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'Assets/ind_crest.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: match.team1Color.withValues(alpha: 0.15),
                            alignment: Alignment.center,
                            child: Text(
                              match.team1Code,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: match.team1Color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.team1Code,
                            style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
                          ),
                          Text(
                            '${match.team1Score} (${match.team1Overs})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'vs',
                  style: AppTypography.headlineSmall(AppColors.textMuted(context)),
                ),
              ),
              // Team 2
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            match.team2Code,
                            style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
                          ),
                          Text(
                            match.team2Score,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'Assets/aus_crest.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: match.team2Color.withValues(alpha: 0.15),
                            alignment: Alignment.center,
                            child: Text(
                              match.team2Code,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: match.team2Color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Win Predictor Progress Bar (Edge-to-Edge Ribbon)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IND Win 76%',
                    style: AppTypography.caption(match.team1Color).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'AUS Win 24%',
                    style: AppTypography.caption(match.team2Color).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 76,
                      child: Container(height: 4.5, color: match.team1Color),
                    ),
                    Expanded(
                      flex: 24,
                      child: Container(height: 4.5, color: match.team2Color),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 1: Summary View — Borderless Content Canvas
  Widget _buildSummaryTab(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Batsmen Section
          Text(
            'CURRENT BATSMEN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.primary(context),
            ),
          ),
          const SizedBox(height: 10),
          // Batsmen list
          ...match.activeBatsmen.map((b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        b.isStriker ? '${b.name} *' : b.name,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: b.isStriker ? FontWeight.w800 : FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${b.runs}',
                      style: AppTypography.bebas(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      ' (${b.balls})',
                      style: AppTypography.caption(AppColors.textMuted(context)),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'SR ${b.strikeRate}',
                      style: AppTypography.caption(AppColors.textSecondary(context)).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
          Divider(
            height: 20,
            thickness: 0.8,
            color: AppColors.border(context).withValues(alpha: 0.5),
          ),
          // Current Bowler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'BOWLER: ${match.currentBowler.name}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${match.currentBowler.wickets}/${match.currentBowler.runs} (${match.currentBowler.overs} ov)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // This Over Timeline Pills
          Text(
            'THIS OVER',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: match.thisOverBalls
                .map((ball) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildBallPill(context, ball),
                    ))
                .toList(),
          ),

          const SizedBox(height: 24),

          // Match Information Section
          Text(
            'MATCH INFO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.primary(context),
            ),
          ),
          const SizedBox(height: 10),
          _buildInfoRow('Series', match.seriesName),
          _buildInfoRow('Venue', match.venue),
          _buildInfoRow('Toss', 'India won the toss & chose to bat'),
          _buildInfoRow('Umpires', 'Rod Tucker, Paul Reiffel'),
          _buildInfoRow('Match Referee', 'David Boon'),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Tab 2: Full Scorecard — Borderless Content Canvas
  Widget _buildScorecardTab(BuildContext context) {
    final innings = match.innings.first;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Innings Headline Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                innings.teamName,
                style: AppTypography.headlineSmall(AppColors.textPrimary(context)),
              ),
              Text(
                '${innings.score} (${innings.overs})',
                style: AppTypography.headlineSmall(AppColors.primary(context)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Batting Table — Borderless Content Canvas
          Column(
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        'BATSMAN',
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'R',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'B',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '4s',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '6s',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'SR',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 14,
                thickness: 0.8,
                color: AppColors.border(context).withValues(alpha: 0.6),
              ),
              // Batsmen Rows with hairline dividers
              ...innings.batsmen.map((b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                b.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${b.runs}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${b.balls}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${b.fours}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${b.sixes}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${b.strikeRate}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            b.dismissal,
                            style: AppTypography.caption(AppColors.textMuted(context)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: AppColors.border(context).withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                  )),
              // Extras Row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extras',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    Text(
                      innings.extras,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 0.8,
                color: AppColors.border(context).withValues(alpha: 0.6),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bowling Section Headline
          Text(
            'AUSTRALIA BOWLING',
            style: AppTypography.headlineSmall(AppColors.textPrimary(context)),
          ),
          const SizedBox(height: 10),

          // Bowling Table — Borderless Content Canvas
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        'BOWLER',
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'O',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'M',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'R',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'W',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'ECON',
                        textAlign: TextAlign.right,
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 14,
                thickness: 0.8,
                color: AppColors.border(context).withValues(alpha: 0.6),
              ),
              ...innings.bowlers.map((bw) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Text(
                                bw.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(flex: 2, child: Text('${bw.overs}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12.5))),
                            Expanded(flex: 2, child: Text('${bw.maidens}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12.5))),
                            Expanded(flex: 2, child: Text('${bw.runs}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12.5))),
                            Expanded(flex: 2, child: Text('${bw.wickets}', textAlign: TextAlign.right, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary(context)))),
                            Expanded(flex: 3, child: Text('${bw.economy}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: AppColors.border(context).withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 24),

          // Fall of Wickets — Borderless Strip
          Text(
            'FALL OF WICKETS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.primary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            innings.fallOfWickets,
            style: AppTypography.bodySmall(AppColors.textSecondary(context)).copyWith(
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Tab 3: Ball-by-Ball Commentary — Borderless Timeline Stream
  Widget _buildCommentaryTab(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: match.commentary.length,
      separatorBuilder: (_, _) => Divider(
        height: 18,
        thickness: 0.5,
        color: AppColors.border(context).withValues(alpha: 0.35),
      ),
      itemBuilder: (context, index) {
        final item = match.commentary[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Over Ball Pill
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.isWicket
                      ? AppColors.liveRed
                      : (item.isBoundary
                          ? AppColors.primary(context)
                          : AppColors.surfaceElevated(context)),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.over,
                      style: TextStyle(
                        fontSize: 9,
                        color: (item.isWicket || item.isBoundary)
                            ? Colors.white
                            : AppColors.textMuted(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.ballResult,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: (item.isWicket || item.isBoundary)
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Commentary text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: item.isWicket
                            ? AppColors.liveRed
                            : AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: AppTypography.bodySmall(AppColors.textSecondary(context)).copyWith(
                        height: 1.45,
                      ),
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

  // Tab 4: 360° Wagon Wheel — Borderless Visual Radar
  Widget _buildWagonWheelTab(BuildContext context) {
    final shots = match.wagonWheelShots.where((s) {
      if (_wagonWheelFilter == 1) return s.runs >= 4; // Boundaries only
      if (_wagonWheelFilter == 2) return s.angleDegrees >= 0 && s.angleDegrees <= 180; // Off Side
      if (_wagonWheelFilter == 3) return s.angleDegrees > 180 && s.angleDegrees <= 360; // Leg Side
      return true;
    }).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      child: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('All Shots', 0),
                _buildFilterChip('Boundaries', 1),
                _buildFilterChip('Off Side', 2),
                _buildFilterChip('Leg Side', 3),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Circular Ground Wagon Wheel Canvas — Borderless Presentation
          Text(
            'VIRAT KOHLI — WAGON WHEEL (68 RUNS)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.primary(context),
            ),
          ),
          const SizedBox(height: 16),
          ClipOval(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.6),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'Assets/wagon_wheel_pitch_ground.jpg',
                    width: 270,
                    height: 270,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                  CustomPaint(
                    size: const Size(270, 270),
                    painter: _WagonWheelPainter(
                      shots: shots,
                      isDark: AppColors.isDark(context),
                      hasGroundImage: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('6s', AppColors.primaryOrange),
              const SizedBox(width: 14),
              _buildLegendItem('4s', const Color(0xFF3B82F6)),
              const SizedBox(width: 14),
              _buildLegendItem('1s / 2s', const Color(0xFF10B981)),
            ],
          ),

          const SizedBox(height: 24),

          // Zone Breakdown Stats — Clean Borderless Split Ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.border(context).withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'OFF SIDE',
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '38 Runs (56%)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.border(context).withValues(alpha: 0.6),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'LEG SIDE',
                        style: AppTypography.caption(AppColors.textMuted(context)).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '30 Runs (44%)',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _wagonWheelFilter == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GestureDetector(
        onTap: () => setState(() => _wagonWheelFilter = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary(context) : AppColors.surfaceElevated(context),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBallPill(BuildContext context, BallEventModel ball) {
    Color bg = AppColors.surfaceElevated(context);
    Color fg = AppColors.textPrimary(context);

    if (ball.isBoundarySix) {
      bg = AppColors.primaryOrange;
      fg = Colors.white;
    } else if (ball.isBoundaryFour) {
      bg = const Color(0xFF3B82F6);
      fg = Colors.white;
    } else if (ball.isWicket) {
      bg = AppColors.liveRed;
      fg = Colors.white;
    }

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        ball.ballLabel,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(title, style: AppTypography.caption(AppColors.textMuted(context))),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary(context)),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter for the 360-degree interactive cricket field wagon wheel.
class _WagonWheelPainter extends CustomPainter {
  final List<WagonWheelShotModel> shots;
  final bool isDark;
  final bool hasGroundImage;

  _WagonWheelPainter({
    required this.shots,
    required this.isDark,
    this.hasGroundImage = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (!hasGroundImage) {
      // 1. Cricket Field Ground Turf
      final turfPaint = Paint()
        ..color = isDark ? const Color(0xFF0F1E19) : const Color(0xFFECFDF5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, turfPaint);
    }

    // 2. Boundary Rope
    final boundaryPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: hasGroundImage ? 0.9 : 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = hasGroundImage ? 2.5 : 2.0;
    canvas.drawCircle(center, radius - 2, boundaryPaint);

    // 3. 30-Yard Infield Circle
    final infieldPaint = Paint()
      ..color = hasGroundImage
          ? Colors.white.withValues(alpha: 0.7)
          : const Color(0xFF10B981).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius * 0.52, infieldPaint);

    // 4. Center Pitch Rectangle (only if fallback without photo)
    if (!hasGroundImage) {
      final pitchPaint = Paint()
        ..color = isDark ? const Color(0xFF78350F) : const Color(0xFFD97706)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: 8, height: 26),
          const Radius.circular(2),
        ),
        pitchPaint,
      );
    }

    // 5. Shot Vector Rays
    for (final shot in shots) {
      Color shotColor = const Color(0xFF10B981); // 1s/2s green
      if (shot.runs >= 6) {
        shotColor = AppColors.primaryOrange;
      } else if (shot.runs >= 4) {
        shotColor = const Color(0xFF3B82F6);
      }

      final shotPaint = Paint()
        ..color = shotColor
        ..strokeWidth = shot.runs >= 4 ? 2.2 : 1.2
        ..style = PaintingStyle.stroke;

      final rad = (shot.angleDegrees - 90) * (math.pi / 180);
      final shotLength = radius * shot.distanceRatio * 0.94;
      final endPoint = Offset(
        center.dx + (shotLength * math.cos(rad)),
        center.dy + (shotLength * math.sin(rad)),
      );

      canvas.drawLine(center, endPoint, shotPaint);

      // Shot landing terminal dot
      final dotPaint = Paint()
        ..color = shotColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(endPoint, shot.runs >= 4 ? 3.5 : 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WagonWheelPainter oldDelegate) {
    return oldDelegate.shots != shots || oldDelegate.isDark != isDark;
  }
}
