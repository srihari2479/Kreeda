import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Global Creative Cricket Loading System for Kreeda ("Cricket Lives Here").
/// Features an iconic batsman executing the legendary Helicopter Shot:
/// 1. Fast dipping yorker delivery
/// 2. Explosive bottom-hand impact with expanding shockwave and sparks
/// 3. Trademark 360° overhead helicopter bat whirl with glowing energy trail
/// 4. Rocketing sixer soaring into the stadium sky with a radiant comet tail.
class KreedaLoading {
  static OverlayEntry? _overlayEntry;

  /// Shows a modal full-screen frosted glass loading overlay.
  static void show(
    BuildContext context, {
    String message = 'FETCHING LIVE CRICKET FEEDS...',
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
    final isDark = AppColors.isDark(context);

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Frosted glass dimmed backdrop
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withValues(alpha: isDark ? 0.60 : 0.40),
            ),
          ),
          // Centered Neumorphic loading card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.border(context),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const KreedaLoadingWidget(size: 110),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'KREEDA',
                          style: AppTypography.headlineMedium(
                            AppColors.primary(context),
                          ).copyWith(letterSpacing: 2.0, fontSize: 20),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primaryOrange.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            'HELICOPTER SHOT',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryOrange,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTypography.caption(
                        AppColors.textSecondary(context),
                      ).copyWith(letterSpacing: 0.8, fontWeight: FontWeight.w600),
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

/// Reusable inline animated Helicopter Shot loader widget.
/// Adapts seamlessly from compact 48dp sizes to full 140dp showcases.
class KreedaLoadingWidget extends StatefulWidget {
  final double size;
  final String? message;

  const KreedaLoadingWidget({
    super.key,
    this.size = 80.0,
    this.message,
  });

