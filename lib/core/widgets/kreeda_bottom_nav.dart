import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/responsive.dart';
import 'package:kreeda/features/scoring/presentation/screens/scoring_console_screen.dart';

/// Kreeda Dual-Island Floating Bottom Navigation Bar.
/// 1. Primary Left Island: Rounded capsule pill dock hosting 4 core tabs
///    (Home, Matches with live indicator badge, Tournaments, and My Cricket),
///    with physics-based parabolic jump bounce animations and animated active pill highlights.
/// 2. Secondary Right Standalone Island: Floating circular action button (FAB) in Energy
///    Vermilion Orange gradient with glowing drop shadow, tactile press bounce micro-interaction,
///    and a bold centered '+' icon triggering the CricHeroes scorer / tournament creation sheet.
class KreedaBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback? onCreateTap;

  const KreedaBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.onCreateTap,
  });

  static const List<_TabItemData> _dockTabs = [
    _TabItemData(
      tabIndex: 0,
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _TabItemData(
      tabIndex: 1,
      label: 'Matches',
      icon: Icons.live_tv_outlined,
      activeIcon: Icons.live_tv_rounded,
      badgeText: 'LIVE',
    ),
    _TabItemData(
      tabIndex: 3,
      label: 'Tournaments',
      icon: Icons.emoji_events_outlined,
      activeIcon: Icons.emoji_events_rounded,
    ),
    _TabItemData(
      tabIndex: 4,
      label: 'My Cricket',
      icon: Icons.sports_cricket_outlined,
      activeIcon: Icons.sports_cricket_rounded,
    ),
  ];

  void _showCreateSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                'CREATE & SCORE',
                style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
              ),
              const SizedBox(height: 4),
              Text(
                'Launch scorer console, organize tournaments or register squads',
                style: AppTypography.bodySmall(AppColors.textSecondary(context)),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_cricket_rounded,
                    color: Color(0xFF10B981),
                    size: 22,
                  ),
                ),
                title: Text(
                  'Live Scorer Console',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: const Text('Score ground ball-by-ball with tactile keypad'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScoringConsoleScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Color(0xFF3B82F6),
                    size: 22,
                  ),
                ),
                title: Text(
                  'Create Tournament',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: const Text('Setup leagues, knockouts, fixtures & NRR table'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  onTabSelected(3); // Switch to Tournaments tab
                },
              ),
              const Divider(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary(context).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.primary(context),
                    size: 22,
                  ),
                ),
                title: Text(
                  'Register New Team',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: const Text('Add players, captain, jersey and team crest'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final horizontalMargin = Responsive.isSmallPhone(context) ? 10.0 : 14.0;
    final activeColor = AppColors.primary(context);
    final inactiveColor = AppColors.textMuted(context);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      offset: isKeyboardOpen ? const Offset(0, 1.5) : Offset.zero,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isKeyboardOpen ? 0.0 : 1.0,
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            left: horizontalMargin,
            right: horizontalMargin,
            bottom: bottomInset > 0 ? bottomInset + 4 : 12.0,
            top: 4.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Primary Left Island: Capsule Dock with 4 Tabs
              Expanded(
                child: _buildCapsuleDock(context, activeColor, inactiveColor),
              ),

              const SizedBox(width: 10),

              // 2. Secondary Right Standalone Island: Floating Action Button with Bold '+'
              _FloatingCreateButton(
                onTap: () {
                  if (onCreateTap != null) {
                    onCreateTap!();
                  } else {
                    _showCreateSheet(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCapsuleDock(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
  ) {
    final navBg = AppColors.surface(context);
    final borderColor = AppColors.border(context);
    final isDark = AppColors.isDark(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: isDark
                ? navBg.withValues(alpha: 0.82)
                : Colors.white.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                  ? borderColor.withValues(alpha: 0.8)
                  : const Color(0xFFE2E8F0).withValues(alpha: 0.85),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.38 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 5),
                spreadRadius: 0,
              ),
              if (isDark)
                BoxShadow(
                  color: AppColors.primary(context).withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Row(
        children: _dockTabs.map((tab) {
          final isSelected = selectedIndex == tab.tabIndex;

          return Expanded(
            child: _BounceTabItem(
              index: tab.tabIndex,
              icon: tab.icon,
              activeIcon: tab.activeIcon,
              label: tab.label,
              badgeText: tab.badgeText,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              isSelected: isSelected,
              onTap: () => onTabSelected(tab.tabIndex),
            ),
          );
        }).toList(),
      ),
    ),
  ),
);
  }
}

class _TabItemData {
  final int tabIndex;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String? badgeText;

  const _TabItemData({
    required this.tabIndex,
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badgeText,
  });
}

/// Standalone Floating Action Button matching screenshot with energy gradient,
/// bold centered '+' icon, glowing drop shadow, and tactile scale down bounce.
class _FloatingCreateButton extends StatefulWidget {
  final VoidCallback onTap;

  const _FloatingCreateButton({
    required this.onTap,
  });

  @override
  State<_FloatingCreateButton> createState() => _FloatingCreateButtonState();
}

class _FloatingCreateButtonState extends State<_FloatingCreateButton> {
  static const double _buttonSize = 56.0;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Create',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: Container(
            width: _buttonSize,
            height: _buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7A00), AppColors.primaryOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
                weight: 800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BounceTabItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badgeText;
  final Color activeColor;
  final Color inactiveColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _BounceTabItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeText,
    required this.activeColor,
    required this.inactiveColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_BounceTabItem> createState() => _BounceTabItemState();
}

class _BounceTabItemState extends State<_BounceTabItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _translateYAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _translateYAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -5.5)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -5.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
    ]).animate(_bounceController);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.12)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.12, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
    ]).animate(_bounceController);
  }

  @override
  void didUpdateWidget(covariant _BounceTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final activePillBg = widget.isSelected
        ? AppColors.primary(context).withValues(alpha: isDark ? 0.16 : 0.12)
        : Colors.transparent;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: activePillBg,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _bounceController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _translateYAnimation.value),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    widget.isSelected ? widget.activeIcon : widget.icon,
                    size: 21,
                    color: widget.isSelected
                        ? widget.activeColor
                        : widget.inactiveColor,
                  ),
                ),
                if (widget.badgeText != null)
                  Positioned(
                    top: -4,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF3366), AppColors.primaryOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withValues(alpha: 0.45),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.badgeText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.label,
                style: AppTypography.caption(
                  widget.isSelected ? widget.activeColor : widget.inactiveColor,
                ).copyWith(
                  fontSize: 9.5,
                  fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
