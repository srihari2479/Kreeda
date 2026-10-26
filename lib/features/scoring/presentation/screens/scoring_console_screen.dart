import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';

/// Professional Live Match Scorer Console.
/// Designed for lightning-fast, tactile ground scoring with haptic feedback,
/// instant extras, and dismissal workflows.
class ScoringConsoleScreen extends StatefulWidget {
  const ScoringConsoleScreen({super.key});

  @override
  State<ScoringConsoleScreen> createState() => _ScoringConsoleScreenState();
}

class _ScoringConsoleScreenState extends State<ScoringConsoleScreen> {
  int _totalRuns = 148;
  int _wickets = 2;
  int _completedOvers = 16;
  int _ballsInCurrentOver = 4;

  // Active pair
  String _striker = 'Virat Kohli';
  int _strikerRuns = 68;
  int _strikerBalls = 42;

  String _nonStriker = 'Suryakumar Yadav';
  int _nonStrikerRuns = 34;
  int _nonStrikerBalls = 21;

  final String _bowler = 'Pat Cummins';
  int _bowlerRuns = 28;
  int _bowlerWickets = 1;

  final List<String> _currentOverLog = ['1', '4', '•', '6'];

  void _recordBall(int runs, {bool isBoundary = false, bool isSix = false}) {
    HapticFeedback.lightImpact();
    setState(() {
      _totalRuns += runs;
      _strikerRuns += runs;
      _strikerBalls += 1;
      _bowlerRuns += runs;

      String label = '$runs';
      if (runs == 0) label = '•';
      _currentOverLog.add(label);

      _ballsInCurrentOver += 1;
      if (_ballsInCurrentOver >= 6) {
        _completedOvers += 1;
        _ballsInCurrentOver = 0;
        _currentOverLog.clear();
        _swapStrike();
      } else if (runs % 2 == 1) {
        _swapStrike();
      }
    });
  }

  void _swapStrike() {
    setState(() {
      final tempName = _striker;
      final tempRuns = _strikerRuns;
      final tempBalls = _strikerBalls;

      _striker = _nonStriker;
      _strikerRuns = _nonStrikerRuns;
      _strikerBalls = _nonStrikerBalls;

      _nonStriker = tempName;
      _nonStrikerRuns = tempRuns;
      _nonStrikerBalls = tempBalls;
    });
  }

  void _recordExtra(String type) {
    HapticFeedback.lightImpact();
    setState(() {
      _totalRuns += 1;
      _bowlerRuns += 1;
      _currentOverLog.add(type);
    });
  }

  void _undoLastBall() {
    HapticFeedback.mediumImpact();
    if (_currentOverLog.isNotEmpty) {
      setState(() {
        final last = _currentOverLog.removeLast();
        if (last == '4') {
          _totalRuns -= 4;
          _strikerRuns -= 4;
        } else if (last == '6') {
          _totalRuns -= 6;
          _strikerRuns -= 6;
        } else if (last == '1') {
          _totalRuns -= 1;
          _strikerRuns -= 1;
        } else if (last == 'W') {
          _wickets = (_wickets - 1).clamp(0, 10);
          _bowlerWickets = (_bowlerWickets - 1).clamp(0, 10);
        }
        if (_ballsInCurrentOver > 0) _ballsInCurrentOver--;
      });
    }
  }

