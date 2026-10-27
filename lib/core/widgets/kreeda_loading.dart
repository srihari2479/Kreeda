import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Global Creative Cricket Loading System for Kreeda ("Cricket Lives Here").
/// Features an athletic cricketer executing MS Dhoni's legendary Helicopter Shot:
/// 1. Fast dipping inswinging yorker into the blockhole
/// 2. Explosive sweet-spot contact with expanding dual-ring shockwave & sparks
/// 3. Trademark 360° overhead helicopter rotor bat whirl with luminous neon trails
/// 4. Rocketing sixer soaring into the stadium sky with a radiant comet tail
/// 5. Clean, distraction-free dimmed background overlay without any container boxes or text.
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
/// Adapts seamlessly from compact 64dp sizes to full 180dp showcase showcases.
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
    // 2200ms rhythmic, cinematic loop of the complete helicopter shot sequence
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
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
              silhouetteColor: silhouetteColor,
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
  final double progress; // 0.0 to 1.0 (2200ms loop)
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

    // Dynamic ground & stance layout
    final double groundY = h * 0.82;
    final double stanceX = w * 0.36;
    final Offset impactPoint = Offset(w * 0.52, groundY - s * 0.05);

    // ----------------------------------------------------
    // 1. Stadium Ambient Floodlight Glow
    // ----------------------------------------------------
    final floodlightCenter = Offset(w * 0.46, h * 0.50);
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
    // 2. Pitch Crease & Stumps
    // ----------------------------------------------------
    final groundPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.40)
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
      Offset(w * 0.33, groundY - s * 0.06),
      Offset(w * 0.33, groundY + s * 0.03),
      groundPaint,
    );

    // Timber Stumps & Bails behind batsman
    final stumpX = w * 0.18;
    final stumpHeight = s * 0.25;
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
      ..strokeWidth = math.max(1.4, s * 0.016)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(stumpX - 4.5, groundY),
      Offset(stumpX - 4.5, groundY - stumpHeight),
      stumpPaint,
    );
    canvas.drawLine(
      Offset(stumpX, groundY),
      Offset(stumpX, groundY - stumpHeight),
      stumpPaint,
    );
    canvas.drawLine(
      Offset(stumpX + 4.5, groundY),
      Offset(stumpX + 4.5, groundY - stumpHeight),
      stumpPaint,
    );
    // Bails on top
    canvas.drawLine(
      Offset(stumpX - 6.0, groundY - stumpHeight - 1.5),
      Offset(stumpX + 6.0, groundY - stumpHeight - 1.5),
      stumpPaint..strokeWidth = math.max(1.4, s * 0.020),
    );

    // ----------------------------------------------------
    // 3. Kinetic Phase Timings
    // ----------------------------------------------------
    // Phase 1: Yorker Delivery & Coil (0.00 -> 0.22)
    // Phase 2: Sweet Spot Impact Flash (0.22 -> 0.32)
    // Phase 3: The 360° Helicopter Whirl (0.22 -> 0.72)
    // Phase 4: Sixer Comet Flight (0.24 -> 0.88)
    // Phase 5: Follow-through Poise & Reset (0.72 -> 1.00)

    final bool isIncoming = progress < 0.22;
    final bool isImpact = progress >= 0.22 && progress <= 0.32;
    final bool isTwirling = progress >= 0.22 && progress <= 0.72;
    final bool isOutgoing = progress >= 0.24 && progress <= 0.88;

    // Crouch & Coil offset (knee flexion into the blockhole)
    double crouchOffset = 0.0;
    if (progress < 0.22) {
      crouchOffset = math.sin((progress / 0.22) * math.pi) * (s * 0.04);
    } else if (progress <= 0.72) {
      // Dynamic upward lift and torso unwinding as bat whips overhead
      final p = (progress - 0.22) / 0.50;
      crouchOffset = math.sin(p * math.pi) * (-s * 0.025);
    }

    final double hipX = stanceX;
    final double hipY = (h * 0.58) + crouchOffset;
    final double shoulderX = w * 0.40;
    final double shoulderY = (h * 0.38) + crouchOffset;

    // ----------------------------------------------------
    // 4. The Bat Angle (Authentic Helicopter Physics!)
    // ----------------------------------------------------
    // Canvas rotation: 0 = right (+X), PI/2 = down (+Y), -PI/2 = up (-Y)
    final double batLength = s * 0.46;
    final double batWidth = math.max(3.2, s * 0.050);
    double batAngle;

    if (progress < 0.22) {
      // Downswing from high backlift (-2.1 rad) to blockhole impact (+0.42 rad)
      final p = progress / 0.22;
      final curvedP = p * p; // Gravitational acceleration
      batAngle = -2.1 + curvedP * (0.42 - (-2.1));
    } else if (isTwirling) {
      // THE 360° HELICOPTER WHIRL!
      // Bottom wrist snaps the bat UPWARDS (counter-clockwise) in a full overhead rotor circle
      final p = (progress - 0.22) / 0.50;
      final curvedP = math.sin(p * math.pi / 2); // Explosive initial whip, smoothing out
      batAngle = 0.42 - (curvedP * 2 * math.pi); // Full 360° upward whip
    } else {
      // Hold high follow-through and smoothly settle back to backlift stance
      final p = (progress - 0.72) / 0.28;
      const startAngle = 0.42 - 2 * math.pi;
      const targetAngle = -2.1 - 2 * math.pi;
      final curvedP = Curves.easeInOutSine.transform(p);
      batAngle = ui.lerpDouble(startAngle, targetAngle, curvedP)!;
    }

    // Dynamic wrist pivot moving naturally with the swing
    final double pivotOffsetX = math.cos(batAngle + math.pi / 2) * (s * 0.04);
    final double pivotOffsetY = math.sin(batAngle + math.pi / 2) * (s * 0.03);
    final Offset wristPivot = Offset(
      shoulderX + s * 0.07 + pivotOffsetX,
      (h * 0.45) + crouchOffset + pivotOffsetY,
    );

    // ----------------------------------------------------
    // 5. Overhead 3D Helicopter Rotor Disc (Phase 3)
    // ----------------------------------------------------
    if (isTwirling) {
      final p = (progress - 0.22) / 0.50;
      final sweepAngle = math.min(2.8, p * 3.2 * math.pi);
      final trailStartAngle = batAngle + sweepAngle; // Traces behind the counter-clockwise swing
      final trailRadius = batLength * 0.95;

      final trailRect = Rect.fromCircle(center: wristPivot, radius: trailRadius);

      // A. Outer Luminous Rotor Glow Halo
      final rotorGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(4.5, s * 0.080)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          wristPivot,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.15),
            primaryColor.withValues(alpha: 0.65),
            accentGold.withValues(alpha: 0.95),
          ],
          const [0.0, 0.30, 0.70, 1.0],
          TileMode.clamp,
          trailStartAngle - sweepAngle,
          trailStartAngle,
        );
      canvas.drawArc(trailRect, trailStartAngle - sweepAngle, sweepAngle, false, rotorGlowPaint);

      // B. Core High-Voltage Electric Beam
      final rotorCorePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.8, s * 0.028)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          wristPivot,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.45),
            Colors.white,
          ],
          const [0.0, 0.55, 1.0],
          TileMode.clamp,
          trailStartAngle - sweepAngle,
          trailStartAngle,
        );
      canvas.drawArc(trailRect, trailStartAngle - sweepAngle, sweepAngle, false, rotorCorePaint);

      // C. Rotor Tip Particle Embers
      final tipPos = wristPivot + Offset(math.cos(batAngle) * trailRadius, math.sin(batAngle) * trailRadius);
      final tipSparkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tipPos, math.max(2.0, s * 0.024), tipSparkPaint);
      final tipHaloPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.65)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
      canvas.drawCircle(tipPos, math.max(4.0, s * 0.048), tipHaloPaint);
    }

    // ----------------------------------------------------
    // 6. Athletic Batsman Silhouette (Muscular Contours)
    // ----------------------------------------------------
    final bodyPaint = Paint()
      ..color = silhouetteColor
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // A. Back Leg (Firm anchor with calf and thigh contours)
    final backLegPath = Path()
      ..moveTo(hipX - s * 0.04, hipY)
      ..quadraticBezierTo(hipX - s * 0.08, hipY + s * 0.10, hipX - s * 0.09, groundY - s * 0.05)
      ..lineTo(hipX - s * 0.11, groundY) // Heel
      ..lineTo(hipX - s * 0.04, groundY) // Toe
      ..quadraticBezierTo(hipX - s * 0.02, groundY - s * 0.06, hipX + s * 0.01, hipY)
      ..close();
    canvas.drawPath(backLegPath, bodyPaint);

    // B. Front Leg with Contoured Batting Pad
    // Lunging forward towards the dipping yorker with prominent molded knee roll
    final frontLegPad = Path()
      ..moveTo(hipX + s * 0.02, hipY)
      ..quadraticBezierTo(w * 0.43, hipY + s * 0.08, w * 0.46, groundY - s * 0.13) // High knee roll
      ..lineTo(w * 0.52, groundY) // Boot planted on crease
      ..lineTo(w * 0.45, groundY)
      ..quadraticBezierTo(w * 0.41, groundY - s * 0.10, hipX - s * 0.01, hipY)
      ..close();
    canvas.drawPath(frontLegPad, bodyPaint);

    // Batting Pad Knee Roll & Straps (Athletic gear trim)
    final padStrapPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.90)
      ..strokeWidth = math.max(1.4, s * 0.020)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Molded knee roll accent
    canvas.drawLine(
      Offset(w * 0.42, groundY - s * 0.12),
      Offset(w * 0.47, groundY - s * 0.12),
      padStrapPaint,
    );
    // Lower shin strap
    canvas.drawLine(
      Offset(w * 0.44, groundY - s * 0.04),
      Offset(w * 0.50, groundY - s * 0.04),
      padStrapPaint,
    );

    // C. Athletic Torso & Team Jersey
    // Dynamic arch leaning into blockhole then rising tall
    final torsoPath = Path()
      ..moveTo(hipX - s * 0.04, hipY)
      ..quadraticBezierTo(shoulderX - s * 0.06, (hipY + shoulderY) / 2, shoulderX - s * 0.05, shoulderY + s * 0.02)
      ..lineTo(shoulderX + s * 0.06, shoulderY)
      ..quadraticBezierTo(shoulderX + s * 0.04, (hipY + shoulderY) / 2, hipX + s * 0.04, hipY)
      ..close();
    canvas.drawPath(torsoPath, bodyPaint);

    // Dynamic Team Jersey Diagonal Chevron Sash
    final sashPath = Path()
      ..moveTo(shoulderX - s * 0.02, shoulderY)
      ..lineTo(shoulderX + s * 0.03, shoulderY)
      ..lineTo(hipX + s * 0.02, hipY)
      ..lineTo(hipX - s * 0.01, hipY)
      ..close();
    canvas.drawPath(sashPath, accentPaint);

    // D. Batting Helmet with Visor Peak & Face Grill
    // Head tilts dynamically to track delivery, contact, and the skyward sixer!
    double headTilt = 0.0;
    if (progress < 0.22) {
      headTilt = 0.12; // Looking down at the yorker
    } else {
      final p = ((progress - 0.22) / 0.50).clamp(0.0, 1.0);
      headTilt = ui.lerpDouble(0.12, -0.25, p)!; // Tilting up watching the sixer sail
    }

    final helmetCenter = Offset(
      shoulderX + s * 0.01 + math.cos(headTilt) * (s * 0.01),
      shoulderY - s * 0.08 + math.sin(headTilt) * (s * 0.01),
    );
    final helmetRadius = s * 0.068;

    // Helmet dome & rear neck flange
    canvas.drawCircle(helmetCenter, helmetRadius, bodyPaint);

    // Visor Peak (Angled over brow)
    final visorPath = Path()
      ..moveTo(helmetCenter.dx + helmetRadius * 0.2, helmetCenter.dy - helmetRadius * 0.4)
      ..lineTo(helmetCenter.dx + helmetRadius * 1.35, helmetCenter.dy + helmetRadius * (0.05 + headTilt))
      ..lineTo(helmetCenter.dx + helmetRadius * 0.6, helmetCenter.dy + helmetRadius * 0.35)
      ..close();
    canvas.drawPath(visorPath, accentPaint);

    // Metallic Face Grill (Silver helmet cage)
    final grillPaint = Paint()
      ..color = (isDark ? Colors.white70 : const Color(0xFF64748B))
      ..strokeWidth = math.max(0.9, s * 0.012)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(helmetCenter.dx + helmetRadius * 0.4, helmetCenter.dy + helmetRadius * 0.2),
      Offset(helmetCenter.dx + helmetRadius * 1.0, helmetCenter.dy + helmetRadius * 0.4),
      grillPaint,
    );
    canvas.drawLine(
      Offset(helmetCenter.dx + helmetRadius * 0.5, helmetCenter.dy + helmetRadius * 0.6),
      Offset(helmetCenter.dx + helmetRadius * 0.9, helmetCenter.dy + helmetRadius * 0.7),
      grillPaint,
    );

    // ----------------------------------------------------
    // 7. Articulated Arms & Molded Batting Gloves
    // ----------------------------------------------------
    final handGripPos = wristPivot + Offset(
      math.cos(batAngle) * (batLength * 0.16),
      math.sin(batAngle) * (batLength * 0.16),
    );

    final armPaint = Paint()
      ..color = silhouetteColor
      ..strokeWidth = math.max(3.0, s * 0.046)
      ..strokeCap = StrokeCap.round;

    // Left Arm (Top Hand guide)
    final shoulderL = Offset(shoulderX - s * 0.02, shoulderY + s * 0.03);
    final elbowL = Offset((shoulderL.dx + handGripPos.dx) / 2 - s * 0.02, (shoulderL.dy + handGripPos.dy) / 2 + s * 0.02);
    canvas.drawLine(shoulderL, elbowL, armPaint);
    canvas.drawLine(elbowL, handGripPos, armPaint);

    // Right Arm (Bottom Hand power generator)
    final shoulderR = Offset(shoulderX + s * 0.03, shoulderY + s * 0.04);
    final elbowR = Offset((shoulderR.dx + handGripPos.dx) / 2 + s * 0.02, (shoulderR.dy + handGripPos.dy) / 2 + s * 0.01);
    canvas.drawLine(shoulderR, elbowR, armPaint);
    canvas.drawLine(elbowR, handGripPos, armPaint);

    // Batting Gloves (Molded padded gloves on handle)
    final glovePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(handGripPos, math.max(2.8, s * 0.038), glovePaint);
    final gloveCuffPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(handGripPos, math.max(1.4, s * 0.018), gloveCuffPaint);

    // ----------------------------------------------------
    // 8. The Detailed Cricket Bat
    // ----------------------------------------------------
    canvas.save();
    canvas.translate(wristPivot.dx, wristPivot.dy);
    canvas.rotate(batAngle);

    // A. Rubber Grip Handle
    final handlePaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = math.max(1.8, batWidth * 0.45)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-batLength * 0.12, 0),
      Offset(batLength * 0.20, 0),
      handlePaint,
    );

    // B. English Willow Blade
    final bladeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(batLength * 0.20, -batWidth / 2, batLength * 0.80, batWidth),
      Radius.circular(batWidth * 0.25),
    );
    final bladePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(batLength * 0.20, -batWidth / 2),
        Offset(batLength * 0.20, batWidth / 2),
        const [
          Color(0xFFFEF08A), // Willow face highlight
          Color(0xFFD97706), // English willow grain
          Color(0xFF78350F), // Dark spine shadow
        ],
        const [0.0, 0.50, 1.0],
      );
    canvas.drawRRect(bladeRect, bladePaint);

    // C. Bat Brand Crest (Kreeda Vermilion Badge)
    final stickerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(batLength * 0.36, -batWidth * 0.42, batLength * 0.35, batWidth * 0.84),
      Radius.circular(batWidth * 0.18),
    );
    canvas.drawRRect(stickerRect, accentPaint);

    canvas.restore();

    // ----------------------------------------------------
    // 9. Sweet-Spot Impact Explosion & Sparks (Phase 2)
    // ----------------------------------------------------
    if (isImpact) {
      final p = (progress - 0.22) / 0.10; // 0.0 to 1.0 during contact
      final shockwaveRadius = p * (s * 0.36);
      final shockwaveAlpha = (1.0 - p).clamp(0.0, 1.0);

      // Primary Energy Orange Sonic Ring
      final shockwavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.8, (1.0 - p) * (s * 0.050))
        ..color = primaryColor.withValues(alpha: shockwaveAlpha * 0.95);
      canvas.drawCircle(impactPoint, shockwaveRadius, shockwavePaint);

      // Secondary Gold Shockwave Ring
      final shockwaveGold = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, (1.0 - p) * (s * 0.032))
        ..color = accentGold.withValues(alpha: shockwaveAlpha * 0.80);
      canvas.drawCircle(impactPoint, shockwaveRadius * 0.68, shockwaveGold);

      // Sweet Spot Core Contact Flash
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: shockwaveAlpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(impactPoint, (1.0 - p) * (s * 0.12), flashPaint);

      // 10 Dynamic Radiating Sparks
      const sparkCount = 10;
      for (int i = 0; i < sparkCount; i++) {
        final sparkAngle = (i * (2 * math.pi / sparkCount)) + 0.20;
        final sparkDist = p * (s * 0.32);
        final sparkPos = impactPoint + Offset(
          math.cos(sparkAngle) * sparkDist,
          math.sin(sparkAngle) * sparkDist,
        );

        final sparkPaint = Paint()
          ..color = (i.isEven ? accentGold : primaryColor).withValues(
            alpha: shockwaveAlpha,
          )
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          sparkPos,
          math.max(1.0, (1.0 - p) * (s * 0.026)),
          sparkPaint,
        );
      }
    }

    // ----------------------------------------------------
    // 10. Leather Ball & Sixer Rocket Comet
    // ----------------------------------------------------
    Offset ballPos = Offset.zero;
    bool shouldDrawBall = false;

    if (isIncoming) {
      // Yorker dips sharply into the blockhole
      final p = progress / 0.22;
      final curvedP = p * p; // Gravitational drop
      final startPos = Offset(w * 0.96, h * 0.16);
      ballPos = Offset(
        ui.lerpDouble(startPos.dx, impactPoint.dx, p)!,
        ui.lerpDouble(startPos.dy, impactPoint.dy, curvedP)!,
      );
      shouldDrawBall = true;
    } else if (isOutgoing) {
      // Ball launched skyward on explosive sixer trajectory
      final p = (progress - 0.24) / 0.64;
      final curvedP = Curves.easeOutQuad.transform(p);

      final targetX = w * 1.12;
      final targetY = h * 0.03;

      ballPos = Offset(
        ui.lerpDouble(impactPoint.dx, targetX, p)!,
        ui.lerpDouble(impactPoint.dy, targetY, curvedP)!,
      );
      shouldDrawBall = true;

      // Radiant Comet Tail behind soaring sixer
      final tailLength = math.min(s * 0.42, p * (s * 0.75));
      final tailVector = (ballPos - impactPoint);
      if (tailVector.distance > 2) {
        final norm = tailVector / tailVector.distance;
        final tailStart = ballPos - (norm * tailLength);

        // Outer Flame Plasma Trail
        final cometPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(2.4, s * 0.046)
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
          ..strokeWidth = math.max(1.2, s * 0.020)
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
    if (shouldDrawBall) {
      final ballRadius = math.max(3.4, s * 0.044);

      // Ambient ball glow
      final ballGlowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
      canvas.drawCircle(ballPos, ballRadius * 1.4, ballGlowPaint);

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
