import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// Tactile Neumorphic push button for Kreeda using Bebas Neue typography.
class KreedaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final IconData? trailingIcon;
  final double height;
  final double? width;
  final double borderRadius;
  final bool isSecondary;
  final EdgeInsetsGeometry? padding;

  const KreedaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.trailingIcon,
    this.height = 48.0,
    this.width,
    this.borderRadius = 24.0,
    this.isSecondary = false,
    this.padding,
  });

  @override
  State<KreedaButton> createState() => _KreedaButtonState();
}

class _KreedaButtonState extends State<KreedaButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final defaultBg = widget.isSecondary
        ? AppColors.surface(context)
        : AppColors.primaryOrange;
    final bg = widget.backgroundColor ?? defaultBg;
    final defaultTextColor = widget.isSecondary
        ? AppColors.textPrimary(context)
        : Colors.white;
    final fg = widget.textColor ?? defaultTextColor;

    return GestureDetector(
      onTapDown: isEnabled
          ? (_) {
              HapticFeedback.lightImpact();
              setState(() => _isPressed = true);
            }
          : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.isSecondary
                ? Border.all(color: AppColors.border(context), width: 0.85)
                : null,
            boxShadow: widget.isSecondary
                ? AppShadows.neumorphic(context)
                : (_isPressed ? [] : AppShadows.orangeGlow),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: fg),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.text,
                            style: AppTypography.buttonLabel(fg),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      if (widget.trailingIcon != null) ...[
                        const SizedBox(width: 8),
                        Icon(widget.trailingIcon, size: 18, color: fg),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
