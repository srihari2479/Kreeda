import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Tactile flanked section title widget styled as `----- TITLE -----`.
/// Auto-formats the provided [title] in bold uppercase typography,
/// flanked on left and right by gentle, subtle horizontal divider lines.
///
/// UI/UX Priority:
/// - Text prominence & legibility is the primary focus: text renders at full,
///   healthy font size (12.0sp, bold) and takes as much space as it needs.
/// - Left & right lines are gentle background flanking accents that take whatever
///   space is left over without crowding or shrinking the title text.
/// - Zero RenderFlex overflow guarantee across all viewports.
class SectionDividerTitle extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? lineColor;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final double lineThickness;
  final double spacing;
  final double fontSize;
  final bool isDashed;

  const SectionDividerTitle({
    super.key,
    required this.title,
    this.color,
    this.lineColor,
    this.style,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.lineThickness = 1.0,
    this.spacing = 8.0,
    this.fontSize = 12.0,
    this.isDashed = false,
  });

  const SectionDividerTitle.dashed({
    super.key,
    required this.title,
    this.color,
    this.lineColor,
    this.style,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.lineThickness = 1.0,
    this.spacing = 8.0,
    this.fontSize = 12.0,
  }) : isDashed = true;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = color ?? AppColors.primary(context);
    final effectiveLineColor = lineColor ?? AppColors.border(context);

    final effectiveStyle = style ??
        AppTypography.caption(effectiveTextColor).copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        );

    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;

          // Gentle accent lines: reserve only minimal 12px per side so text gets maximum screen presence
          const minLineWidth = 12.0;
          final maxTextWidth =
              (maxWidth - (minLineWidth * 2) - (spacing * 2)).clamp(60.0, maxWidth);

          return Row(
            children: [
              Expanded(
                child: _buildLine(effectiveLineColor),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: maxTextWidth),
                padding: EdgeInsets.symmetric(horizontal: spacing),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title.trim().toUpperCase(),
                    maxLines: 1,
                    style: effectiveStyle,
                  ),
                ),
              ),
              Expanded(
                child: _buildLine(effectiveLineColor),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLine(Color effectiveLineColor) {
    // Gentle line: soft hairline divider that does not compete with text prominence
    final softLineColor = effectiveLineColor.withValues(alpha: 0.85);

    if (isDashed) {
      return SizedBox(
        height: lineThickness,
        child: CustomPaint(
          painter: _DashedLinePainter(
            color: softLineColor,
            strokeWidth: lineThickness,
          ),
          size: Size.infinite,
        ),
      );
    }
    return Container(
      height: lineThickness,
      color: softLineColor,
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  static const double dashWidth = 5.0;
  static const double dashSpace = 3.5;

  _DashedLinePainter({
    required this.color,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      final endX = (startX + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
