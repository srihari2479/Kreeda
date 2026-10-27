import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Global Creative Cricket Loading System for Kreeda ("Cricket Lives Here").
/// Features an athletic cricketer executing MS Dhoni's legendary Helicopter Shot:
/// 1. Fast dipping inswinging yorker targeted into the blockhole
/// 2. Bat accelerates down in the front circular loading arc
/// 3. Continuous circular sweet-spot impact contact flash & sparks
/// 4. Trademark 360° front-angle circular helicopter rotor bat whirl acting as the circular loading visual
/// 5. Rocketing sixer soaring into the stadium sky with a radiant dual-core comet tail
/// 6. Clean, distraction-free dimmed frosted background overlay without any container boxes or text.
class KreedaLoading {
  static OverlayEntry? _overlayEntry;

  /// Shows a modal full-screen frosted glass loading overlay with the Helicopter Shot animation.
  static void show(
    BuildContext context, {
    String? message,
  }) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) return;

    // Capture active theme from context to guarantee 100% theme token inheritance
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Theme(
        data: theme,
        child: const _KreedaLoadingOverlay(),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  /// Dismisses the full-screen loading overlay.
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// Full-screen frosted overlay with cleanly centered Helicopter Shot animation.
/// Completely free of container cards, borders, or text — pure, cinematic sports action.
class _KreedaLoadingOverlay extends StatefulWidget {
  const _KreedaLoadingOverlay();

  @override
  State<_KreedaLoadingOverlay> createState() => _KreedaLoadingOverlayState();
}

class _KreedaLoadingOverlayState extends State<_KreedaLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;

  @override
  void initState() {
    super.initState();
    // Smooth, cinematic entrance animation (fade + scale)
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _entranceCtrl,
          curve: Curves.easeOut,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Frosted glass dimmed backdrop with 12px Gaussian blur
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: Colors.black.withValues(alpha: isDark ? 0.72 : 0.54),
              ),
            ),
            // Centered Helicopter Shot Animation (Floating freely on dimmed backdrop)
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.90, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _entranceCtrl,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: const KreedaLoadingWidget(size: 165),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable inline animated Helicopter Shot loader widget.
/// Adapts seamlessly from compact 64dp sizes to full 180dp showcases.
class KreedaLoadingWidget extends StatefulWidget {
  final double size;
  final String? message;

  const KreedaLoadingWidget({
    super.key,
    this.size = 100.0,
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
    // 2400ms rhythmic, cinematic loop of the complete helicopter shot sequence
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
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
    final borderColor = AppColors.border(context);

    final canvasWidth = widget.size * 1.55;
    final canvasHeight = widget.size;

    return SizedBox(
      width: canvasWidth,
      height: canvasHeight,
      child: AnimatedBuilder(
        animation: _animCtrl,
        builder: (context, _) {
          return CustomPaint(
            size: Size(canvasWidth, canvasHeight),
            painter: _HelicopterShotPainter(
              progress: _animCtrl.value,
              isDark: isDark,
              primaryColor: primaryColor,
              accentGold: accentGold,
              borderColor: borderColor,
            ),
          );
        },
      ),
    );
  }
}

/// High-Performance Vector CustomPainter visualizing MS Dhoni's iconic Helicopter Shot.
/// Bat rotates in a continuous front-angle circular loader wheel, delivering a true circular loading visual.
/// 100% Vector Math & GPU-accelerated Canvas operations (60-120 FPS guaranteed).
class _HelicopterShotPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 (2400ms loop)
  final bool isDark;
  final Color primaryColor;
  final Color accentGold;
  final Color borderColor;

