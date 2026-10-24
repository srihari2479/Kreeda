import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/kreeda_button.dart';
import '../../../../core/widgets/kreeda_loading.dart';
import '../../../../core/widgets/kreeda_toast.dart';

/// CricHeroes-style Interactive OTP Verification Bottom Sheet.
/// Features 6 tactile Neumorphic digit input boxes, haptic feedback,
/// countdown timer, and seamless auto-verification.
class OtpVerificationSheet extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerified;

  const OtpVerificationSheet({
    super.key,
    required this.phoneNumber,
    required this.onVerified,
  });

  static Future<void> show(
    BuildContext context, {
    required String phoneNumber,
    required VoidCallback onVerified,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      barrierColor: Colors.black.withValues(alpha: 0.65),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => OtpVerificationSheet(
        phoneNumber: phoneNumber,
        onVerified: onVerified,
      ),
    );
  }

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  int _secondsRemaining = 30;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startCountdown();

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      HapticFeedback.lightImpact();
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_currentCode.length == _otpLength) {
          _verifyOtp();
        }
      }
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _resendCode() {
    HapticFeedback.mediumImpact();
    for (var c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    _startCountdown();
    KreedaToast.showSuccess(context, 'New OTP sent to ${widget.phoneNumber}');
  }

  void _verifyOtp() {
    if (_currentCode.length < _otpLength) {
      KreedaToast.showError(context, 'Please enter all 6 digits of the OTP');
      return;
    }

    setState(() => _isVerifying = true);
    KreedaLoading.show(context, message: 'VERIFYING CRICKETER OTP...');

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      KreedaLoading.hide();
      setState(() => _isVerifying = false);

      Navigator.pop(context); // Close sheet
      KreedaToast.showSuccess(context, 'Verified! Welcome to Kreeda');
      widget.onVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Padding(
      padding: Responsive.modalBottomPadding(context, base: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Drag Pill Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title & Subtitle
          Text(
            'VERIFY PHONE NUMBER',
            style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.bodyMedium(AppColors.textSecondary(context)),
                children: [
                  const TextSpan(text: 'We sent a 6-digit verification code to\n'),
                  TextSpan(
                    text: widget.phoneNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 6 Tactile Neumorphic OTP Input Cells
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_otpLength, (index) {
              final isCellFocused = _focusNodes[index].hasFocus;
              final hasValue = _controllers[index].text.isNotEmpty;

              return Container(
                width: 46,
                height: 54,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF131A2E)
                      : const Color(0xFFF1F3F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCellFocused
                        ? AppColors.primaryOrange
                        : (hasValue
                            ? AppColors.primaryOrange.withValues(alpha: 0.5)
                            : AppColors.border(context)),
                    width: isCellFocused ? 2.0 : 1.2,
                  ),
                  boxShadow: isCellFocused ? AppShadows.orangeGlow : [],
                ),
                alignment: Alignment.center,
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onKeyEvent(index, event),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: AppTypography.headlineMedium(
                      AppColors.textPrimary(context),
                    ).copyWith(fontSize: 22),
                    cursorColor: AppColors.primaryOrange,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) => _onDigitChanged(index, val),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Resend Timer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _secondsRemaining > 0
                    ? 'Resend OTP in 0:${_secondsRemaining.toString().padLeft(2, '0')}s'
                    : "Didn't receive the OTP?",
                style: AppTypography.bodySmall(AppColors.textSecondary(context)),
              ),
              if (_secondsRemaining == 0) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _resendCode,
                  child: Text(
                    'RESEND NOW',
                    style: AppTypography.bodySmall(AppColors.primary(context))
                        .copyWith(
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Primary Verification Button
          KreedaButton(
            text: 'VERIFY & CONTINUE',
            isLoading: _isVerifying,
            onPressed: _verifyOtp,
            height: 52,
            icon: Icons.verified_user_rounded,
          ),
        ],
      ),
    );
  }
}
