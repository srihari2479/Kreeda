import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Global Creative Cricket Loading System for Kreeda ("Cricket Lives Here").
/// Features an athletic cricketer executing MS Dhoni's legendary Helicopter Shot:
/// 1. Fast dipping yorker delivery into the blockhole
/// 2. Explosive sweet-spot contact with expanding dual-ring shockwave & sparks
/// 3. Trademark 360° overhead helicopter rotor bat whirl with luminous neon trails
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

    // Capture active theme from context to guarantee 100% theme token inheritance
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (ctx) => Theme(
        data: theme,
        child: _KreedaLoadingOverlay(initialMessage: message),
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

/// Full-screen frosted overlay with centered Neumorphic cricket loading card.
class _KreedaLoadingOverlay extends StatefulWidget {
  final String initialMessage;

  const _KreedaLoadingOverlay({required this.initialMessage});

  @override
  State<_KreedaLoadingOverlay> createState() => _KreedaLoadingOverlayState();
}

class _KreedaLoadingOverlayState extends State<_KreedaLoadingOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _progressCtrl;
  late final Timer _messageTimer;

  int _messageIndex = 0;
  final List<String> _dynamicMessages = [
    'CONNECTING TO LIVE PITCH...',
    'DIGGING OUT THE CRACKING YORKER...',
    'UNLEASHING THE HELICOPTER SHOT! 🚁',
    'ROCKETING INTO THE STADIUM SKY! 💥',
    'SYNCHRONIZING MATCH CENTER...',
  ];

  @override
  void initState() {
    super.initState();

    // Smooth card entrance (fade + scale)
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();

    // Simulated progress bar over 5000ms duration
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..forward();

    // Dynamic cricket commentary rotation every 1400ms
    _messageTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _dynamicMessages.length;
      });
    });
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    _entranceCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final currentMsg = _messageIndex == 0
        ? widget.initialMessage
        : _dynamicMessages[_messageIndex];

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
            // Frosted glass dimmed backdrop with 10px Gaussian blur
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: isDark ? 0.65 : 0.42),
              ),
            ),
            // Centered Neumorphic loading card
            Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _entranceCtrl,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.40 : 0.08,
                          ),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // The Helicopter Shot Animation Canvas
                        const KreedaLoadingWidget(size: 110),
                        const SizedBox(height: 14),

                        // Header Brand Row (Fitted to eliminate 100% overflow across viewports)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'KREEDA',
                                style: AppTypography.headlineMedium(
                                  AppColors.primary(context),
                                ).copyWith(
                                  letterSpacing: 2.2,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColors.primaryOrange.withValues(
                                      alpha: 0.35,
                                    ),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  'HELICOPTER SHOT',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryOrange,
                                    letterSpacing: 0.8,
                                    fontFamilyFallback: const [
                                      'Impact',
                                      'Arial Black',
                                      'sans-serif',
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Rotating Cricket Commentary (Guaranteed width clearance)
                        SizedBox(
                          width: double.infinity,
                          height: 22,
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              child: Text(
                                currentMsg,
                                key: ValueKey<String>(currentMsg),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption(
                                  AppColors.textSecondary(context),
                                ).copyWith(
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Animated Sports Progress Bar
                        AnimatedBuilder(
                          animation: _progressCtrl,
                          builder: (context, _) {
                            final progress = _progressCtrl.value;
                            return Container(
                              height: 3.5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.border(context).withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: progress.clamp(0.05, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.passGold,
                                        AppColors.primaryOrange,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryOrange
                                            .withValues(alpha: 0.45),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    // 2000ms rhythmic, cinematic loop of the complete helicopter shot sequence
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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
            final canvasWidth = widget.size * 1.35;
            final canvasHeight = widget.size;

            return SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: CustomPaint(
                size: Size(canvasWidth, canvasHeight),
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

/// High-Performance Vector CustomPainter visualizing MS Dhoni's iconic Helicopter Shot.
/// 100% Vector Math & GPU-accelerated Canvas operations (60-120 FPS guaranteed).
class _HelicopterShotPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0 (2000ms loop)
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
    final double groundY = h * 0.83;
    final double stanceX = w * 0.38;
    final Offset impactPoint = Offset(w * 0.53, groundY - s * 0.05);

    // ----------------------------------------------------
    // 1. Stadium Ambient Floodlight Glow
    // ----------------------------------------------------
    final floodlightCenter = Offset(w * 0.48, h * 0.48);
    final floodlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: isDark ? 0.15 : 0.07),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: floodlightCenter, radius: s * 0.68));
    canvas.drawCircle(floodlightCenter, s * 0.68, floodlightPaint);

    // ----------------------------------------------------
    // 2. Pitch Crease & Stumps
    // ----------------------------------------------------
    final groundPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.35)
      ..strokeWidth = math.max(0.8, s * 0.012)
      ..strokeCap = StrokeCap.round;

    // Pitch turf crease line
    canvas.drawLine(
      Offset(w * 0.08, groundY),
      Offset(w * 0.92, groundY),
      groundPaint,
    );

    // Popping crease mark
    canvas.drawLine(
      Offset(w * 0.35, groundY - s * 0.06),
      Offset(w * 0.35, groundY + s * 0.03),
      groundPaint,
    );

    // Timber Stumps & Bails behind batsman
    final stumpX = w * 0.20;
    final stumpHeight = s * 0.24;
    final stumpPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD97706).withValues(alpha: isDark ? 0.85 : 0.70),
          const Color(0xFF78350F).withValues(alpha: isDark ? 0.90 : 0.80),
        ],
      ).createShader(
        Rect.fromLTWH(stumpX - 5, groundY - stumpHeight, 10, stumpHeight),
      )
      ..strokeWidth = math.max(1.2, s * 0.016)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(stumpX - 4, groundY),
      Offset(stumpX - 4, groundY - stumpHeight),
      stumpPaint,
    );
    canvas.drawLine(
      Offset(stumpX, groundY),
      Offset(stumpX, groundY - stumpHeight),
      stumpPaint,
    );
    canvas.drawLine(
      Offset(stumpX + 4, groundY),
      Offset(stumpX + 4, groundY - stumpHeight),
      stumpPaint,
    );
    // Bails on top
    canvas.drawLine(
      Offset(stumpX - 5.5, groundY - stumpHeight - 1),
      Offset(stumpX + 5.5, groundY - stumpHeight - 1),
      stumpPaint..strokeWidth = math.max(1.2, s * 0.020),
    );

    // ----------------------------------------------------
    // 3. Kinetic Phase Timings
    // ----------------------------------------------------
    // Phase 1: Yorker Delivery & Coil (0.00 -> 0.22)
    // Phase 2: Sweet Spot Impact Flash (0.22 -> 0.32)
    // Phase 3: The 360° Helicopter Whirl (0.24 -> 0.74)
    // Phase 4: Sixer Comet Flight (0.24 -> 0.88)
    // Phase 5: Follow-through Poise & Reset (0.74 -> 1.00)

    final bool isIncoming = progress < 0.22;
    final bool isImpact = progress >= 0.22 && progress <= 0.32;
    final bool isTwirling = progress >= 0.24 && progress <= 0.74;
    final bool isOutgoing = progress >= 0.24 && progress <= 0.88;

    // Crouch & Coil offset (knee flexion into the yorker)
    double crouchOffset = 0.0;
    if (progress < 0.22) {
      crouchOffset = math.sin((progress / 0.22) * math.pi) * (s * 0.035);
    } else if (progress <= 0.74) {
      // Dynamic upward lift and torso unwinding
      final p = (progress - 0.22) / 0.52;
      crouchOffset = math.sin(p * math.pi) * (-s * 0.02);
    }

    final double hipX = stanceX;
    final double hipY = (h * 0.58) + crouchOffset;
    final double shoulderX = w * 0.42;
    final double shoulderY = (h * 0.39) + crouchOffset;
    final Offset wristPivot = Offset(shoulderX + s * 0.08, (h * 0.46) + crouchOffset);

    // ----------------------------------------------------
    // 4. Athletic Batsman Silhouette (No Stick-Figure!)
    // ----------------------------------------------------
    final bodyPaint = Paint()
      ..color = silhouetteColor
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    // A. Back Leg (Firm anchor on backfoot crease)
    final backLegPath = Path()
      ..moveTo(hipX - s * 0.04, hipY)
      ..lineTo(hipX - s * 0.09, groundY - s * 0.06) // Thigh / knee
      ..lineTo(hipX - s * 0.10, groundY)            // Heel
      ..lineTo(hipX - s * 0.04, groundY)            // Toe
      ..lineTo(hipX - s * 0.02, groundY - s * 0.06)
      ..lineTo(hipX + s * 0.01, hipY)
      ..close();
    canvas.drawPath(backLegPath, bodyPaint);

    // B. Front Leg (Stepped forward towards the dipping yorker with Batting Pad)
    final frontLegPad = Path()
      ..moveTo(hipX + s * 0.02, hipY)
      ..lineTo(w * 0.45, groundY - s * 0.12) // Contoured knee roll
      ..lineTo(w * 0.51, groundY)            // Front boot planted
      ..lineTo(w * 0.45, groundY)
      ..lineTo(w * 0.40, groundY - s * 0.11)
      ..lineTo(hipX - s * 0.01, hipY)
      ..close();
    canvas.drawPath(frontLegPad, bodyPaint);

    // Batting Pad Knee Roll & Straps (Athletic gear trim)
    final padStrapPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.90)
      ..strokeWidth = math.max(1.2, s * 0.018)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Knee roll accent
    canvas.drawLine(
      Offset(w * 0.41, groundY - s * 0.11),
      Offset(w * 0.46, groundY - s * 0.11),
      padStrapPaint,
    );
    // Lower shin strap
    canvas.drawLine(
      Offset(w * 0.43, groundY - s * 0.04),
      Offset(w * 0.49, groundY - s * 0.04),
      padStrapPaint,
    );

    // C. Athletic Torso & Team Jersey
    final torsoPath = Path()
      ..moveTo(hipX - s * 0.04, hipY)
      ..lineTo(shoulderX - s * 0.05, shoulderY + s * 0.02)
      ..lineTo(shoulderX + s * 0.06, shoulderY)
      ..lineTo(hipX + s * 0.04, hipY)
      ..close();
    canvas.drawPath(torsoPath, bodyPaint);

    // Dynamic Team Jersey Diagonal Sash
    final sashPath = Path()
      ..moveTo(shoulderX - s * 0.02, shoulderY)
      ..lineTo(shoulderX + s * 0.03, shoulderY)
      ..lineTo(hipX + s * 0.02, hipY)
      ..lineTo(hipX - s * 0.01, hipY)
      ..close();
    canvas.drawPath(sashPath, accentPaint);

    // D. Batting Helmet with Visor Peak & Face Grill
    final helmetCenter = Offset(shoulderX + s * 0.01, shoulderY - s * 0.08);
    final helmetRadius = s * 0.065;

    // Helmet dome
    canvas.drawCircle(helmetCenter, helmetRadius, bodyPaint);

    // Visor Peak
    final visorPath = Path()
      ..moveTo(helmetCenter.dx + helmetRadius * 0.2, helmetCenter.dy - helmetRadius * 0.4)
      ..lineTo(helmetCenter.dx + helmetRadius * 1.35, helmetCenter.dy + helmetRadius * 0.05)
      ..lineTo(helmetCenter.dx + helmetRadius * 0.6, helmetCenter.dy + helmetRadius * 0.35)
      ..close();
    canvas.drawPath(visorPath, accentPaint);

    // Metallic Face Grill (Silver helmet cage)
    final grillPaint = Paint()
      ..color = (isDark ? Colors.white70 : const Color(0xFF64748B))
      ..strokeWidth = math.max(0.8, s * 0.012)
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
    // 5. The Bat & 360° Helicopter Whirl Rotor
    // ----------------------------------------------------
    final double batLength = s * 0.44;
    final double batWidth = math.max(3.0, s * 0.048);
    double batAngle = -0.85; // Initial backlift stance angle

    if (progress < 0.22) {
      // Downswing into the blockhole
      final p = progress / 0.22;
      batAngle = ui.lerpDouble(-0.85, 0.32, p * p)!;
    } else if (isTwirling) {
      // THE 360° HELICOPTER WHIRL!
      final p = (progress - 0.22) / 0.52;
      // Fast start with powerful rotational torque
      final curvedP = Curves.fastLinearToSlowEaseIn.transform(p);
      batAngle = 0.32 + (curvedP * 2 * math.pi);
    } else {
      // Poise and reset
      final p = (progress - 0.74) / 0.26;
      final curvedP = Curves.easeInOutSine.transform(p);
      batAngle = ui.lerpDouble(0.32 + 2 * math.pi, 0.32 + 2 * math.pi + (math.pi * 0.65), curvedP)!;
    }

    // Helicopter 3D Rotor Blur Trails (Signature visual)
    if (isTwirling) {
      final p = (progress - 0.22) / 0.52;
      final sweepAngle = math.min(2.4, p * 2.8 * math.pi);
      final trailStartAngle = batAngle - sweepAngle;
      final trailRadius = batLength * 0.95;

      final trailRect = Rect.fromCircle(center: wristPivot, radius: trailRadius);

      // A. Outer Luminous Rotor Glow
      final rotorGlowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(4.0, s * 0.075)
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.sweep(
          wristPivot,
          [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.15),
            primaryColor.withValues(alpha: 0.60),
            accentGold.withValues(alpha: 0.90),
          ],
          [0.0, 0.30, 0.70, 1.0],
          TileMode.clamp,
          trailStartAngle,
          trailStartAngle + sweepAngle,
        );
      canvas.drawArc(trailRect, trailStartAngle, sweepAngle, false, rotorGlowPaint);

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
          [0.0, 0.55, 1.0],
          TileMode.clamp,
          trailStartAngle,
          trailStartAngle + sweepAngle,
        );
      canvas.drawArc(trailRect, trailStartAngle, sweepAngle, false, rotorCorePaint);
    }

    // Articulated Arms holding Bat Handle
    final armPaint = Paint()
      ..color = silhouetteColor
      ..strokeWidth = math.max(2.8, s * 0.046)
      ..strokeCap = StrokeCap.round;

    final handGripPos = wristPivot + Offset(
      math.cos(batAngle) * (batLength * 0.16),
      math.sin(batAngle) * (batLength * 0.16),
    );

    // Left Arm (Top Hand guide)
    canvas.drawLine(
      Offset(shoulderX - s * 0.02, shoulderY + s * 0.03),
      handGripPos,
      armPaint,
    );

    // Right Arm (Bottom Hand power generator)
    canvas.drawLine(
      Offset(shoulderX + s * 0.03, shoulderY + s * 0.04),
      handGripPos,
      armPaint,
    );

    // Batting Gloves (Molded padded gloves on handle)
    final glovePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(handGripPos, math.max(2.5, s * 0.035), glovePaint);

    // Draw the Detailed Cricket Bat
    canvas.save();
    canvas.translate(wristPivot.dx, wristPivot.dy);
    canvas.rotate(batAngle);

    // 1. Rubber Grip Handle
    final handlePaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = math.max(1.8, batWidth * 0.45)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-batLength * 0.12, 0),
      Offset(batLength * 0.20, 0),
      handlePaint,
    );

    // 2. English Willow Blade
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

    // 3. Bat Brand Crest (Kreeda Vermilion Badge)
    final stickerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(batLength * 0.36, -batWidth * 0.42, batLength * 0.35, batWidth * 0.84),
      Radius.circular(batWidth * 0.18),
    );
    canvas.drawRRect(stickerRect, accentPaint);

    canvas.restore();

    // ----------------------------------------------------
    // 6. Sweet-Spot Impact Explosion & Sparks (Phase 2)
    // ----------------------------------------------------
    if (isImpact) {
      final p = (progress - 0.22) / 0.10; // 0.0 to 1.0 during contact
      final shockwaveRadius = p * (s * 0.34);
      final shockwaveAlpha = (1.0 - p).clamp(0.0, 1.0);

      // Primary Energy Orange Sonic Ring
      final shockwavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, (1.0 - p) * (s * 0.045))
        ..color = primaryColor.withValues(alpha: shockwaveAlpha * 0.90);
      canvas.drawCircle(impactPoint, shockwaveRadius, shockwavePaint);

      // Secondary Gold Shockwave Ring
      final shockwaveGold = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, (1.0 - p) * (s * 0.030))
        ..color = accentGold.withValues(alpha: shockwaveAlpha * 0.75);
      canvas.drawCircle(impactPoint, shockwaveRadius * 0.65, shockwaveGold);

      // Sweet Spot Core Contact Flash
      final flashPaint = Paint()
        ..color = Colors.white.withValues(alpha: shockwaveAlpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(impactPoint, (1.0 - p) * (s * 0.10), flashPaint);

      // 8 Dynamic Radiating Sparks
      const sparkCount = 8;
      for (int i = 0; i < sparkCount; i++) {
        final sparkAngle = (i * (2 * math.pi / sparkCount)) + 0.25;
        final sparkDist = p * (s * 0.28);
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
          math.max(1.0, (1.0 - p) * (s * 0.024)),
          sparkPaint,
        );
      }
    }

    // ----------------------------------------------------
    // 7. Leather Ball & Sixer Rocket Comet
    // ----------------------------------------------------
    Offset ballPos = Offset.zero;
    bool shouldDrawBall = false;

    if (isIncoming) {
      // Yorker dips sharply into the blockhole
      final p = progress / 0.22;
      final curvedP = p * p; // Gravitational drop
      final startPos = Offset(w * 0.96, h * 0.18);
      ballPos = Offset(
        ui.lerpDouble(startPos.dx, impactPoint.dx, p)!,
        ui.lerpDouble(startPos.dy, impactPoint.dy, curvedP)!,
      );
      shouldDrawBall = true;
    } else if (isOutgoing) {
      // Ball launched skyward on explosive sixer trajectory
      final p = (progress - 0.24) / 0.64;
      final curvedP = Curves.easeOutQuad.transform(p);

      final targetX = w * 1.08;
      final targetY = h * 0.04;

      ballPos = Offset(
        ui.lerpDouble(impactPoint.dx, targetX, p)!,
        ui.lerpDouble(impactPoint.dy, targetY, curvedP)!,
      );
      shouldDrawBall = true;

      // Radiant Comet Tail behind soaring sixer
      final tailLength = math.min(s * 0.38, p * (s * 0.70));
      final tailVector = (ballPos - impactPoint);
      if (tailVector.distance > 2) {
        final norm = tailVector / tailVector.distance;
        final tailStart = ballPos - (norm * tailLength);

        // Outer Flame Trail
        final cometPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(2.2, s * 0.042)
          ..strokeCap = StrokeCap.round
          ..shader = ui.Gradient.linear(
            tailStart,
            ballPos,
            [
              Colors.transparent,
              primaryColor.withValues(alpha: 0.35),
              accentGold.withValues(alpha: 0.90),
            ],
            [0.0, 0.40, 1.0],
          );
        canvas.drawLine(tailStart, ballPos, cometPaint);

        // Core White Beam Streak
        final cometCorePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.2, s * 0.018)
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
      final ballRadius = math.max(3.2, s * 0.042);

      // Ambient ball glow
      final ballGlowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.50)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.8);
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
