import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/kreeda_button.dart';
import '../../../../core/widgets/kreeda_loading.dart';
import '../../../../core/widgets/kreeda_toast.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/otp_verification_sheet.dart';
import 'signup_screen.dart';

/// Country model for the phone dial code selector.
class CountryCode {
  final String flag;
  final String name;
  final String dialCode;

  const CountryCode({
    required this.flag,
    required this.name,
    required this.dialCode,
  });
}

/// CricHeroes-Inspired Cricketer Login Screen.
/// Supports Phone OTP (grassroots favorite) and Email credentials,
/// social sign-ins, and guest access.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 0: Phone OTP, 1: Email & Password
  int _loginMode = 0;

  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  final List<CountryCode> _countries = const [
    CountryCode(flag: '🇮🇳', name: 'India', dialCode: '+91'),
    CountryCode(flag: '🇦🇺', name: 'Australia', dialCode: '+61'),
    CountryCode(flag: '🇬🇧', name: 'UK', dialCode: '+44'),
    CountryCode(flag: '🇦🇪', name: 'UAE', dialCode: '+971'),
    CountryCode(flag: '🇿🇦', name: 'South Africa', dialCode: '+27'),
    CountryCode(flag: '🇱🇰', name: 'Sri Lanka', dialCode: '+94'),
    CountryCode(flag: '🇳🇿', name: 'New Zealand', dialCode: '+64'),
    CountryCode(flag: '🇧🇩', name: 'Bangladesh', dialCode: '+880'),
    CountryCode(flag: '🌴', name: 'West Indies', dialCode: '+1'),
  ];
  late CountryCode _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handlePhoneLogin() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 8) {
      KreedaToast.showError(context, 'Please enter a valid mobile number');
      return;
    }

    final fullNumber = '${_selectedCountry.dialCode} $phone';
    OtpVerificationSheet.show(
      context,
      phoneNumber: fullNumber,
      onVerified: () {
        if (mounted) {
          Navigator.pop(context); // Return back to app
        }
      },
    );
  }

  void _handleEmailLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      KreedaToast.showError(context, 'Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      KreedaToast.showError(context, 'Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);
    KreedaLoading.show(context, message: 'LOGGING IN TO KREEDA...');

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      KreedaLoading.hide();
      setState(() => _isLoading = false);
      KreedaToast.showSuccess(context, 'Welcome back, Cricketer!');
      Navigator.pop(context);
    });
  }

  void _handleSocialLogin(String provider) {
    HapticFeedback.lightImpact();
    KreedaLoading.show(context, message: 'AUTHENTICATING WITH $provider...');
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      KreedaLoading.hide();
      KreedaToast.showSuccess(context, 'Connected with $provider');
      Navigator.pop(context);
    });
  }

  void _showForgotPasswordDialog() {
    final resetController = TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'RESET PASSWORD',
          style: AppTypography.headlineMedium(AppColors.textPrimary(context)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your registered email address and we will send you a password reset link.',
              style: AppTypography.bodySmall(AppColors.textSecondary(context)),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              label: 'Email Address',
              hintText: 'name@example.com',
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: AppTypography.caption(AppColors.textSecondary(context)),
            ),
          ),
          KreedaButton(
            text: 'SEND LINK',
            height: 40,
            width: 120,
            onPressed: () {
              Navigator.pop(ctx);
              KreedaToast.showSuccess(
                context,
                'Password reset link sent to ${resetController.text}',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: Responsive.modalBottomPadding(context, base: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SELECT COUNTRY CODE',
              style: AppTypography.headlineSmall(AppColors.textPrimary(context)),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final c = _countries[index];
                  final isSelected = c.dialCode == _selectedCountry.dialCode;

                  return ListTile(
                    leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                    title: Text(
                      c.name,
                      style: AppTypography.bodyMedium(
                        AppColors.textPrimary(context),
                      ).copyWith(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      c.dialCode,
                      style: AppTypography.titleMedium(
                        isSelected
                            ? AppColors.primary(context)
                            : AppColors.textSecondary(context),
                      ),
                    ),
                    onTap: () {
                      setState(() => _selectedCountry = c);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveHorizontalPadding;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar: Back Button & Guest Mode Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary(context),
                      size: 20,
                    ),
                    tooltip: 'Back',
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Text(
                      'EXPLORE AS GUEST',
                      style: AppTypography.caption(
                        AppColors.textSecondary(context),
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    label: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Welcome to [center] and below center only Kreeda logo
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'WELCOME TO',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayLarge(AppColors.textPrimary(context))
                          .copyWith(
                            fontSize: 28,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const AppLogo.header(
                      height: 56,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your cricket resume, match scores & live grassroots tournaments',
                style: AppTypography.bodySmall(AppColors.textSecondary(context)),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border(context).withValues(alpha: 0.5),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    // Phone OTP Mode
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _loginMode = 0);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _loginMode == 0
                                ? AppColors.primaryOrange
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 16,
                                color: _loginMode == 0
                                    ? Colors.white
                                    : AppColors.textSecondary(context),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PHONE OTP',
                                style: AppTypography.button(
                                  _loginMode == 0
                                      ? Colors.white
                                      : AppColors.textSecondary(context),
                                ).copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Email Mode
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _loginMode = 1);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _loginMode == 1
                                ? AppColors.primaryOrange
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_rounded,
                                size: 16,
                                color: _loginMode == 1
                                    ? Colors.white
                                    : AppColors.textSecondary(context),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'EMAIL & PASSWORD',
                                style: AppTypography.button(
                                  _loginMode == 1
                                      ? Colors.white
                                      : AppColors.textSecondary(context),
                                ).copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Mode Form
              if (_loginMode == 0) ...[
                // Phone Number Input
                AuthTextField(
                  label: 'Mobile Number',
                  hintText: 'Enter 10-digit number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  prefix: GestureDetector(
                    onTap: _showCountryPicker,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountry.flag,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _selectedCountry.dialCode,
                            style: AppTypography.bodyMedium(
                              AppColors.textPrimary(context),
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: AppColors.textSecondary(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Fast Demo Cricketer Helper Chip
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _phoneController.text = '9876543210';
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary(context).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 14,
                            color: AppColors.primary(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Quick Demo Fill: 98765 43210',
                            style: AppTypography.caption(AppColors.primary(context))
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Primary Phone Action
                KreedaButton(
                  text: 'GET OTP VIA SMS',
                  isLoading: _isLoading,
                  onPressed: _handlePhoneLogin,
                  icon: Icons.send_rounded,
                  height: 52,
                ),
              ] else ...[
                // Email Input
                AuthTextField(
                  label: 'Email Address',
                  hintText: 'cricketer@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.alternate_email_rounded,
                      size: 20,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password Input
                AuthTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _showForgotPasswordDialog,
                    child: Text(
                      'FORGOT PASSWORD?',
                      style: AppTypography.caption(AppColors.primary(context))
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Primary Email Action
                KreedaButton(
                  text: 'LOG IN TO KREEDA',
                  isLoading: _isLoading,
                  onPressed: _handleEmailLogin,
                  icon: Icons.login_rounded,
                  height: 52,
                ),
              ],

              const SizedBox(height: 28),

              // Social Sign-In Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border(context))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: AppTypography.caption(AppColors.textMuted(context))
                          .copyWith(letterSpacing: 0.8),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border(context))),
                ],
              ),

              const SizedBox(height: 20),

              // Social Auth Buttons (Google & Apple)
              Row(
                children: [
                  // Google
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _handleSocialLogin('Google'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.border(context).withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFF4285F4),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'GOOGLE',
                                style: AppTypography.button(
                                  AppColors.textPrimary(context),
                                ).copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Apple
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _handleSocialLogin('Apple'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.border(context).withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apple,
                              size: 22,
                              color: AppColors.textPrimary(context),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'APPLE',
                                style: AppTypography.button(
                                  AppColors.textPrimary(context),
                                ).copyWith(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Register Footer Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have a cricketer profile?",
                    style: AppTypography.bodySmall(AppColors.textSecondary(context)),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'REGISTER NOW',
                      style: AppTypography.bodySmall(AppColors.primary(context))
                          .copyWith(
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
