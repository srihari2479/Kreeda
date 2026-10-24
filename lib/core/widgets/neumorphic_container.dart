import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Modern Material 3 + Subtle Neumorphic surface container for Kreeda.
/// Provides soft dual-layer specular and diffuse shadows, subtle borders,
/// and tactile micro-press scaling.
class NeumorphicContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool isPressed;
  final double? width;
  final double? height;
  final Gradient? gradient;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.isPressed = false,
    this.width,
    this.height,
    this.gradient,
  });

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppColors.surface(context);
    final outlineColor = widget.borderColor ?? AppColors.border(context);
    final activePressed = widget.isPressed || _isDown;

    Widget container = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.gradient == null ? bgColor : null,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: outlineColor,
          width: widget.borderWidth,
        ),
        boxShadow: activePressed
            ? AppShadows.pressed(context)
            : AppShadows.neumorphic(context),
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) {
          HapticFeedback.selectionClick();
          setState(() => _isDown = true);
        },
        onTapUp: (_) => setState(() => _isDown = false),
        onTapCancel: () => setState(() => _isDown = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: activePressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: container,
        ),
      );
    }

    return container;
  }
}