  void _showWicketModal() {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final modes = ['Bowled', 'Caught', 'Run Out', 'LBW', 'Stumped', 'Hit Wicket'];
        return Padding(
          padding: Responsive.modalBottomPadding(context, base: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DISMISSAL TYPE',
                    style: AppTypography.headlineMedium(AppColors.liveRed),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Out: $_striker ($_strikerRuns runs off $_strikerBalls balls)',
                style: AppTypography.bodyMedium(AppColors.textSecondary(context)),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: modes.map((mode) {
                  return ActionChip(
                    label: Text(mode),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                    backgroundColor: AppColors.surfaceElevated(context),
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _wickets = (_wickets + 1).clamp(0, 10);
                        _bowlerWickets += 1;
                        _currentOverLog.add('W');
                        _striker = 'Rishabh Pant';
                        _strikerRuns = 0;
                        _strikerBalls = 0;
                        _ballsInCurrentOver += 1;
                      });
                    },
                  );
                }).toList(),
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
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          'SCORER CONSOLE',
          style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
        ),
        actions: [
          IconButton(
            onPressed: _swapStrike,
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Swap Striker',
          ),
          IconButton(
            onPressed: _undoLastBall,
            icon: const Icon(Icons.undo_rounded),
            tooltip: 'Undo Last Ball',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Live Score Ribbon
            _buildScoreRibbon(context),

            // 2. Active Batsmen & Bowler Strip
            _buildActivePlayersStrip(context),

            // 3. This Over Timeline
            _buildThisOverTimeline(context),

            const Spacer(),

            // 4. Tactile Runs Keypad
            _buildRunsKeypad(context),

            // 5. Extras & Wicket Bar
            _buildExtrasAndWicketBar(context),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRibbon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(
          bottom: BorderSide(color: AppColors.border(context), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INDIA INNINGS',
                style: AppTypography.caption(AppColors.textMuted(context)),
              ),
              Row(
                children: [
                  Text(
                    '$_totalRuns/$_wickets',
                    style: AppTypography.displayLarge(AppColors.primary(context)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '($_completedOvers.$_ballsInCurrentOver Ov)',
                    style: AppTypography.titleMedium(AppColors.textSecondary(context)),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'CRR: ${((_totalRuns) / ((_completedOvers * 6 + _ballsInCurrentOver) / 6)).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                'Target: 185 Projected',
                style: AppTypography.caption(AppColors.textSecondary(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivePlayersStrip(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border(context).withValues(alpha: 0.35),
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        children: [
          // Striker
          GestureDetector(
            onTap: _swapStrike,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$_striker *',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$_strikerRuns ($_strikerBalls)',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            height: 14,
            thickness: 0.5,
            color: AppColors.border(context).withValues(alpha: 0.3),
          ),
          // Non Striker
          GestureDetector(
            onTap: _swapStrike,
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _nonStriker,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$_nonStrikerRuns ($_nonStrikerBalls)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 14,
            thickness: 0.5,
            color: AppColors.border(context).withValues(alpha: 0.3),
          ),
          // Bowler
          Row(
            children: [
              const Icon(Icons.sports_baseball_rounded, size: 14, color: Color(0xFF10B981)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Bowler: $_bowler',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$_bowlerWickets/$_bowlerRuns',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThisOverTimeline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'Assets/cricket_leather_ball_3d.jpg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'THIS OVER:',
            style: AppTypography.caption(AppColors.textMuted(context)).copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _currentOverLog.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (context, i) {
                  final ball = _currentOverLog[i];
                  Color bg = AppColors.surfaceElevated(context);
                  Color fg = AppColors.textPrimary(context);

                  if (ball == '6') {
                    bg = AppColors.primaryOrange;
                    fg = Colors.white;
                  } else if (ball == '4') {
                    bg = const Color(0xFF3B82F6);
                    fg = Colors.white;
                  } else if (ball == 'W') {
                    bg = AppColors.liveRed;
                    fg = Colors.white;
                  }

                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      ball,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: fg,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunsKeypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          // Row 1: 0, 1, 2
          Row(
            children: [
              _buildKeyButton('0 (Dot)', () => _recordBall(0), flex: 1),
              _buildKeyButton('1 (Single)', () => _recordBall(1), flex: 1),
              _buildKeyButton('2 (Two)', () => _recordBall(2), flex: 1),
            ],
          ),
          const SizedBox(height: 10),
          // Row 2: 3, 4 (Boundary), 6 (Maximum)
          Row(
            children: [
              _buildKeyButton('3', () => _recordBall(3), flex: 1),
              _buildKeyButton(
                '4 (FOUR)',
                () => _recordBall(4, isBoundary: true),
                flex: 1,
                color: const Color(0xFF3B82F6),
              ),
              _buildKeyButton(
                '6 (SIX)',
                () => _recordBall(6, isSix: true),
                flex: 1,
                color: AppColors.primaryOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtrasAndWicketBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Column(
        children: [
          // Extras Row: WD, NB, BYE, LB
          Row(
            children: [
              _buildExtraButton('WIDE', () => _recordExtra('WD')),
              _buildExtraButton('NO BALL', () => _recordExtra('NB')),
              _buildExtraButton('BYE', () => _recordExtra('B')),
              _buildExtraButton('LEG BYE', () => _recordExtra('LB')),
            ],
          ),
          const SizedBox(height: 10),
          // Massive Wicket Action Button
          GestureDetector(
            onTap: _showWicketModal,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.liveRed,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.liveRed.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sports_cricket_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'WICKET / OUT',
                      style: AppTypography.buttonLabel(Colors.white).copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String text, VoidCallback onTap, {int flex = 1, Color? color}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: color ?? AppColors.surface(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color != null
                    ? Colors.transparent
                    : AppColors.border(context).withValues(alpha: 0.5),
                width: 0.8,
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: color != null ? Colors.white : AppColors.textPrimary(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtraButton(String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border(context), width: 0.8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
