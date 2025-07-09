// views/auth/widgets/animated_auth_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_styles.dart';

class AnimatedAuthField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int animationDelay;

  const AnimatedAuthField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  State<AnimatedAuthField> createState() => _AnimatedAuthFieldState();
}

class _AnimatedAuthFieldState extends State<AnimatedAuthField> {
  bool _obscureText = true;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                blurRadius: _isFocused ? 20 : 10,
                offset: Offset(0, _isFocused ? 8 : 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,
            enabled: widget.enabled,
            focusNode: _focusNode,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Container(
                margin: const EdgeInsets.only(left: 16, right: 12),
                child: widget.prefixIcon,
              )
                  : null,
              suffixIcon: widget.isPassword
                  ? Container(
                margin: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              )
                  : widget.suffixIcon != null
                  ? Container(
                margin: const EdgeInsets.only(right: 16),
                child: widget.suffixIcon,
              )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.textTertiary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(
      delay: Duration(milliseconds: widget.animationDelay),
      duration: const Duration(milliseconds: 600),
    ).slideY(
      begin: 0.3,
      end: 0,
      delay: Duration(milliseconds: widget.animationDelay),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}