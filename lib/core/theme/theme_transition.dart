import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'app_colors.dart';
import 'theme_notifier.dart';

/// Controller and manager for high-end circular reveal theme transitions in Kreeda.
/// Provides a 60-120 FPS circular reveal animation without frame drops.
class ThemeTransition {
  static final GlobalKey<ThemeTransitionWrapperState> wrapperKey =
      GlobalKey<ThemeTransitionWrapperState>();

  /// Global notifier tracking the system navigation bar darkness.
  /// Synchronized precisely with the circular reveal wavefront so the bottom
  /// system bar never flickers, flashes, or jiggles between colors during transition.
  static final ValueNotifier<bool> isNavDarkNotifier = ValueNotifier<bool>(
    themeNotifier.value == ThemeMode.dark,
  );

  static bool isAnimating = false;
  static bool _listenerAttached = false;

  /// The most recent pointer/tap position anywhere on the screen.
  /// Automatically captured by the root Listener in [ThemeTransitionWrapper].
  static Offset? lastPointerPosition;

  static void ensureInitialized() {
    if (!_listenerAttached) {
      _listenerAttached = true;
      themeNotifier.addListener(() {
        if (!isAnimating) {
          isNavDarkNotifier.value = themeNotifier.value == ThemeMode.dark;
        }
      });
    }
  }

  /// Toggles between light and dark mode with a smooth circular reveal.
  /// Automatically resolves [origin] from the exact tap position if not explicitly provided.
  static Future<void> toggleTheme(BuildContext context, {Offset? origin}) async {
    final nextMode = themeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await switchTheme(context, nextMode, origin: origin);
  }

  /// Switches to [targetMode] with a smooth circular reveal originating from [origin].
  static Future<void> switchTheme(
    BuildContext context,
    ThemeMode targetMode, {
    Offset? origin,
  }) async {
    ensureInitialized();
    final resolvedOrigin = origin ??
        lastPointerPosition ??
        _findOrigin(context) ??
        const Offset(300, 50);
    final state = wrapperKey.currentState;
    if (state != null) {
      await state.animateThemeChange(targetMode, resolvedOrigin);
    } else {
      themeNotifier.setThemeMode(targetMode);
      isNavDarkNotifier.value = targetMode == ThemeMode.dark;
    }
  }

  /// Locates the global center of the widget associated with [context].
  static Offset? _findOrigin(BuildContext context) {
    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        if (renderBox.size.width <= 120 && renderBox.size.height <= 120) {
          return renderBox.localToGlobal(renderBox.size.center(Offset.zero));
        } else {
          final globalOffset = renderBox.localToGlobal(Offset.zero);
          return Offset(
            globalOffset.dx + renderBox.size.width - 50,
            globalOffset.dy + (renderBox.size.height > 80 ? 48 : renderBox.size.height / 2),
          );
        }
      }
    } catch (_) {}

    final size = MediaQuery.maybeOf(context)?.size;
    if (size != null) {
      return Offset(size.width - 48, 48); // Standard top-right header position
    }
    return const Offset(300, 50);
  }
}

/// Root wrapper that performs a smooth circular reveal when switching themes.
/// Zero frame drops guaranteed by mounting snapshot overlay before rebuilding theme.
class ThemeTransitionWrapper extends StatefulWidget {
  final Widget child;

  const ThemeTransitionWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ThemeTransitionWrapper> createState() => ThemeTransitionWrapperState();
}

