import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_styles.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Gradient? gradient;
  final Color? color;
  final double height;
  final double borderRadius;
  final int animationDelay;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.gradient,
    this.color,
    this.height = 56,
    this.borderRadius = 16,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.98 : 1.0),
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isOutlined ? null : (widget.gradient ?? AppColors.primaryGradient),
            color: widget.isOutlined ? Colors.transparent : widget.color,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.isOutlined
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: widget.isOutlined
                ? null
                : [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : Text(
                  widget.text,
                  style: AppTextStyles.button.copyWith(
                    color: widget.isOutlined
                        ? AppColors.primary
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
