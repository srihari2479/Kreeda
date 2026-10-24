import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Global Creative Cricket Loading System for Kreeda.
/// Features a realistic spinning cricket seam ball, breathing energy halo,
/// and Bebas Neue sports typography.
class KreedaLoading {
  static OverlayEntry? _overlayEntry;

  /// Shows a modal full-screen frosted glass loading overlay.
  static void show(
    BuildContext context, {
    String message = 'FETCHING LIVE SCORES...',
  }) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (ctx) => _KreedaLoadingOverlay(message: message),
    );

    overlayState.insert(_overlayEntry!);
  }

  /// Dismisses the full-screen loading overlay.
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// Full-screen frosted overlay with centered Neumorphic cricket loading card.
class _KreedaLoadingOverlay extends StatelessWidget {
  final String message;

  const _KreedaLoadingOverlay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Frosted glass dimmed backdrop
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
            ),
          ),
          // Centered Neumorphic loading card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.border(context).withValues(alpha: 0.5),
                    width: 0.8,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const KreedaLoadingWidget(size: 80),
                    const SizedBox(height: 20),
                    Text(
                      'KREEDA',
                      style: AppTypography.headlineMedium(
                        AppColors.primary(context),
                      ).copyWith(letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption(
                        AppColors.textSecondary(context),
                      ).copyWith(letterSpacing: 1.0, fontWeight: FontWeight.w600),
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
}

/// Reusable inline animated cricket ball loader.
class KreedaLoadingWidget extends StatefulWidget {
  final double size;
  final String? message;

  const KreedaLoadingWidget({
    super.key,
    this.size = 64.0,
    this.message,
  });

  @override
  State<KreedaLoadingWidget> createState() => _KreedaLoadingWidgetState();
}

class _KreedaLoadingWidgetState extends State<KreedaLoadingWidget>
    with TickerProviderStateMixin {
  late final AnimationController _spinCtrl;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    // Continuous 360 degree cricket ball spin
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // Subtle breathing pulse for the outer energy aura
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ballSize = widget.size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_spinCtrl, _pulseCtrl]),
          builder: (context, _) {
            final pulseScale = 1.0 + (_pulseCtrl.value * 0.08);

            return SizedBox(
              width: ballSize * 1.3,
              height: ballSize * 1.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Ambient breathing sports energy halo
                  Transform.scale(
                    scale: pulseScale,
                    child: Container(
                      width: ballSize * 1.15,
                      height: ballSize * 1.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withValues(
                              alpha: 0.25 + (_pulseCtrl.value * 0.20),
                            ),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Spinning dashed boundary orbit ring
                  Transform.rotate(
                    angle: -_spinCtrl.value * 2 * math.pi * 0.5,
                    child: CustomPaint(
                      size: Size(ballSize * 1.25, ballSize * 1.25),
                      painter: _OrbitRingPainter(
                        color: AppColors.primaryOrange.withValues(alpha: 0.35),
                      ),
                    ),
                  ),

                  // 3. 3D Cricket Ball with rotating stitched seam
                  CustomPaint(
                    size: Size(ballSize, ballSize),
                    painter: _CricketBallPainter(
                      spinProgress: _spinCtrl.value,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.message!,
            style: AppTypography.caption(AppColors.textSecondary(context)),
          ),
        ],
      ],
    );
  }
}

/// CustomPainter rendering a 3D cricket ball sphere with rotating white seam stitches.
class _CricketBallPainter extends CustomPainter {
  final double spinProgress;

  _CricketBallPainter({required this.spinProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. 3D Leather sphere with specular sports lighting
    final spherePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.40),
        radius: 0.85,
        colors: const [
          Color(0xFFFF7A45), // Specular light highlight
          Color(0xFFFF4500), // Energy Vermilion body
          Color(0xFFD63000), // Deep cricket crimson
          Color(0xFF8A1700), // Deep shadow edge
        ],
        stops: const [0.0, 0.45, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, spherePaint);

    // 2. Rotating Cricket Seam
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Rotate the seam continuously
    final angle = spinProgress * 2 * math.pi;
    canvas.rotate(angle);

    final seamWidth = radius * 0.14;
    final seamRect = Rect.fromCenter(
      center: Offset.zero,
      width: seamWidth,
      height: radius * 1.95,
    );

    // Center seam base ribbon
    final seamBasePaint = Paint()
      ..color = const Color(0xFF6B1200)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(seamRect, Radius.circular(seamWidth / 2)),
      seamBasePaint,
    );

    // Individual white chevron stitches along the seam
    final stitchPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = math.max(1.2, radius * 0.05)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final stitchCount = 12;
    final step = (radius * 1.8) / stitchCount;
    final startY = -radius * 0.85;

    for (int i = 0; i <= stitchCount; i++) {
      final y = startY + (i * step);
      // Crossed stitch chevrons
      canvas.drawLine(
        Offset(-seamWidth * 0.45, y - 1.5),
        Offset(seamWidth * 0.45, y + 1.5),
        stitchPaint,
      );
    }

    canvas.restore();

    // 3. Ambient specular sheen overlay across the top-left hemisphere
    final sheenPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.45,
        colors: [
          Colors.white.withValues(alpha: 0.38),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sheenPaint);
  }

  @override
  bool shouldRepaint(covariant _CricketBallPainter oldDelegate) {
    return oldDelegate.spinProgress != spinProgress;
  }
}

/// Orbiting dashed boundary particle ring
class _OrbitRingPainter extends CustomPainter {
  final Color color;

  _OrbitRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const segmentCount = 8;
    const sweep = (2 * math.pi) / segmentCount;
    const arcLength = sweep * 0.55;

    for (int i = 0; i < segmentCount; i++) {
      final start = i * sweep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        arcLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) => false;
}
