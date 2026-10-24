import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/kreeda_button.dart';
import '../../../../core/widgets/kreeda_toast.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/otp_verification_sheet.dart';

/// CricHeroes-Inspired Cricketer Registration Screen.
/// Builds a real Cricket Resume: Personal details, playing role,
/// batting style, bowling style, and team referral code.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jerseyNameController = TextEditingController();
  final TextEditingController _jerseyNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  // Cricket Role Selection
  final List<Map<String, dynamic>> _cricketRoles = [
    {
      'id': 'batter',
      'label': 'Top-Order Batter',
      'icon': Icons.sports_cricket_rounded,
      'badge': 'BAT',
    },
    {
      'id': 'fast_bowler',
      'label': 'Fast Bowler',
      'icon': Icons.flash_on_rounded,
      'badge': 'PACE',
    },
    {
      'id': 'spinner',
      'label': 'Spin Bowler',
      'icon': Icons.autorenew_rounded,
      'badge': 'SPIN',
    },
    {
      'id': 'all_rounder',
      'label': 'All-Rounder',
      'icon': Icons.stars_rounded,
      'badge': 'ALL',
    },
    {
      'id': 'keeper',
      'label': 'Wicketkeeper',
      'icon': Icons.sports_handball_rounded,
      'badge': 'WK',
    },
    {
      'id': 'scorer',
      'label': 'Official Scorer',
      'icon': Icons.edit_note_rounded,
      'badge': 'SCORER',
    },
  ];
  String _selectedRole = 'all_rounder';

  // Batting Style: 0: Right Hand, 1: Left Hand
  int _battingStyle = 0;

  // Bowling Style
  final List<String> _bowlingStyles = [
    'Right-Arm Fast',
    'Right-Arm Medium',
    'Right-Arm Spin',
    'Left-Arm Fast',
    'Left-Arm Spin',
    'Do Not Bowl',
  ];
  String _selectedBowlingStyle = 'Right-Arm Fast';

  bool _agreedToTerms = true;
  bool _showTeamCodeField = false;

  @override
  void dispose() {
    _nameController.dispose();
    _jerseyNameController.dispose();
    _jerseyNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _teamCodeController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      KreedaToast.showError(context, 'Please enter your full name');
      return;
    }
    if (phone.isEmpty || phone.length < 8) {
      KreedaToast.showError(context, 'Please enter a valid mobile number');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      KreedaToast.showError(context, 'Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      KreedaToast.showError(context, 'Password must be at least 6 characters');
      return;
    }
    if (!_agreedToTerms) {
      KreedaToast.showError(context, 'Please agree to Kreeda Fair Play rules');
      return;
    }

    final fullNumber = '+91 $phone';
    OtpVerificationSheet.show(
      context,
      phoneNumber: fullNumber,
      onVerified: () {
        if (mounted) {
          KreedaToast.showSuccess(
            context,
            'Profile Created! Welcome $name to Kreeda Cricket!',
          );
          // Pop twice to get back to home/profile
          Navigator.pop(context);
          Navigator.maybePop(context);
        }
      },
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar
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
                    const AppLogo.header(height: 28),
                    const SizedBox(width: 40), // Balance width
                  ],
                ),

                const SizedBox(height: 12),

                // Hero Header
                Text(
                  'BUILD CRICKETER RESUME',
                  style: AppTypography.displayLarge(AppColors.textPrimary(context))
                      .copyWith(fontSize: 28, letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Text(
                  'Join millions of grassroots cricketers • Track stats, awards & live matches',
                  style: AppTypography.bodySmall(AppColors.textSecondary(context)),
                ),

                const SizedBox(height: 24),

                // SECTION 1: Personal Credentials
                _buildSectionTitle(context, '1. PERSONAL IDENTITY', Icons.person_pin_rounded),
                const SizedBox(height: 12),

                AuthTextField(
                  label: 'Full Name *',
                  hintText: 'e.g. Virat Kohli',
                  controller: _nameController,
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Jersey Name & Number in Row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: AuthTextField(
                        label: 'Jersey Name',
                        hintText: 'e.g. VK',
                        controller: _jerseyNameController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: AuthTextField(
                        label: 'Jersey #',
                        hintText: '#18',
                        controller: _jerseyNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                AuthTextField(
                  label: 'Mobile Number (For OTP Verification) *',
                  hintText: '98765 43210',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 4),
                        Text(
                          '+91',
                          style: AppTypography.bodyMedium(
                            AppColors.textPrimary(context),
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                AuthTextField(
                  label: 'Email Address *',
                  hintText: 'virat@example.com',
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

                const SizedBox(height: 14),

                AuthTextField(
                  label: 'Account Password *',
                  hintText: 'Minimum 6 characters',
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

                const SizedBox(height: 28),

                // SECTION 2: Cricket Role & Style (Signature CricHeroes)
                _buildSectionTitle(context, '2. PLAYING ROLE & STYLES', Icons.sports_cricket_rounded),
                const SizedBox(height: 12),

                // Primary Role Grid Pills
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _cricketRoles.map((role) {
                    final isSelected = _selectedRole == role['id'];

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _selectedRole = role['id']);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryOrange
                              : AppColors.surfaceElevated(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryOrange
                                : AppColors.border(context),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected ? AppShadows.orangeGlow : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              role['icon'] as IconData,
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary(context),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              role['label'] as String,
                              style: AppTypography.button(
                                isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary(context),
                              ).copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Batting Style Switcher
                Text(
                  'BATTING HAND',
                  style: AppTypography.caption(AppColors.textSecondary(context))
                      .copyWith(fontWeight: FontWeight.w700),
                ),
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _battingStyle = 0);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _battingStyle == 0
                                  ? AppColors.primaryOrange
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'RIGHT-HAND BAT 🏏',
                              style: AppTypography.button(
                                _battingStyle == 0
                                    ? Colors.white
                                    : AppColors.textSecondary(context),
                              ).copyWith(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _battingStyle = 1);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _battingStyle == 1
                                  ? AppColors.primaryOrange
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'LEFT-HAND BAT 🏏',
                              style: AppTypography.button(
                                _battingStyle == 1
                                    ? Colors.white
                                    : AppColors.textSecondary(context),
                              ).copyWith(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Bowling Style Dropdown / Selector
                Text(
                  'BOWLING STYLE',
                  style: AppTypography.caption(AppColors.textSecondary(context))
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _bowlingStyles.map((style) {
                    final isSelected = _selectedBowlingStyle == style;

                    return ChoiceChip(
                      label: Text(style),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryOrange,
                      backgroundColor: AppColors.surfaceElevated(context),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryOrange
                            : AppColors.border(context),
                      ),
                      onSelected: (val) {
                        if (val) {
                          HapticFeedback.lightImpact();
                          setState(() => _selectedBowlingStyle = style);
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // SECTION 3: Optional Team / Invite Code
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _showTeamCodeField = !_showTeamCodeField);
                  },
                  child: Row(
                    children: [
                      Icon(
                        _showTeamCodeField
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: AppColors.primary(context),
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'HAVE A TEAM OR TOURNAMENT INVITE CODE?',
                        style: AppTypography.caption(AppColors.primary(context))
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                if (_showTeamCodeField) ...[
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Team Referral Code',
                    hintText: 'e.g. KREEDA-ROYALS-2026',
                    controller: _teamCodeController,
                    prefix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.groups_rounded,
                        size: 20,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Fair Play & Terms Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          setState(() => _agreedToTerms = val ?? true);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'I agree to Kreeda Cricket Fair Play Rules, Anti-Corruption Code, and Terms of Service.',
                        style: AppTypography.caption(
                          AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Submit Button
                KreedaButton(
                  text: 'REGISTER & VERIFY VIA OTP',
                  onPressed: _handleRegistration,
                  icon: Icons.check_circle_outline_rounded,
                  height: 54,
                ),

                const SizedBox(height: 24),

                // Footer Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already registered cricketer?',
                      style: AppTypography.bodySmall(
                        AppColors.textSecondary(context),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'LOG IN',
                        style: AppTypography.bodySmall(AppColors.primary(context))
                            .copyWith(
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary(context)),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.titleMedium(AppColors.textPrimary(context))
              .copyWith(letterSpacing: 0.8),
        ),
      ],
    );
  }
}