  _HelicopterShotPainter({
    required this.progress,
    required this.isDark,
    required this.primaryColor,
    required this.accentGold,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double s = math.min(w, h);

    // Dynamic ground & layout (horizontally centered composition)
    final double groundY = h * 0.80;
    final double stanceX = w * 0.5 - s * 0.135;

    // ----------------------------------------------------
    // 1. Front-Angle Circular Loader Geometry
    // ----------------------------------------------------
    // The circular loading wheel is centered prominently in front of the batsman's chest!
    final circleCenter = Offset(stanceX + s * 0.22, groundY - s * 0.28);
    final double rx = s * 0.30;
    final double ry = s * 0.28;

    // Impact is at theta = 65° (bottom-right of the circular loader in the blockhole)
    const double impactAngle = 65.0 * math.pi / 180.0;
    final impactPoint = circleCenter + Offset(
      math.cos(impactAngle) * rx,
      math.sin(impactAngle) * ry,
    );
    const double backliftAngle = 225.0 * math.pi / 180.0; // 225° (top-left behind batsman)

    // ----------------------------------------------------
    // 2. Stadium Ambient Floodlight Glow
    // ----------------------------------------------------
    final floodlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: isDark ? 0.22 : 0.12),
          accentGold.withValues(alpha: isDark ? 0.08 : 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.50, 1.0],
      ).createShader(
        Rect.fromCircle(center: circleCenter, radius: rx * 1.6),
      );
    canvas.drawCircle(circleCenter, rx * 1.6, floodlightPaint);

    // ----------------------------------------------------
    // 3. Pitch Crease & Timber Stumps
    // ----------------------------------------------------
    final groundPaint = Paint()
      ..color = borderColor.withValues(alpha: isDark ? 0.45 : 0.35)
      ..strokeWidth = math.max(1.0, s * 0.012)
      ..strokeCap = StrokeCap.round;

    // Pitch turf crease line
    canvas.drawLine(
      Offset(w * 0.02, groundY),
      Offset(w * 0.98, groundY),
      groundPaint,
    );

    // Popping crease mark
    canvas.drawLine(
      Offset(stanceX, groundY - s * 0.055),
      Offset(stanceX, groundY + s * 0.025),
      groundPaint,
    );

