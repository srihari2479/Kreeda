import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// Floating toast notification for Kreeda with auto-dismiss and haptic-level elegance.
class KreedaToast {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.pitchGreen,
      borderColor: AppColors.pitchGreen.withValues(alpha: 0.3),
      lightBorderColor: AppColors.pitchGreen,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_rounded,
      iconColor: AppColors.liveRed,
      borderColor: AppColors.liveRed.withValues(alpha: 0.3),
      lightBorderColor: AppColors.liveRed,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_rounded,
      iconColor: AppColors.pitchGreen,
      borderColor: AppColors.pitchGreen.withValues(alpha: 0.3),
      lightBorderColor: AppColors.pitchGreen,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    Color? lightBorderColor,
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon,
        iconColor: iconColor,
        borderColor: borderColor,
        lightBorderColor: lightBorderColor ?? AppColors.pitchGreen,
        onDismiss: () {
          if (entry.mounted) {
            entry.remove();
          }
        },
      ),
    );

    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color lightBorderColor;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.lightBorderColor,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Auto-dismiss after 2.8 seconds
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top + 12;
    final isDark = AppColors.isDark(context);

    // In Light Theme: pure white background, crisp green border, NO shadow.
    // In Dark Theme: preserved dark surface, subtle alpha border, and neumorphic shadow.
    final backgroundColor = isDark ? AppColors.surface(context) : Colors.white;
    final borderColor = isDark ? widget.borderColor : widget.lightBorderColor;
    final borderWidth = isDark ? 1.2 : 1.4;
    final boxShadow = isDark ? AppShadows.neumorphic(context) : null;

    return Positioned(
      top: topPadding,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: borderWidth),
                boxShadow: boxShadow,
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: widget.iconColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: AppTypography.bodyMedium(
                        AppColors.textPrimary(context),
                      ).copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