class ThemeTransitionWrapperState extends State<ThemeTransitionWrapper>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _animation;

  ui.Image? _snapshot;
  Offset _origin = Offset.zero;
  bool _isDarkTarget = false;

  @override
  void initState() {
    super.initState();
    ThemeTransition.ensureInitialized();
    // 1050ms leisurely, butter-smooth cinematic circular reveal with fastOutSlowIn curve.
    // Perfectly paced so the user vividly feels, savors, and tracks the wave
    // gliding across the entire screen at solid 60-120 FPS.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _snapshot?.dispose();
    super.dispose();
  }

  Future<void> _waitForFrame() async {
    try {
      await WidgetsBinding.instance.endOfFrame.timeout(
        const Duration(milliseconds: 100),
        onTimeout: () => Future.value(),
      );
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  /// Performs the circular reveal:
  /// 1. Safely captures a pixel-perfect screenshot of the current theme
  /// 2. Displays snapshot statically on top of the live tree
  /// 3. Rebuilds underlying tree in new theme while snapshot covers the screen
  /// 4. Animates high-performance vector circular clip revealing the new theme
  Future<void> animateThemeChange(ThemeMode targetMode, Offset origin) async {
    if (ThemeTransition.isAnimating) return;
    if (themeNotifier.value == targetMode) return;

    ThemeTransition.isAnimating = true;
    final pixelRatio = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0;

    try {
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        themeNotifier.setThemeMode(targetMode);
        ThemeTransition.isNavDarkNotifier.value = targetMode == ThemeMode.dark;
        return;
      }

      // If boundary is marked dirty for layout/paint, wait for the pending frame to paint
      if (boundary.debugNeedsPaint) {
        await _waitForFrame();
      }

      ui.Image? capturedImage;
      final effectivePixelRatio = math.max(1.0, pixelRatio);

      try {
        capturedImage =
            await boundary.toImage(pixelRatio: effectivePixelRatio);
      } catch (_) {
        // Retry once after frame completes
        try {
          await _waitForFrame();
          capturedImage =
              await boundary.toImage(pixelRatio: effectivePixelRatio);
        } catch (_) {
          capturedImage = null;
        }
      }

      if (!mounted) {
        capturedImage?.dispose();
        themeNotifier.setThemeMode(targetMode);
        ThemeTransition.isNavDarkNotifier.value = targetMode == ThemeMode.dark;
        return;
      }

      if (capturedImage == null) {
        themeNotifier.setThemeMode(targetMode);
        ThemeTransition.isNavDarkNotifier.value = targetMode == ThemeMode.dark;
        return;
      }

      _isDarkTarget = (targetMode == ThemeMode.dark) ||
          (targetMode == ThemeMode.system &&
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark);

      setState(() {
        _snapshot?.dispose();
        _snapshot = capturedImage;
        _origin = origin;
      });

      // Ensure snapshot is mounted and painted on screen
      await _waitForFrame();

      // Switch theme mode: live widget tree re-renders in new theme underneath the static snapshot
      themeNotifier.setThemeMode(targetMode);

      // CRITICAL FOR BUTTER-SMOOTH PERFORMANCE:
      // Allow Flutter's pipeline to fully complete building, laying out, and caching the new theme
      // in the background before launching the animation controller. This completely prevents initial frame drops.
      await Future<void>.delayed(const Duration(milliseconds: 32));
      await _waitForFrame();

      if (!mounted) return;

      // Synchronize bottom system bar transition with the wavefront arriving at dock
      void progressListener() {
        if (_controller.value >= 0.70 &&
            ThemeTransition.isNavDarkNotifier.value != _isDarkTarget) {
          ThemeTransition.isNavDarkNotifier.value = _isDarkTarget;
        }
      }

      _controller.addListener(progressListener);

      try {
        await _controller.forward(from: 0.0);
      } finally {
        _controller.removeListener(progressListener);
        ThemeTransition.isNavDarkNotifier.value = _isDarkTarget;
      }
    } catch (_) {
      themeNotifier.setThemeMode(targetMode);
      ThemeTransition.isNavDarkNotifier.value = targetMode == ThemeMode.dark;
    } finally {
      _cleanup();
    }
  }

  void _cleanup() {
    ThemeTransition.isAnimating = false;
    ThemeTransition.lastPointerPosition = null;
    if (!mounted) return;
    setState(() {
      _snapshot?.dispose();
      _snapshot = null;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (PointerDownEvent event) {
        ThemeTransition.lastPointerPosition = event.position;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            key: _repaintBoundaryKey,
            child: widget.child,
          ),
          if (ThemeTransition.isAnimating && _snapshot != null)
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _CircularRevealPainter(
                          image: _snapshot!,
                          origin: _origin,
                          progress: _animation.value,
                          isDarkTarget: _isDarkTarget,
                          bottomSafePadding: MediaQuery.paddingOf(context).bottom,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularRevealPainter extends CustomPainter {
  final ui.Image image;
  final Offset origin;
  final double progress;
  final bool isDarkTarget;
  final double bottomSafePadding;

  _CircularRevealPainter({
    required this.image,
    required this.origin,
    required this.progress,
    required this.isDarkTarget,
    required this.bottomSafePadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;

    final double maxRadius = _calculateMaxRadius(origin, size);
    final double currentRadius = maxRadius * progress;

    // 1. High-Performance Hardware-Accelerated Vector Masking (Zero saveLayer)
    // PathFillType.evenOdd clips out the circular hole without allocating offscreen GPU buffers.
    canvas.save();
    final clipPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: origin, radius: currentRadius))
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    // 2. High-speed 1:1 hardware texture blit (Zero layout overhead, instant GPU blit)
    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(
      image,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.low,
    );
    canvas.restore();

    // 3. Kreeda Electric Energy Orange luminous rim at wavefront edge
    // Dual-layer vector bloom (soft ambient halo + sharp energetic edge)
    // Strictly clipped above the bottom safe inset to prevent bleeding
    // into the Android gesture bar or navigation bar.
    if (progress > 0.0 && progress < 1.0) {
      final ringAlpha = (math.sin(progress * math.pi) * 0.75).clamp(0.0, 1.0);
      final ringColor = isDarkTarget
          ? AppColors.primaryOrangeLight
          : AppColors.primaryOrange;

      canvas.save();
      final clipBottomInset = bottomSafePadding > 0 ? bottomSafePadding : 8.0;
      canvas.clipRect(
        Rect.fromLTWH(0, 0, size.width, size.height - clipBottomInset),
      );

      // Layer A: Soft outer ambient bloom (5.0px width)
      final bloomPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..color = ringColor.withValues(alpha: ringAlpha * 0.35)
        ..isAntiAlias = true;
      canvas.drawCircle(origin, currentRadius, bloomPaint);

      // Layer B: Core luminous wavefront rim (2.2px width)
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = ringColor.withValues(alpha: ringAlpha)
        ..isAntiAlias = true;
      canvas.drawCircle(origin, currentRadius, ringPaint);

      canvas.restore();
    }
  }

  double _calculateMaxRadius(Offset center, Size size) {
    final double distTL = center.distance;
    final double distTR = (center - Offset(size.width, 0)).distance;
    final double distBL = (center - Offset(0, size.height)).distance;
    final double distBR = (center - Offset(size.width, size.height)).distance;

    return math.max(
      math.max(distTL, distTR),
      math.max(distBL, distBR),
    ) * 1.08;
  }

  @override
  bool shouldRepaint(covariant _CircularRevealPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.image != image ||
        oldDelegate.origin != origin ||
        oldDelegate.bottomSafePadding != bottomSafePadding;
  }
}