    // Timber Stumps & Bails behind batsman
    final stumpX = stanceX - s * 0.25;
    final stumpHeight = s * 0.22;
    final stumpPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD97706).withValues(alpha: isDark ? 0.90 : 0.75),
          const Color(0xFF78350F).withValues(alpha: isDark ? 0.95 : 0.85),
        ],
      ).createShader(
        Rect.fromLTWH(stumpX - 5, groundY - stumpHeight, 10, stumpHeight),
      )
      ..strokeWidth = math.max(1.4, s * 0.015)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(stumpX - 4.0, groundY),
      Offset(stumpX - 4.0, groundY - stumpHeight),
      stumpPaint,
    );
    canvas.drawLine(
      Offset(stumpX, groundY),
      Offset(stumpX, groundY - stumpHeight),
      stumpPaint,
    );
    canvas.drawLine(
      Offset(stumpX + 4.0, groundY),
      Offset(stumpX + 4.0, groundY - stumpHeight),
      stumpPaint,
    );
    // Bails on top
    canvas.drawLine(
      Offset(stumpX - 5.5, groundY - stumpHeight - 1.5),
      Offset(stumpX + 5.5, groundY - stumpHeight - 1.5),
      stumpPaint..strokeWidth = math.max(1.4, s * 0.018),
    );

    // ----------------------------------------------------
    // 4. FRONT-ANGLE CIRCULAR LOADER KINEMATICS
    // ----------------------------------------------------
    // Continuous Circular Bat Angle Kinematics (Unified Counter-Clockwise Rotation):
    // Phase 1: 0.00 to 0.25 (Ball arrives, bat downswings behind body & along turf into blockhole impact)
    // Phase 2: 0.25 to 0.75 (THE 360° HELICOPTER WHIRL in the front circular loader!)
    // Phase 3: 0.75 to 1.00 (High follow-through poise and settle back to backlift)
    double batAngle;
    double trailSweep;

    if (progress < 0.25) {
      final p = progress / 0.25;
      final curved = p * p; // Downswing gravitational acceleration
      const delta = impactAngle - backliftAngle; // -160° (counter-clockwise sweep into ball)
      batAngle = backliftAngle + curved * delta;
      trailSweep = p * 0.35;
    } else if (progress <= 0.75) {
      final p = (progress - 0.25) / 0.50;
      final curved = (1.0 - math.cos(p * math.pi)) / 2; // Smooth S-curve rotation
      batAngle = impactAngle - curved * 2 * math.pi; // Full 360° counter-clockwise twirl!
      trailSweep = 0.42;
    } else {
      final p = (progress - 0.75) / 0.25;
      final curved = (1.0 - math.cos(p * math.pi)) / 2;
      const startA = impactAngle - 2 * math.pi;
      const targetA = backliftAngle - 4 * math.pi; // Continue counter-clockwise into next backlift!
      batAngle = ui.lerpDouble(startA, targetA, curved)!;
      trailSweep = (1.0 - p) * 0.42;
    }

    // Active Glowing Speed Arc Trailing Behind Bat Tip (Circular Loading Spinner)
    if (trailSweep > 0.02) {
      const int numSteps = 38;
      final arcPoints = <Offset>[];
      final alphas = <double>[];

      for (int i = 0; i < numSteps; i++) {
        final subP = i / (numSteps - 1).toDouble();
        // Bat always rotates counter-clockwise (decreasing angle), so trail is in positive direction
        final subAngle = batAngle + subP * (trailSweep * 2 * math.pi);
        arcPoints.add(circleCenter + Offset(math.cos(subAngle) * rx, math.sin(subAngle) * ry));
        alphas.add(1.0 - subP);
      }

      for (int i = 1; i < arcPoints.length; i++) {
        final al = alphas[i];
        final arcOuterPaint = Paint()
          ..color = primaryColor.withValues(alpha: al * 0.85)
          ..strokeWidth = math.max(2.4, s * 0.038)
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(arcPoints[i - 1], arcPoints[i], arcOuterPaint);

        final arcCorePaint = Paint()
          ..color = Colors.white.withValues(alpha: al * 0.95)
          ..strokeWidth = math.max(1.2, s * 0.018)
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(arcPoints[i - 1], arcPoints[i], arcCorePaint);
      }
    }

    // Bat tip position on the circular loader ring
    final tipPos = circleCenter + Offset(
      math.cos(batAngle) * rx,
      math.sin(batAngle) * ry,
    );

    // Leading-edge glowing spark ember at bat tip
    final emberGlow = Paint()
      ..color = primaryColor.withValues(alpha: 0.80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, s * 0.014);
    canvas.drawCircle(tipPos, math.max(4.0, s * 0.040), emberGlow);

    final emberCore = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(tipPos, math.max(2.2, s * 0.022), emberCore);

    // ----------------------------------------------------
    // 5. Clean, Professional Athletic Batsman Silhouette
    // ----------------------------------------------------
    final pantColor = isDark ? const Color(0xFFF1F5F9) : const Color(0xFFE2E8F0);
    final jerseyColor = isDark ? const Color(0xFF0F172A) : AppColors.primaryNavy;
    final skinColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1);
    final padColor = Colors.white;
    final padBorderColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8);

    final pantPaint = Paint()..color = pantColor..style = PaintingStyle.fill;
    final jerseyPaint = Paint()..color = jerseyColor..style = PaintingStyle.fill;
    final skinPaint = Paint()..color = skinColor..style = PaintingStyle.fill;
    final accentPaint = Paint()..color = primaryColor..style = PaintingStyle.fill;
    final padPaint = Paint()..color = padColor..style = PaintingStyle.fill;
    final padBorderPaint = Paint()
      ..color = padBorderColor.withValues(alpha: 0.50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, s * 0.008);
    final padStrapPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(1.2, s * 0.012)
      ..strokeCap = StrokeCap.round;

    // Dynamic athletic weight shift synchronized with swing
    final crouch = math.sin(progress * 2 * math.pi) * (s * 0.015);
    final leanX = math.cos(progress * 2 * math.pi) * (s * 0.010);
    final double stX = stanceX + leanX;
    final Offset hip = Offset(stX, groundY - s * 0.24 + crouch);

    // A. Muscular Athletic Back Leg with Power Heel Lift & Batting Pad
    final thighTop = Offset(hip.dx - s * 0.025, hip.dy + s * 0.005);
    final hamstring = Offset(stX - s * 0.070, hip.dy + s * 0.060);
    final kneeFold = Offset(stX - s * 0.095, groundY - s * 0.095 + crouch * 0.4);
    final heelLifted = Offset(stX - s * 0.188, groundY - s * 0.028);
    final toeBall = Offset(stX - s * 0.160, groundY);
    final toeTip = Offset(stX - s * 0.138, groundY);
    final kneeFront = Offset(stX - s * 0.055, groundY - s * 0.090 + crouch * 0.4);
    final quadFront = Offset(stX - s * 0.020, hip.dy + s * 0.070);
    final thighFront = Offset(hip.dx + s * 0.015, hip.dy + s * 0.025);

    // Rear thigh trousers
    final backThighPath = Path()
      ..moveTo(thighTop.dx, thighTop.dy)
      ..lineTo(hamstring.dx, hamstring.dy)
      ..lineTo(kneeFold.dx - s * 0.005, kneeFold.dy - s * 0.015)
      ..lineTo(kneeFront.dx + s * 0.008, kneeFront.dy - s * 0.015)
      ..lineTo(quadFront.dx, quadFront.dy)
      ..lineTo(thighFront.dx, thighFront.dy)
      ..close();
    canvas.drawPath(backThighPath, pantPaint);

    // Rear Cricket Batting Pad (Contoured with arched instep notch above shoe)
    final rearPadPath = Path()
      ..moveTo(kneeFold.dx - s * 0.010, kneeFold.dy - s * 0.025)
      ..lineTo(kneeFront.dx + s * 0.012, kneeFront.dy - s * 0.020)
      ..lineTo(kneeFront.dx + s * 0.015, kneeFront.dy + s * 0.008)
      ..lineTo(toeTip.dx + s * 0.005, groundY - s * 0.022)
      ..lineTo(toeBall.dx + s * 0.005, groundY - s * 0.026)
      ..lineTo(heelLifted.dx - s * 0.005, groundY - s * 0.022)
      ..lineTo(kneeFold.dx - s * 0.015, kneeFold.dy + s * 0.008)
      ..close();
    canvas.drawPath(rearPadPath, padPaint);
    canvas.drawPath(rearPadPath, padBorderPaint);

    // Rear Pad Straps
    canvas.drawLine(
      Offset(kneeFold.dx - s * 0.008, kneeFold.dy),
      Offset(kneeFront.dx + s * 0.010, kneeFront.dy),
      padStrapPaint,
    );
    canvas.drawLine(
      Offset(stX - s * 0.138, groundY - s * 0.055),
      Offset(stX - s * 0.092, groundY - s * 0.055),
      padStrapPaint,
    );

    // B. Front Leg Lunging Thigh
    final fKnee = Offset(stX + s * 0.145, groundY - s * 0.145 + crouch * 0.6);
    final frontThighPath = Path()
      ..moveTo(hip.dx + s * 0.024, hip.dy + s * 0.008)
      ..lineTo(stX + s * 0.084, hip.dy + s * 0.030)
      ..lineTo(fKnee.dx + s * 0.024, fKnee.dy - s * 0.030)
      ..lineTo(fKnee.dx - s * 0.030, fKnee.dy - s * 0.015)
      ..lineTo(stX + s * 0.038, hip.dy + s * 0.060)
      ..lineTo(hip.dx - s * 0.008, hip.dy + s * 0.024)
      ..close();
    canvas.drawPath(frontThighPath, pantPaint);

    // C. Contoured Professional Cricket Batting Pad (Arched instep sits cleanly above shoe)
    final fToe = Offset(stX + s * 0.290, groundY);
    final fHeel = Offset(stX + s * 0.176, groundY);

    final padPath = Path()
      ..moveTo(fKnee.dx - s * 0.022, fKnee.dy - s * 0.050)
      ..lineTo(fKnee.dx + s * 0.036, fKnee.dy - s * 0.040)
      ..lineTo(fKnee.dx + s * 0.042, fKnee.dy + s * 0.010)
      ..lineTo(fToe.dx - s * 0.010, groundY - s * 0.025)
      ..lineTo(fHeel.dx + s * 0.015, groundY - s * 0.028)
      ..lineTo(fHeel.dx - s * 0.005, groundY - s * 0.022)
      ..lineTo(fKnee.dx - s * 0.028, fKnee.dy + s * 0.010)
      ..close();
    canvas.drawPath(padPath, padPaint);
    canvas.drawPath(padPath, padBorderPaint);

    // Front Batting Pad Knee Roll & Straps
    canvas.drawLine(
      Offset(fKnee.dx - s * 0.020, fKnee.dy - s * 0.005),
      Offset(fKnee.dx + s * 0.036, fKnee.dy + s * 0.005),
      padStrapPaint,
    );
    canvas.drawLine(
      Offset(fKnee.dx - s * 0.018, fKnee.dy + s * 0.020),
      Offset(fKnee.dx + s * 0.038, fKnee.dy + s * 0.028),
      padStrapPaint,
    );
    canvas.drawLine(
      Offset(fHeel.dx + s * 0.005, groundY - s * 0.060),
      Offset(fToe.dx - s * 0.020, groundY - s * 0.055),
      padStrapPaint,
    );

    // Spiked Athletic Shoes
    final shoeSolePaint = Paint()..color = primaryColor..style = PaintingStyle.fill;
    final shoeBodyPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    // Rear Athletic Spiked Shoe (Elevated Heel with Flexed Toe Spikes)
    final rearShoePath = Path()
      ..moveTo(heelLifted.dx, heelLifted.dy)
      ..lineTo(toeBall.dx, toeBall.dy)
      ..lineTo(toeTip.dx, toeTip.dy)
      ..lineTo(toeTip.dx, toeTip.dy - s * 0.016)
      ..lineTo(heelLifted.dx, heelLifted.dy - s * 0.014)
      ..close();
    canvas.drawPath(rearShoePath, shoeBodyPaint);

    // Orange cleat spike sole gripping turf at angle
    final rearSpikePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(2.0, s * 0.015)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(heelLifted, toeBall, rearSpikePaint);

    // Front Athletic Cricket Shoe (Planted firmly on popping crease)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(fHeel.dx - 1.5, groundY - s * 0.020, fToe.dx + 1.5, groundY),
        Radius.circular(s * 0.006),
      ),
      shoeBodyPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(fHeel.dx - 1.5, groundY - s * 0.008, fToe.dx + 1.5, groundY),
      shoeSolePaint,
    );

    // D. Athletic Torso & Team Jersey
    final waist = Offset(stX + s * 0.015, hip.dy - s * 0.015);
    final chest = Offset(stX + s * 0.092, groundY - s * 0.370 + crouch);
    final shoulderR = Offset(stX + s * 0.122, groundY - s * 0.408 + crouch);
    final shoulderL = Offset(stX + s * 0.060, groundY - s * 0.400 + crouch);

    final torsoPath = Path()
      ..moveTo(hip.dx - s * 0.030, hip.dy)
      ..lineTo(waist.dx - s * 0.046, waist.dy - s * 0.046)
      ..lineTo(shoulderL.dx - s * 0.030, shoulderL.dy)
      ..lineTo(shoulderR.dx + s * 0.008, shoulderR.dy + s * 0.008)
      ..lineTo(chest.dx + s * 0.046, chest.dy + s * 0.030)
      ..lineTo(waist.dx + s * 0.046, waist.dy)
      ..lineTo(hip.dx + s * 0.030, hip.dy)
      ..close();
    canvas.drawPath(torsoPath, jerseyPaint);

    // Dynamic Team Jersey Diagonal Sash
    final sashPath = Path()
      ..moveTo(shoulderL.dx - s * 0.008, shoulderL.dy + s * 0.008)
      ..lineTo(shoulderL.dx + s * 0.030, shoulderL.dy + s * 0.012)
      ..lineTo(waist.dx + s * 0.030, waist.dy - s * 0.008)
      ..lineTo(waist.dx - s * 0.008, waist.dy - s * 0.008)
      ..close();
    canvas.drawPath(sashPath, accentPaint);

    // E. Ergonomic Neck & Professional Batting Helmet (Masuri Pro Style)
    final neckBase = Offset(stX + s * 0.080, shoulderL.dy - s * 0.005);
    final headCenter = Offset(stX + s * 0.105, groundY - s * 0.465 + crouch);

    // Natural athletic neck nestled into jersey
    final neckPath = Path()
      ..moveTo(neckBase.dx - s * 0.018, neckBase.dy)
      ..lineTo(headCenter.dx - s * 0.014, headCenter.dy + s * 0.022)
      ..lineTo(headCenter.dx + s * 0.016, headCenter.dy + s * 0.025)
      ..lineTo(neckBase.dx + s * 0.018, neckBase.dy)
      ..close();
    canvas.drawPath(neckPath, skinPaint);

    // Jersey V-collar trim
    final collarPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(1.2, s * 0.012)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(neckBase.dx - s * 0.020, neckBase.dy),
      Offset(neckBase.dx, neckBase.dy + s * 0.010),
      collarPaint,
    );
    canvas.drawLine(
      Offset(neckBase.dx, neckBase.dy + s * 0.010),
      Offset(neckBase.dx + s * 0.020, neckBase.dy),
      collarPaint,
    );

    // Helmet dome (Streamlined aerodynamic shell)
    final helmetRadius = s * 0.038;
    canvas.drawCircle(headCenter, helmetRadius, jerseyPaint);

    // Ear protector contour cup
    final earGuardPaint = Paint()
      ..color = isDark ? const Color(0xFF020617) : const Color(0xFF050B18)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: headCenter + Offset(-s * 0.008, s * 0.010),
        width: s * 0.022,
        height: s * 0.020,
      ),
      earGuardPaint,
    );

    // Sleek integrated helmet brow peak (flush aerodynamic visor, NO bird beak!)
    final peakPath = Path()
      ..moveTo(headCenter.dx - s * 0.010, headCenter.dy - s * 0.010)
      ..lineTo(headCenter.dx + s * 0.034, headCenter.dy + s * 0.002)
      ..lineTo(headCenter.dx + s * 0.028, headCenter.dy + s * 0.010)
      ..lineTo(headCenter.dx + s * 0.005, headCenter.dy + s * 0.005)
      ..close();
    canvas.drawPath(peakPath, jerseyPaint);

    // Sleek orange brow accent stripe along visor edge
    final peakStripePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(1.2, s * 0.011)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(headCenter.dx - s * 0.010, headCenter.dy - s * 0.010),
      Offset(headCenter.dx + s * 0.034, headCenter.dy + s * 0.002),
      peakStripePaint,
    );

    // Protective Titanium Face Grille Cage (Chin bar + horizontal sight bars)
    final grillePaint = Paint()
      ..color = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)
      ..strokeWidth = math.max(0.9, s * 0.009)
      ..strokeCap = StrokeCap.round;

    final chinPoint = Offset(headCenter.dx + s * 0.024, headCenter.dy + s * 0.034);
    final earMount = Offset(headCenter.dx - s * 0.008, headCenter.dy + s * 0.012);
    final browMount = Offset(headCenter.dx + s * 0.026, headCenter.dy + s * 0.006);

    // Main structural perimeter bars
    canvas.drawLine(earMount, chinPoint, grillePaint);
    canvas.drawLine(browMount, chinPoint, grillePaint);

    // Dual eye-level vision bars
    canvas.drawLine(
      Offset(headCenter.dx + s * 0.004, headCenter.dy + s * 0.014),
      Offset(headCenter.dx + s * 0.026, headCenter.dy + s * 0.018),
      grillePaint,
    );
    canvas.drawLine(
      Offset(headCenter.dx + s * 0.002, headCenter.dy + s * 0.024),
      Offset(headCenter.dx + s * 0.024, headCenter.dy + s * 0.026),
      grillePaint,
    );

    // F. Wrists at Center of Circular Loader & Articulated Arms
    final wrist = circleCenter + Offset(
      math.cos(batAngle) * (s * 0.035),
      math.sin(batAngle) * (s * 0.035),
    );

    final armPaint = Paint()
      ..color = jerseyColor
      ..strokeWidth = math.max(2.8, s * 0.025)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(shoulderL, wrist - Offset(s * 0.012, s * 0.012), armPaint);
    canvas.drawLine(shoulderR, wrist, armPaint);

    // Batting Gloves (Two-tone molded gloves clutching handle)
    final gloveOuterPaint = Paint()..color = primaryColor..style = PaintingStyle.fill;
    final gloveInnerPaint = Paint()..color = padColor..style = PaintingStyle.fill;
    final gloveCuffPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    canvas.drawCircle(wrist - Offset(s * 0.010, s * 0.010), math.max(2.2, s * 0.020), gloveOuterPaint);
    canvas.drawCircle(wrist + Offset(s * 0.008, s * 0.008), math.max(2.0, s * 0.018), gloveInnerPaint);
    canvas.drawCircle(wrist, math.max(1.0, s * 0.008), gloveCuffPaint);

    // ----------------------------------------------------
    // 6. The Detailed Cricket Bat
    // ----------------------------------------------------
    final bladeWidth = math.max(3.2, s * 0.036);
    final gripLength = s * 0.045;
    final gripTop = wrist - Offset(math.cos(batAngle) * gripLength, math.sin(batAngle) * gripLength);
    final gripBottom = wrist + Offset(math.cos(batAngle) * gripLength, math.sin(batAngle) * gripLength);

    // A. Rubber Grip Handle
    final handlePaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = math.max(1.6, bladeWidth * 0.45)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(gripTop, gripBottom, handlePaint);

    // B. English Willow Blade
    final bladePaint = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeWidth = bladeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(gripBottom, tipPos, bladePaint);

    // C. Bat Brand Crest (Kreeda Vermilion Badge)
    final stickerPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(1.5, bladeWidth * 0.70)
      ..strokeCap = StrokeCap.round;

    final stickerStart = gripBottom + (tipPos - gripBottom) * 0.22;
    final stickerEnd = gripBottom + (tipPos - gripBottom) * 0.70;
    canvas.drawLine(stickerStart, stickerEnd, stickerPaint);

    // ----------------------------------------------------
    // 7. Sweet-Spot Impact Flash & Sparks (0.23 to 0.33)
    // ----------------------------------------------------
    if (progress >= 0.23 && progress <= 0.33) {
      final ip = (progress - 0.23) / 0.10;
      final shockwaveRadius = ip * (s * 0.24) + s * 0.02;
      final shockwaveAlpha = (1.0 - ip).clamp(0.0, 1.0);

      // Primary Energy Orange Sonic Ring
      final shockwavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.6, (1.0 - ip) * (s * 0.040))
        ..color = primaryColor.withValues(alpha: shockwaveAlpha * 0.95);
      canvas.drawCircle(impactPoint, shockwaveRadius, shockwavePaint);

      // Secondary Gold Shockwave Ring
      final shockwaveGold = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, (1.0 - ip) * (s * 0.024))
        ..color = accentGold.withValues(alpha: shockwaveAlpha * 0.80);
      canvas.drawCircle(impactPoint, shockwaveRadius * 0.65, shockwaveGold);

      // Blinding white sweet-spot contact flash
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: shockwaveAlpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(impactPoint, (1.0 - ip) * (s * 0.09), flashPaint);

      // 10 Dynamic Radiating Sparks
      const sparkCount = 10;
      for (int i = 0; i < sparkCount; i++) {
        final sparkAngle = (i * (2 * math.pi / sparkCount)) + 0.20;
        final sparkDist = ip * (s * 0.24);
        final sparkPos = impactPoint + Offset(
          math.cos(sparkAngle) * sparkDist,
          math.sin(sparkAngle) * sparkDist,
        );

        final sparkPaint = Paint()
          ..color = (i.isEven ? accentGold : primaryColor).withValues(alpha: shockwaveAlpha)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          sparkPos,
          math.max(1.0, (1.0 - ip) * (s * 0.020)),
          sparkPaint,
        );
      }
    }

    // ----------------------------------------------------
    // 8. 3D Leather Cricket Ball & Rocket Comet Flight
    // ----------------------------------------------------
    Offset? ballPos;
    if (progress < 0.25) {
      // Fast dipping yorker into the blockhole
      final p = progress / 0.25;
      final curved = p * p;
      final startPos = Offset(w * 1.05, groundY - s * 0.18);
      ballPos = Offset(
        ui.lerpDouble(startPos.dx, impactPoint.dx, p)!,
        ui.lerpDouble(startPos.dy, impactPoint.dy, curved)!,
      );

      // Yorker Inswing Speed Streak
      final streakLength = math.min(s * 0.25, p * (s * 0.40));
      final streakStart = Offset(
        ballPos.dx + streakLength,
        ballPos.dy - streakLength * 0.15,
      );
      final streakPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.8, s * 0.020)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          streakStart,
          ballPos,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.70),
            Colors.white.withValues(alpha: 0.90),
          ],
          const [0.0, 0.5, 1.0],
        );
      canvas.drawLine(streakStart, ballPos, streakPaint);
    } else if (progress <= 0.27) {
      // Direct impact!
      ballPos = impactPoint;
    } else if (progress <= 0.85) {
      // Rocketing sixer soaring into the stadium sky!
      final p = (progress - 0.27) / 0.58;
      final curved = math.sin(p * math.pi / 2);
      final targetPos = Offset(w * 1.15, h * 0.04);
      ballPos = Offset(
        ui.lerpDouble(impactPoint.dx, targetPos.dx, p)!,
        ui.lerpDouble(impactPoint.dy, targetPos.dy, curved)!,
      );

      // Radiant Comet Tail behind soaring sixer
      final tailLength = math.min(s * 0.45, p * (s * 0.80));
      final tailVector = (ballPos - impactPoint);
      if (tailVector.distance > 2) {
        final norm = tailVector / tailVector.distance;
        final tailStart = ballPos - (norm * tailLength);

        // Outer Flame Plasma Trail
        final cometPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(2.4, s * 0.040)
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(
            tailStart,
            ballPos,
            [
              Colors.transparent,
              primaryColor.withValues(alpha: 0.35),
              accentGold.withValues(alpha: 0.90),
            ],
            const [0.0, 0.40, 1.0],
          );
        canvas.drawLine(tailStart, ballPos, cometPaint);

        // Core White Beam Streak
        final cometCorePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.2, s * 0.016)
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(
            tailStart,
            ballPos,
            [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.95),
            ],
          );
        canvas.drawLine(
          tailStart + (norm * (tailLength * 0.45)),
          ballPos,
          cometCorePaint,
        );
      }
    }

    // Render 3D Leather Cricket Ball
    if (ballPos != null) {
      final ballRadius = math.max(3.2, s * 0.038);

      // Ambient ball glow
      final ballGlowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
      canvas.drawCircle(ballPos, ballRadius * 1.35, ballGlowPaint);

      // 3D Leather sphere gradient
      final ballSpherePaint = Paint()
        ..shader = ui.Gradient.radial(
          ballPos - Offset(ballRadius * 0.3, ballRadius * 0.3),
          ballRadius,
          const [
            Color(0xFFFF8555), // Specular light reflection
            Color(0xFFEF4444), // Cricket Red
            Color(0xFF881337), // Shadow edge
          ],
          const [0.0, 0.65, 1.0],
        );
      canvas.drawCircle(ballPos, ballRadius, ballSpherePaint);

      // White Stitched Seam
      final seamPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.90)
        ..strokeWidth = math.max(0.7, ballRadius * 0.20)
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
