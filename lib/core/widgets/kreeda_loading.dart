import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Global Creative Cricket Loading System for Kreeda ("Cricket Lives Here").
/// Features an athletic cricketer executing MS Dhoni's legendary Helicopter Shot:
/// 1. Fast dipping inswinging yorker targeted into the blockhole
/// 2. Deep athletic forward lunge and sweet-spot impact contact flash
/// 3. Explosive bottom-wrist upward whip digging the ball out
/// 4. Trademark 360° overhead horizontal helicopter rotor bat whirl with luminous speed halo
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

    // Dynamic ground & stance layout
    final double groundY = h * 0.80;
    final double stanceX = w * 0.37;
    final Offset impactPoint = Offset(w * 0.55, groundY - s * 0.03);

    // ----------------------------------------------------
    // 1. Stadium Ambient Floodlight Glow
    // ----------------------------------------------------
    final floodlightCenter = Offset(w * 0.45, h * 0.50);
    final floodlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: isDark ? 0.22 : 0.12),
          accentGold.withValues(alpha: isDark ? 0.08 : 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.50, 1.0],
      ).createShader(
        Rect.fromCircle(center: floodlightCenter, radius: s * 0.72),
      );
    canvas.drawCircle(floodlightCenter, s * 0.72, floodlightPaint);

    // ----------------------------------------------------
    // 2. Pitch Crease & Timber Stumps
    // ----------------------------------------------------
    final groundPaint = Paint()
      ..color = borderColor.withValues(alpha: isDark ? 0.45 : 0.35)
      ..strokeWidth = math.max(1.0, s * 0.012)
      ..strokeCap = StrokeCap.round;

    // Pitch turf crease line
    canvas.drawLine(
      Offset(w * 0.06, groundY),
      Offset(w * 0.94, groundY),
      groundPaint,
    );

    // Popping crease mark
    canvas.drawLine(
      Offset(w * 0.34, groundY - s * 0.055),
      Offset(w * 0.34, groundY + s * 0.025),
      groundPaint,
    );

    // Timber Stumps & Bails behind batsman
    final stumpX = w * 0.165;
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
    // 3. Kinetic Phase Timings & Biomechanics
    // ----------------------------------------------------
    // Phase 1: Yorker Delivery & Downswing (0.00 -> 0.25)
    // Phase 2: Sweet Spot Impact Flash (0.25 -> 0.32)
    // Phase 3: Bottom-Wrist Dig Out & Upward Whip (0.28 -> 0.38)
    // Phase 4: Overhead 360° Helicopter Rotor Twirl (0.38 -> 0.68)
    // Phase 5: Sixer Rocket Flight (0.25 -> 0.88)
    // Phase 6: High Follow-through Poise & Reset (0.68 -> 1.00)

    final baseWrist = Offset(stanceX + s * 0.145, groundY - s * 0.30);
    final batLength = s * 0.30;
    final bladeWidth = math.max(3.0, s * 0.035);

    // Exact hit angle: angle from wrist to impact point in the blockhole
    final impactWrist = baseWrist + Offset(s * 0.015, s * 0.030);
    final hitAngle = math.atan2(
      impactPoint.dy - impactWrist.dy,
      impactPoint.dx - impactWrist.dx,
    ); // ~61° (1.07 rad)
    final backliftAngle = -math.pi * 0.72; // -130°

    double crouch = 0.0;
    double leanX = 0.0;
    Offset wrist;
    double batAngle;
    Offset batTip;
    bool isOverheadTwirl = false;
    double rotorProgress = 0.0;

    final rotorCenter = Offset(stanceX + s * 0.12, groundY - s * 0.56);
    final rx = s * 0.25;
    final ry = s * 0.085;
    const tiltRad = -10.0 * math.pi / 180.0;

    if (progress < 0.25) {
      // Downswing from high backlift (-130°) to blockhole impact (+61°)
      final p = progress / 0.25;
      final curved = p * p; // Gravitational acceleration
      crouch = curved * (s * 0.030);
      leanX = curved * (s * 0.015);
      wrist = baseWrist + Offset(leanX, crouch);
      batAngle = backliftAngle + curved * (hitAngle - backliftAngle);
      batTip = wrist + Offset(math.cos(batAngle) * batLength, math.sin(batAngle) * batLength);
    } else if (progress <= 0.28) {
      // Impact moment! Bat meets dipping ball exactly at impact point
      crouch = s * 0.030;
      leanX = s * 0.015;
      wrist = baseWrist + Offset(leanX, crouch);
      batAngle = hitAngle;
      batTip = impactPoint;
    } else if (progress <= 0.38) {
      // Dig out: bottom wrist flicks UP! Bat arcs from blockhole to vertical
      final p = (progress - 0.28) / 0.10;
      final curved = math.sin(p * math.pi / 2); // explosive upward snap
      batAngle = hitAngle + curved * (-math.pi / 2 - hitAngle);
      crouch = (1.0 - p) * (s * 0.030);
      leanX = (1.0 - p) * (s * 0.015);
      final wristLift = p * (s * 0.068);
      wrist = baseWrist + Offset(leanX, crouch - wristLift);
      batTip = wrist + Offset(math.cos(batAngle) * batLength, math.sin(batAngle) * batLength);
    } else if (progress <= 0.68) {
      // THE 360° OVERHEAD HELICOPTER ROTOR TWIRL!
      // Bat blade whirls horizontally above the helmet
      rotorProgress = (progress - 0.38) / 0.30;
      isOverheadTwirl = true;
      crouch = -math.sin(rotorProgress * math.pi) * (s * 0.015); // standing tall
      leanX = 0.0;
      wrist = baseWrist + Offset(-s * 0.008, -s * 0.068); // high hands near collar

      final spinAngle = rotorProgress * 2 * math.pi;
      final rad = spinAngle + tiltRad;
      batTip = rotorCenter + Offset(math.cos(rad) * rx, math.sin(rad) * ry);
      batAngle = math.atan2(batTip.dy - wrist.dy, batTip.dx - wrist.dx);
    } else {
      // Follow-through poise & smooth settle
      final p = (progress - 0.68) / 0.32;
      final curved = (1.0 - math.cos(p * math.pi)) / 2;
      crouch = 0.0;
      leanX = 0.0;
      wrist = Offset.lerp(
        baseWrist + Offset(-s * 0.008, -s * 0.068),
        baseWrist,
        curved,
      )!;

      final startTip = rotorCenter + Offset(math.cos(tiltRad) * rx, math.sin(tiltRad) * ry);
      final endTip = baseWrist + Offset(math.cos(backliftAngle) * batLength, math.sin(backliftAngle) * batLength);
      batTip = Offset.lerp(startTip, endTip, curved)!;
      batAngle = math.atan2(batTip.dy - wrist.dy, batTip.dx - wrist.dx);
    }

    // ----------------------------------------------------
    // 4. Overhead 3D Helicopter Rotor Disc (Phase 4)
    // ----------------------------------------------------
    if (isOverheadTwirl) {
      // Luminous elliptical halo disc
      final rotorHaloPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, s * 0.010)
        ..color = primaryColor.withValues(alpha: 0.35);

      canvas.save();
      canvas.translate(rotorCenter.dx, rotorCenter.dy);
      canvas.rotate(tiltRad);
      final localRect = Rect.fromCenter(
        center: Offset.zero,
        width: rx * 2,
        height: ry * 2,
      );
      canvas.drawOval(localRect, rotorHaloPaint);

      // Core electric speed sweep arc following blade tip
      final sweepAngle = rotorProgress * 2 * math.pi;
      final rotorArcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2.0, s * 0.020)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          Offset.zero,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.40),
            accentGold.withValues(alpha: 0.85),
            Colors.white,
          ],
          const [0.0, 0.40, 0.85, 1.0],
          TileMode.clamp,
          0.0,
          sweepAngle,
        );
      canvas.drawArc(localRect, 0.0, sweepAngle, false, rotorArcPaint);
      canvas.restore();

      // Blade-tip glowing spark ember
      final emberCorePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(batTip, math.max(2.2, s * 0.022), emberCorePaint);
      final emberGlowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, s * 0.014);
      canvas.drawCircle(batTip, math.max(4.0, s * 0.040), emberGlowPaint);
    }

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

    final double stX = stanceX + leanX;
    final Offset hip = Offset(stX, groundY - s * 0.24 + crouch);

    // A. Back Leg (Firm athletic anchor on turf)
    final bKnee = Offset(stX - s * 0.122, groundY - s * 0.122 + crouch * 0.4);
    final bAnkle = Offset(stX - s * 0.198, groundY - s * 0.030);
    final bToe = Offset(stX - s * 0.145, groundY);
    final bHeel = Offset(stX - s * 0.220, groundY);

    final backLegPath = Path()
      ..moveTo(hip.dx - s * 0.030, hip.dy + s * 0.008)
      ..lineTo(stX - s * 0.076, hip.dy + s * 0.060)
      ..lineTo(bKnee.dx - s * 0.024, bKnee.dy)
      ..lineTo(bAnkle.dx - s * 0.008, bAnkle.dy)
      ..lineTo(bHeel.dx, bHeel.dy)
      ..lineTo(bToe.dx, bToe.dy)
      ..lineTo(bAnkle.dx + s * 0.030, bAnkle.dy + s * 0.008)
      ..lineTo(bKnee.dx + s * 0.030, bKnee.dy + s * 0.015)
      ..lineTo(stX - s * 0.038, hip.dy + s * 0.076)
      ..lineTo(hip.dx + s * 0.015, hip.dy + s * 0.015)
      ..close();
    canvas.drawPath(backLegPath, pantPaint);

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

    // C. Contoured Professional Cricket Batting Pad
    final fAnkle = Offset(stX + s * 0.206, groundY - s * 0.030);
    final fToe = Offset(stX + s * 0.290, groundY);
    final fHeel = Offset(stX + s * 0.176, groundY);

    final padPath = Path()
      ..moveTo(fKnee.dx - s * 0.030, fKnee.dy - s * 0.054) // Top hat outer peak
      ..lineTo(fKnee.dx + s * 0.046, fKnee.dy - s * 0.038) // Top hat inner
      ..lineTo(fKnee.dx + s * 0.060, fKnee.dy + s * 0.015) // Molded knee roll
      ..lineTo(fAnkle.dx + s * 0.054, groundY - s * 0.015) // Shin flare
      ..lineTo(fToe.dx, fToe.dy)                           // Instep over shoe
      ..lineTo(fHeel.dx, fHeel.dy)                         // Heel base
      ..lineTo(fAnkle.dx - s * 0.030, groundY - s * 0.046) // Calf taper
      ..lineTo(fKnee.dx - s * 0.038, fKnee.dy + s * 0.030) // Under knee roll
      ..close();
    canvas.drawPath(padPath, padPaint);
    canvas.drawPath(padPath, padBorderPaint);

    // Batting Pad Knee Roll & Straps (Athletic Vermilion Accents)
    final padStrapPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(1.2, s * 0.012)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(fKnee.dx - s * 0.024, fKnee.dy),
      Offset(fKnee.dx + s * 0.054, fKnee.dy + s * 0.008),
      padStrapPaint,
    );
    canvas.drawLine(
      Offset(fKnee.dx - s * 0.024, fKnee.dy + s * 0.024),
      Offset(fKnee.dx + s * 0.054, fKnee.dy + s * 0.030),
      padStrapPaint,
    );
    canvas.drawLine(
      Offset(fAnkle.dx - s * 0.015, groundY - s * 0.060),
      Offset(fAnkle.dx + s * 0.038, groundY - s * 0.054),
      padStrapPaint,
    );

    // Spiked Athletic Shoes
    final shoeSolePaint = Paint()..color = primaryColor..style = PaintingStyle.fill;
    final shoeBodyPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    // Back shoe
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(bHeel.dx - 1.5, groundY - s * 0.020, bToe.dx + 1.5, groundY),
        Radius.circular(s * 0.006),
      ),
      shoeBodyPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(bHeel.dx - 1.5, groundY - s * 0.008, bToe.dx + 1.5, groundY),
      shoeSolePaint,
    );

    // Front shoe
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

    // E. Muscular Neck & Batting Helmet
    final neckBot = Offset(stX + s * 0.092, shoulderL.dy - s * 0.008);
    final headCenter = Offset(stX + s * 0.115, groundY - s * 0.485 + crouch);

    final neckPath = Path()
      ..moveTo(neckBot.dx - s * 0.024, neckBot.dy)
      ..lineTo(headCenter.dx - s * 0.015, headCenter.dy + s * 0.030)
      ..lineTo(headCenter.dx + s * 0.024, headCenter.dy + s * 0.030)
      ..lineTo(neckBot.dx + s * 0.024, neckBot.dy)
      ..close();
    canvas.drawPath(neckPath, skinPaint);

    // Helmet dome (Clean aerodynamic shell)
    final helmetRadius = s * 0.042;
    canvas.drawCircle(headCenter, helmetRadius, jerseyPaint);
    // Ear protector pad
    canvas.drawCircle(
      headCenter + Offset(-s * 0.008, s * 0.008),
      s * 0.015,
      Paint()..color = isDark ? const Color(0xFF020617) : const Color(0xFF050B18),
    );

    // Swept Brow Visor Peak (No bird beak! Sleek aerodynamic profile)
    final visorPath = Path()
      ..moveTo(headCenter.dx + s * 0.004, headCenter.dy - s * 0.008)
      ..lineTo(headCenter.dx + s * 0.054, headCenter.dy + s * 0.004)
      ..lineTo(headCenter.dx + s * 0.046, headCenter.dy + s * 0.015)
      ..lineTo(headCenter.dx + s * 0.015, headCenter.dy + s * 0.008)
      ..close();
    canvas.drawPath(visorPath, accentPaint);

    // Face Grille (Curved protective titanium cage)
    final grillePaint = Paint()
      ..color = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)
      ..strokeWidth = math.max(0.8, s * 0.008)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      headCenter + Offset(s * 0.015, s * 0.012),
      headCenter + Offset(s * 0.046, s * 0.027),
      grillePaint,
    );
    canvas.drawLine(
      headCenter + Offset(s * 0.010, s * 0.027),
      headCenter + Offset(s * 0.038, s * 0.038),
      grillePaint,
    );

    // F. Articulated Arms Connected to Moving Wrists
    final armPaint = Paint()
      ..color = jerseyColor
      ..strokeWidth = math.max(2.8, s * 0.025)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(shoulderL, wrist - Offset(s * 0.015, s * 0.015), armPaint);
    canvas.drawLine(shoulderR, wrist, armPaint);

    // Batting Gloves (Two-tone molded sausage-finger gloves clutching handle)
    final gloveOuterPaint = Paint()..color = primaryColor..style = PaintingStyle.fill;
    final gloveInnerPaint = Paint()..color = padColor..style = PaintingStyle.fill;
    final gloveCuffPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    canvas.drawCircle(wrist - Offset(s * 0.012, s * 0.012), math.max(2.2, s * 0.020), gloveOuterPaint);
    canvas.drawCircle(wrist + Offset(s * 0.008, s * 0.008), math.max(2.0, s * 0.018), gloveInnerPaint);
    canvas.drawCircle(wrist, math.max(1.0, s * 0.008), gloveCuffPaint);

    // ----------------------------------------------------
    // 6. The Detailed Cricket Bat
    // ----------------------------------------------------
    final gripLength = batLength * 0.16;
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
    canvas.drawLine(gripBottom, batTip, bladePaint);

    // C. Bat Brand Crest (Kreeda Vermilion Badge)
    final stickerPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = math.max(1.5, bladeWidth * 0.70)
      ..strokeCap = StrokeCap.round;

    final stickerStart = gripBottom + (batTip - gripBottom) * 0.22;
    final stickerEnd = gripBottom + (batTip - gripBottom) * 0.70;
    canvas.drawLine(stickerStart, stickerEnd, stickerPaint);

    // ----------------------------------------------------
    // 7. Sweet-Spot Impact Flash & Sparks (Phase 2)
    // ----------------------------------------------------
    if (progress >= 0.24 && progress <= 0.32) {
      final ip = (progress - 0.24) / 0.08;
      final shockwaveRadius = ip * (s * 0.22) + s * 0.02;
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
      // Yorker dips sharply into the blockhole
      final p = progress / 0.25;
      final curved = p * p; // Gravitational drop
      final startPos = Offset(w * 0.95, h * 0.16);
      ballPos = Offset(
        ui.lerpDouble(startPos.dx, impactPoint.dx, p)!,
        ui.lerpDouble(startPos.dy, impactPoint.dy, curved)!,
      );
    } else if (progress <= 0.28) {
      ballPos = impactPoint;
    } else if (progress <= 0.88) {
      // Rocketing sixer launched skyward
      final p = (progress - 0.28) / 0.60;
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
