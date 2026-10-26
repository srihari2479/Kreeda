import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'kreeda_toast.dart';

/// Upcoming match fixture card matching the new screenshot design.
/// Includes date/time, reminder bell icon, team emblems with acronyms,
/// tournament stage, and ACA stadium venue.
class UpcomingMatchCard extends StatefulWidget {
  final String date;
  final String time;
  final String team1;
  final String team2;
  final String series;
  final String venue;
  final Color team1Color;
  final Color team2Color;
  final IconData team1Icon;
  final IconData team2Icon;
  final VoidCallback? onTap;

  const UpcomingMatchCard({
    super.key,
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
    required this.series,
    required this.venue,
    required this.team1Color,
    required this.team2Color,
    this.team1Icon = Icons.shield_rounded,
    this.team2Icon = Icons.flash_on_rounded,
    this.onTap,
  });

  @override
  State<UpcomingMatchCard> createState() => _UpcomingMatchCardState();
}

class _UpcomingMatchCardState extends State<UpcomingMatchCard> {
  bool _isReminderSet = false;

  void _toggleReminder() {
    HapticFeedback.lightImpact();
    setState(() => _isReminderSet = !_isReminderSet);
    KreedaToast.showSuccess(
      context,
      _isReminderSet
          ? 'Reminder set for ${widget.team1} vs ${widget.team2}'
          : 'Reminder removed',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 195,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Date/Time + Reminder Bell
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.date}  •  ${widget.time}',
                      style: AppTypography.caption(AppColors.textSecondary(context))
                          .copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _toggleReminder,
                    child: Icon(
                      _isReminderSet
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_none_rounded,
                      size: 16,
                      color: _isReminderSet
                          ? AppColors.primaryOrange
                          : AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Teams Matchup Row: [Crest + Code] VS [Crest + Code]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Team 1
                  _buildTeamCrest(widget.team1, widget.team1Color, widget.team1Icon),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted(context),
                      ),
                    ),
                  ),
                  // Team 2
                  _buildTeamCrest(widget.team2, widget.team2Color, widget.team2Icon),
                ],
              ),

              const SizedBox(height: 4),

              // Tournament & Venue Info
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.series,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.venue,
                      style: AppTypography.caption(AppColors.textMuted(context))
                          .copyWith(fontSize: 9.0),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCrest(String code, Color color, IconData icon) {
    String? crestAsset;
    if (code == 'TKR') crestAsset = 'Assets/tkr_crest.jpg';
    if (code == 'TS') crestAsset = 'Assets/ts_crest.jpg';
    if (code == 'CR') crestAsset = 'Assets/cr_crest.jpg';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
              ),
            ],
          ),
          child: ClipOval(
            child: crestAsset != null
                ? Image.asset(
                    crestAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                      color: color.withValues(alpha: 0.15),
                      child: Icon(icon, color: color, size: 20),
                    ),
                  )
                : Container(
                    color: color.withValues(alpha: 0.15),
                    child: Icon(icon, color: color, size: 20),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: AppTypography.caption(AppColors.textPrimary(context)).copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
