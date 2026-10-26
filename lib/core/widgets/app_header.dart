import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/theme_transition.dart';
import '../utils/cricket_mock_data.dart';
import '../utils/responsive.dart';
import 'app_logo.dart';
import 'kreeda_toast.dart';

/// Universal App Header for Kreeda.
/// Includes dynamic branding, ATBPL tournament dropdown switcher,
/// search, unread notification badge, and profile avatar.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onTournamentTap;
  final String currentTournament;
  final bool hasUnreadNotifications;

  const AppHeader({
    super.key,
    this.onSearchTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.onTournamentTap,
    this.currentTournament = 'ATBPL',
    this.hasUnreadNotifications = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  void _showTournamentSwitcherSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
              Text(
                'SELECT ACTIVE TOURNAMENT',
                style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
              ),
              const SizedBox(height: 4),
              Text(
                'Filter live matches, scorecards & teams across leagues',
                style: AppTypography.bodySmall(AppColors.textSecondary(context)),
              ),
              const SizedBox(height: 16),
              ...CricketMockData.atbplTournaments.map((t) {
                final isCurrent = t.name == currentTournament;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: t.badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: t.badgeColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: t.badgeColor,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${t.name} • ${t.stage}',
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                      color: isCurrent
                          ? AppColors.primary(context)
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  subtitle: Text(
                    '${t.timeline} • ${t.teamsCount} Teams • ${t.prizePool} Prize',
                    style: AppTypography.caption(AppColors.textSecondary(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isCurrent
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryOrange,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    KreedaToast.showSuccess(context, 'Switched to ${t.name} (${t.stage})');
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.isSmallPhone(context) ? 10.0 : 16.0;
    final isDark = AppColors.isDark(context);

    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        // Completely transparent - no container box or bottom border line
        color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Kreeda Official 4:1 Navbar Logo
              const AppLogo.header(height: 31),

              const SizedBox(width: 8),

              // Center-Left: Tournament Dropdown Selector Pill (Full Natural Size, Not Shrunken)
              _buildTournamentPill(context),

              const Spacer(),

              // Right: 3 Clean Minimal Circular Action Buttons (Matching Image 2 Reference)
              // 1. Theme Mode Switcher Icon (In place of search)
              Builder(
                builder: (btnContext) {
                  return _buildCircularActionButton(
                    context: context,
                    tooltip: 'Toggle Theme',
                    onTapDown: (details) {
                      ThemeTransition.lastPointerPosition = details.globalPosition;
                    },
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Offset? origin = ThemeTransition.lastPointerPosition;
                      if (origin == null) {
                        try {
                          final rb = btnContext.findRenderObject() as RenderBox?;
                          if (rb != null && rb.hasSize) {
                            origin = rb.localToGlobal(rb.size.center(Offset.zero));
                          }
                        } catch (_) {}
                      }
                      ThemeTransition.toggleTheme(btnContext, origin: origin);
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1300),
                      switchInCurve: Curves.easeInOutSine,
                      switchOutCurve: Curves.easeInOutSine,
                      transitionBuilder: (child, anim) => RotationTransition(
                        turns: anim,
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_outlined,
                        key: ValueKey<bool>(isDark),
                        color: isDark
                            ? const Color(0xFFFBBF24)
                            : AppColors.textPrimary(context),
                        size: 19,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: 5),

              // 2. Notification Bell with Connected Red Unread Badge
              _buildCircularActionButton(
                context: context,
                tooltip: 'Notifications',
                onTap: onNotificationTap ??
                    () {
                      HapticFeedback.lightImpact();
                      KreedaToast.showSuccess(context, 'No new notifications');
                    },
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary(context),
                      size: 20,
                    ),
                    if (hasUnreadNotifications)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 7.5,
                          height: 7.5,
                          decoration: BoxDecoration(
                            color: AppColors.liveRed,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              // 3. Profile Avatar / Icon Button (Crisp Person Silhouette)
              _buildCircularActionButton(
                context: context,
                tooltip: 'Profile & Cricket Resume',
                onTap: onProfileTap ??
                    () {
                      HapticFeedback.lightImpact();
                    },
                child: Icon(
                  Icons.person,
                  color: AppColors.textPrimary(context),
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      );
  }

  /// Tournament Dropdown Selector Pill matching Image 2
  Widget _buildTournamentPill(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTournamentTap != null) {
          onTournamentTap!();
        } else {
          _showTournamentSwitcherSheet(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevated(context) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.border(context),
            width: 0.8,
          ),
          boxShadow: isDark
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, 1.5),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTournamentCrest(context),
            const SizedBox(width: 5),
            Text(
              currentTournament,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 12.0,
                letterSpacing: 0.3,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 15,
              color: AppColors.textPrimary(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Official League Crest (Deep Navy + Gold Shield Seal) matching Image 2
  Widget _buildTournamentCrest(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40F59E0B),
            blurRadius: 2.5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.8),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A1128), // Stadium Navy
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.shield_rounded,
          size: 9.5,
          color: Color(0xFFFBBF24), // Gold shield
        ),
      ),
    );
  }

  /// Clean, subtle circular tactile action button matching Image 2
  Widget _buildCircularActionButton({
    required BuildContext context,
    required Widget child,
    VoidCallback? onTap,
    void Function(TapDownDetails details)? onTapDown,
    String? tooltip,
  }) {
    final isDark = AppColors.isDark(context);

    final button = Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        onTapDown: onTapDown,
        customBorder: const CircleBorder(),
        splashColor: AppColors.primary(context).withValues(alpha: 0.12),
        highlightColor: AppColors.primary(context).withValues(alpha: 0.06),
        child: Container(
          width: 33,
          height: 33,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevated(context) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.border(context),
              width: 0.8,
            ),
            boxShadow: isDark
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 1.5),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }
    return button;
  }
}
