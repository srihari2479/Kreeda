import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Real-time live scoreboard card with team crests, overs, and status.
class LiveMatchCard extends StatelessWidget {
  final VoidCallback? onTap;

  const LiveMatchCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border(context),
              width: 1.0,
            ),
            gradient: LinearGradient(
              colors: AppColors.isDark(context)
                  ? [
                      const Color(0xFF131D33),
                      const Color(0xFF0F1728),
                      const Color(0xFF09101C),
                    ]
                  : [
                      const Color(0xFFFFFFFF),
                      const Color(0xFFF8FAFC),
                      const Color(0xFFEFF6FF),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row: Live badge + Match info
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Live Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.liveRed,
                        borderRadius: BorderRadius.circular(10),
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
                    Text(
                      '2nd T20I • Melbourne',
                      style: AppTypography.caption(AppColors.textSecondary(context)),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Matchup & Scores Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    // Team 1 (IND)
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          _buildTeamCrest(
                            flagColor: const Color(0xFFFF9933),
                            code: 'IND',
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'IND',
                                  style: AppTypography.teamCode(
                                    AppColors.textPrimary(context),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '148/2',
                                        style: AppTypography.bebas(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary(context),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(16.4)',
                                      style: AppTypography.caption(
                                        AppColors.textMuted(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // VS Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated(context),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'VS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted(context),
                          ),
                        ),
                      ),
                    ),

                    // Team 2 (AUS)
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'AUS',
                                  style: AppTypography.teamCode(
                                    AppColors.textPrimary(context),
                                  ),
                                ),
                                Text(
                                  'Yet to Bat',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary(context),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildTeamCrest(
                            flagColor: const Color(0xFFFFD700),
                            code: 'AUS',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Pitch Green accent bar
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF10B981),
                      Color(0xFF34D399),
                      Color(0xFF059669),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCrest({required Color flagColor, required String code}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: flagColor.withValues(alpha: 0.18),
        border: Border.all(color: flagColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          color: flagColor,
        ),
      ),
    );
  }
}
