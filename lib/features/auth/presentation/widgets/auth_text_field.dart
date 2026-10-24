import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Tactile Neumorphic Text Field designed for Kreeda Auth & Profile onboarding.
class AuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? helperText;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.prefix,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.helperText,
    this.maxLines = 1,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscured = widget.isPassword || widget.obscureText;
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: AppTypography.caption(
                _isFocused
                    ? AppColors.primary(context)
                    : AppColors.textSecondary(context),
              ).copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            if (widget.helperText != null)
              Text(
                widget.helperText!,
                style: AppTypography.caption(AppColors.textMuted(context)),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Neumorphic Input Container
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF131A2E)
                : const Color(0xFFF1F3F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused
                  ? AppColors.primaryOrange
                  : AppColors.border(context),
              width: _isFocused ? 1.5 : 1.0,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                widget.prefix!,
                Container(
                  height: 24,
                  width: 1,
                  color: AppColors.border(context),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: _obscured,
                  validator: widget.validator,
                  onChanged: widget.onChanged,
                  inputFormatters: widget.inputFormatters,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  maxLines: widget.maxLines,
                  style: AppTypography.bodyMedium(
                    AppColors.textPrimary(context),
                  ).copyWith(fontWeight: FontWeight.w600),
                  cursorColor: AppColors.primaryOrange,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTypography.bodyMedium(
                      AppColors.textMuted(context),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => _obscured = !_obscured);
                  },
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary(context),
                    size: 20,
                  ),
                )
              else if (widget.suffix != null)
                widget.suffix!,
            ],
          ),
        ),
      ],
    );
  }
}