  @override
  State<KreedaLoadingWidget> createState() => _KreedaLoadingWidgetState();
}

class _KreedaLoadingWidgetState extends State<KreedaLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    // 1800ms seamless, rhythmic loop of the complete helicopter shot sequence
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final primaryColor = AppColors.primary(context);
    final accentGold = AppColors.passGold;
    final silhouetteColor = isDark ? Colors.white : AppColors.primaryNavy;
    final borderColor = AppColors.border(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animCtrl,
          builder: (context, _) {
            return SizedBox(
              width: widget.size * 1.35,
              height: widget.size,
              child: CustomPaint(
                size: Size(widget.size * 1.35, widget.size),
                painter: _HelicopterShotPainter(
                  progress: _animCtrl.value,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  accentGold: accentGold,
                  silhouetteColor: silhouetteColor,
                  borderColor: borderColor,
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 10),
          Text(
            widget.message!,
            style: AppTypography.caption(AppColors.textSecondary(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// High-Performance Vector CustomPainter visualizing the iconic Helicopter Shot.
/// Zero raster bitmap assets, zero offscreen buffers — 100% hardware vector accelerated (60-120 FPS).
class _HelicopterShotPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 (1800ms loop)
  final bool isDark;
  final Color primaryColor;
  final Color accentGold;
  final Color silhouetteColor;
  final Color borderColor;

  _HelicopterShotPainter({
    required this.progress,
    required this.isDark,
    required this.primaryColor,
    required this.accentGold,
    required this.silhouetteColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double s = math.min(w, h);

    // Dynamic key coordinates
    final double groundY = h * 0.82;
    final double stanceX = w * 0.38;
    final Offset wristPivot = Offset(w * 0.44, h * 0.54);
    final Offset impactPoint = Offset(w * 0.52, h * 0.76);

    // ----------------------------------------------------
    // 1. Ambient Stadium Halo Glow
    // ----------------------------------------------------
    final haloCenter = Offset(w * 0.46, h * 0.50);
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: isDark ? 0.16 : 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: haloCenter, radius: s * 0.65));
    canvas.drawCircle(haloCenter, s * 0.65, haloPaint);

    // ----------------------------------------------------
    // 2. Pitch Crease & Stumps Silhouette
    // ----------------------------------------------------
    final groundPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.40)
      ..strokeWidth = math.max(0.8, s * 0.012)
      ..strokeCap = StrokeCap.round;

    // Pitch crease line
    canvas.drawLine(Offset(w * 0.12, groundY), Offset(w * 0.88, groundY), groundPaint);

    // Popping crease mark
    canvas.drawLine(
      Offset(w * 0.36, groundY - s * 0.08),
      Offset(w * 0.36, groundY + s * 0.04),
      groundPaint,
    );

    // 3 Stumps & Bails behind batsman
    final stumpPaint = Paint()
      ..color = (isDark ? Colors.white : AppColors.primaryNavy).withValues(alpha: 0.35)
      ..strokeWidth = math.max(1.0, s * 0.016)
      ..strokeCap = StrokeCap.round;

    final double stumpX = w * 0.22;
    final double stumpHeight = s * 0.24;
    canvas.drawLine(Offset(stumpX - 4, groundY), Offset(stumpX - 4, groundY - stumpHeight), stumpPaint);
    canvas.drawLine(Offset(stumpX, groundY), Offset(stumpX, groundY - stumpHeight), stumpPaint);
    canvas.drawLine(Offset(stumpX + 4, groundY), Offset(stumpX + 4, groundY - stumpHeight), stumpPaint);
    // Bails
    canvas.drawLine(
      Offset(stumpX - 5.5, groundY - stumpHeight - 1),
      Offset(stumpX + 5.5, groundY - stumpHeight - 1),
      stumpPaint..strokeWidth = math.max(1.0, s * 0.018),
    );

    // ----------------------------------------------------
    // 3. Kinetic Phase Timings
    // ----------------------------------------------------
    // Phase 1: Yorker Delivery (0.00 -> 0.24)
    // Phase 2: Power Impact Flash (0.24 -> 0.34)
    // Phase 3: Trademark 360° Helicopter Bat Twirl (0.26 -> 0.76)
    // Phase 4: Rocketing Sixer Flight (0.26 -> 0.85)
    // Phase 5: Batsman Follow-through & Reset (0.76 -> 1.00)

    final bool isIncoming = progress < 0.24;
    final bool isImpact = progress >= 0.24 && progress <= 0.34;
    final bool isTwirling = progress >= 0.24 && progress <= 0.78;
    final bool isOutgoing = progress >= 0.26 && progress <= 0.88;

    // ----------------------------------------------------
    // 4. Batsman Silhouette (Athletic Anatomy & Stance)
    // ----------------------------------------------------
    final bodyPaint = Paint()
      ..color = silhouetteColor
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // Torso dynamic crouch & coil
    double crouchOffset = 0.0;
    if (progress < 0.24) {
      crouchOffset = math.sin((progress / 0.24) * math.pi) * (s * 0.03);
    }

    final double hipX = stanceX;
    final double hipY = (h * 0.58) + crouchOffset;

    // Back leg (planted on crease)
    final backLegPath = Path()
      ..moveTo(hipX - s * 0.03, hipY)
      ..lineTo(hipX - s * 0.08, groundY)
      ..lineTo(hipX - s * 0.03, groundY)
      ..lineTo(hipX + s * 0.01, hipY)
      ..close();
    canvas.drawPath(backLegPath, bodyPaint);

    // Front leg with batting pad (bent forward towards the yorker)
    final frontLegPath = Path()
      ..moveTo(hipX + s * 0.02, hipY)
      ..lineTo(w * 0.46, groundY - s * 0.10) // Knee roll
      ..lineTo(w * 0.50, groundY)            // Foot planted
      ..lineTo(w * 0.46, groundY)
      ..lineTo(w * 0.42, groundY - s * 0.10)
      ..lineTo(hipX - s * 0.01, hipY)
      ..close();
    canvas.drawPath(frontLegPath, bodyPaint);

    // Pad colored trim lines
    final padTrimPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.85)
      ..strokeWidth = math.max(1.0, s * 0.018)
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.44, groundY - s * 0.09),
      Offset(w * 0.48, groundY - s * 0.01),
      padTrimPaint,
    );

    // Torso & Sports Jersey
    final double shoulderX = w * 0.42;
    final double shoulderY = (h * 0.40) + crouchOffset;
    final torsoPath = Path()
      ..moveTo(hipX - s * 0.03, hipY)
      ..lineTo(shoulderX - s * 0.04, shoulderY)
      ..lineTo(shoulderX + s * 0.05, shoulderY)
      ..lineTo(hipX + s * 0.03, hipY)
      ..close();
    canvas.drawPath(torsoPath, bodyPaint);

    // Jersey energy stripe
    final stripePath = Path()
      ..moveTo(shoulderX - s * 0.01, shoulderY)
      ..lineTo(shoulderX + s * 0.03, shoulderY)
      ..lineTo(hipX + s * 0.01, hipY)
      ..lineTo(hipX - s * 0.01, hipY)
      ..close();
    canvas.drawPath(stripePath, accentPaint);

    // Batting Helmet & Visor
    final helmetCenter = Offset(shoulderX + s * 0.01, shoulderY - s * 0.08);
    final helmetRadius = s * 0.065;
    canvas.drawCircle(helmetCenter, helmetRadius, bodyPaint);

    // Helmet visor peak
    final visorPath = Path()
      ..moveTo(helmetCenter.dx + helmetRadius * 0.4, helmetCenter.dy - helmetRadius * 0.3)
      ..lineTo(helmetCenter.dx + helmetRadius * 1.35, helmetCenter.dy + helmetRadius * 0.15)
      ..lineTo(helmetCenter.dx + helmetRadius * 0.7, helmetCenter.dy + helmetRadius * 0.5)
      ..close();
    canvas.drawPath(visorPath, accentPaint);

    // ----------------------------------------------------
    // 5. The Bat & 360° Helicopter Whirl Physics
    // ----------------------------------------------------
    final double batLength = s * 0.42;
    final double batWidth = math.max(2.5, s * 0.042);
    double batAngle = -0.85; // Initial backlift stance angle (radians)

    if (progress < 0.24) {
      // Setup downswing towards contact
      final p = progress / 0.24;
      batAngle = ui.lerpDouble(-0.85, 0.28, p * p)!;
    } else if (isTwirling) {
      // The 360° Helicopter Whirl!
      // Full rotational flick generated by bottom-hand wrist torque
      final p = (progress - 0.24) / 0.54;
      final curvedP = Curves.fastOutSlowIn.transform(p);
      batAngle = 0.28 + (curvedP * 2 * math.pi); // Full 360 degree revolution
    } else {
      // Follow-through and reset to stance
      final p = (progress - 0.78) / 0.22;
      final curvedP = Curves.easeInOutCubic.transform(p);
      batAngle = ui.lerpDouble(0.28 + 2 * math.pi, 0.28 + 2 * math.pi + (math.pi * 0.65), curvedP)!;
    }

    // Helicopter Motion Swoosh Trail (The signature visual element)
    if (isTwirling) {
      final p = (progress - 0.24) / 0.54;
      final sweepAngle = math.min(1.85, p * 2.2 * math.pi);
      final trailStartAngle = batAngle - sweepAngle;
      final trailRadius = batLength * 0.95;

      final trailRect = Rect.fromCircle(center: wristPivot, radius: trailRadius);

      // Outer luminous halo arc
      final trailAuraPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(3.0, s * 0.065)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          wristPivot,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.15),
            primaryColor.withValues(alpha: 0.55),
            accentGold.withValues(alpha: 0.85),
          ],
          [0.0, 0.35, 0.75, 1.0],
          TileMode.clamp,
          trailStartAngle,
          trailStartAngle + sweepAngle,
        );

      canvas.drawArc(trailRect, trailStartAngle, sweepAngle, false, trailAuraPaint);

      // Core electric wavefront beam
      final trailCorePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, s * 0.025)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          wristPivot,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.4),
            Colors.white,
          ],
          [0.0, 0.6, 1.0],
          TileMode.clamp,
          trailStartAngle,
          trailStartAngle + sweepAngle,
        );

      canvas.drawArc(trailRect, trailStartAngle, sweepAngle, false, trailCorePaint);
    }

    // Draw the Batsman's Arms holding the handle
    final armPaint = Paint()
      ..color = silhouetteColor
      ..strokeWidth = math.max(2.5, s * 0.045)
      ..strokeCap = StrokeCap.round;

    final handPos = wristPivot + Offset(math.cos(batAngle) * (batLength * 0.22), math.sin(batAngle) * (batLength * 0.22));
    canvas.drawLine(Offset(shoulderX, shoulderY + s * 0.04), handPos, armPaint);

    // Draw the Bat (Handle + Willow Blade + Rubber Toe)
    canvas.save();
    canvas.translate(wristPivot.dx, wristPivot.dy);
    canvas.rotate(batAngle);

    // Bat Handle (Grip)
    final handlePaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = math.max(1.5, batWidth * 0.45)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-batLength * 0.12, 0), Offset(batLength * 0.22, 0), handlePaint);

    // Bat Blade (English Willow gradient)
    final bladeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(batLength * 0.22, -batWidth / 2, batLength * 0.78, batWidth),
      Radius.circular(batWidth * 0.25),
    );
    final bladePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(batLength * 0.22, -batWidth / 2),
        Offset(batLength * 0.22, batWidth / 2),
        [
          const Color(0xFFFDE68A), // Light willow face
          const Color(0xFFD97706), // English willow wood grain
          const Color(0xFF92400E), // Shadow spine
        ],
      );
    canvas.drawRRect(bladeRect, bladePaint);

    // Bat Brand Colored Sticker (Energy Orange signature crest)
    final stickerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(batLength * 0.38, -batWidth * 0.42, batLength * 0.32, batWidth * 0.84),
      Radius.circular(batWidth * 0.15),
    );
    canvas.drawRRect(stickerRect, accentPaint);

    canvas.restore();

    // ----------------------------------------------------
    // 6. Impact Shockwave & Particle Sparks (Phase 2)
    // ----------------------------------------------------
    if (isImpact) {
      final p = (progress - 0.24) / 0.10; // 0.0 to 1.0 during impact
      final shockwaveRadius = p * (s * 0.32);
      final shockwaveAlpha = (1.0 - p).clamp(0.0, 1.0);

      // Expanding sonic shockwave ring
      final shockwavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, (1.0 - p) * (s * 0.04))
        ..color = primaryColor.withValues(alpha: shockwaveAlpha * 0.85);
      canvas.drawCircle(impactPoint, shockwaveRadius, shockwavePaint);

      // Secondary gold shockwave
      final shockwaveGold = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.8, (1.0 - p) * (s * 0.025))
        ..color = accentGold.withValues(alpha: shockwaveAlpha * 0.65);
      canvas.drawCircle(impactPoint, shockwaveRadius * 0.7, shockwaveGold);

      // Core contact flash
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: shockwaveAlpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(impactPoint, (1.0 - p) * (s * 0.08), flashPaint);

      // 6 Radiating Particle Sparks
      const sparkCount = 6;
      for (int i = 0; i < sparkCount; i++) {
        final sparkAngle = (i * (2 * math.pi / sparkCount)) + 0.35;
        final sparkDist = p * (s * 0.26);
        final sparkPos = impactPoint + Offset(math.cos(sparkAngle) * sparkDist, math.sin(sparkAngle) * sparkDist);

        final sparkPaint = Paint()
          ..color = (i.isEven ? accentGold : primaryColor).withValues(alpha: shockwaveAlpha)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(sparkPos, math.max(1.0, (1.0 - p) * (s * 0.022)), sparkPaint);
      }
    }

    // ----------------------------------------------------
    // 7. Ball Physics & Sixer Comet Trajectory
    // ----------------------------------------------------
    Offset ballPos = Offset.zero;
    bool shouldDrawBall = false;

    if (isIncoming) {
      // Yorker dips sharply into the blockhole
      final p = progress / 0.24;
      final curvedP = p * p; // Gravitational acceleration
      final startPos = Offset(w * 0.94, h * 0.24);
      ballPos = Offset(
        ui.lerpDouble(startPos.dx, impactPoint.dx, p)!,
        ui.lerpDouble(startPos.dy, impactPoint.dy, curvedP)!,
      );
      shouldDrawBall = true;
    } else if (isOutgoing) {
      // Ball launched skyward on explosive sixer trajectory
      final p = (progress - 0.26) / 0.62;
      final curvedP = Curves.easeOutQuad.transform(p);

      final targetX = w * 1.05;
      final targetY = h * 0.06;

      ballPos = Offset(
        ui.lerpDouble(impactPoint.dx, targetX, p)!,
        ui.lerpDouble(impactPoint.dy, targetY, curvedP)!,
      );
      shouldDrawBall = true;

      // Radiant Comet Tail behind soaring ball
      final tailLength = math.min(s * 0.35, p * (s * 0.65));
      final tailVector = (ballPos - impactPoint);
      if (tailVector.distance > 2) {
        final norm = tailVector / tailVector.distance;
        final tailStart = ballPos - (norm * tailLength);

        final cometPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(2.0, s * 0.038)
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(
            tailStart,
            ballPos,
            [
              Colors.transparent,
              primaryColor.withValues(alpha: 0.35),
              accentGold.withValues(alpha: 0.85),
            ],
            [0.0, 0.45, 1.0],
          );
        canvas.drawLine(tailStart, ballPos, cometPaint);

        // Core fiery light trail
        final cometCorePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, s * 0.016)
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(
            tailStart,
            ballPos,
            [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.9),
            ],
          );
        canvas.drawLine(tailStart + (norm * (tailLength * 0.4)), ballPos, cometCorePaint);
      }
    }

    // Render the 3D Leather Cricket Ball
    if (shouldDrawBall) {
      final ballRadius = math.max(3.2, s * 0.042);

      // Ball ambient glow
      final ballGlowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
      canvas.drawCircle(ballPos, ballRadius * 1.3, ballGlowPaint);

      // 3D Leather sphere gradient
      final ballSpherePaint = Paint()
        ..shader = ui.Gradient.radial(
          ballPos - Offset(ballRadius * 0.3, ballRadius * 0.3),
          ballRadius,
          [
            const Color(0xFFFF7A45), // Specular reflection
            const Color(0xFFEF4444), // Cricket Red
            const Color(0xFF991B1B), // Shadow rim
          ],
          [0.0, 0.65, 1.0],
        );
      canvas.drawCircle(ballPos, ballRadius, ballSpherePaint);

      // Cricket seam stripe
      final seamPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..strokeWidth = math.max(0.8, ballRadius * 0.22)
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(center: ballPos, radius: ballRadius * 0.75),
        -math.pi / 4,
        math.pi / 2,
        false,
        seamPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HelicopterShotPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.primaryColor != primaryColor;
  }
}
