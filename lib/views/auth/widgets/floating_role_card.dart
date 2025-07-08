import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_styles.dart';

class FloatingRoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int animationDelay;

  const FloatingRoleCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  State<FloatingRoleCard> createState() => _FloatingRoleCardState();
}

class _FloatingRoleCardState extends State<FloatingRoleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..scale(widget.isSelected || _isHovered ? 1.05 : 1.0)
            ..translate(0.0, widget.isSelected || _isHovered ? -5.0 : 0.0),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: widget.isSelected ? 30 : 20,
                  offset: Offset(0, widget.isSelected ? 15 : 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: widget.isSelected
                        ? AppColors.primaryGradient
                        : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? Colors.white.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          size: 36,
                          color: widget.isSelected
                              ? Colors.white
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.title,
                        style: AppTextStyles.heading3.copyWith(
                          color: widget.isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: widget.isSelected
                              ? Colors.white.withOpacity(0.9)
                              : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: widget.animationDelay),
      duration: const Duration(milliseconds: 800),
    ).slideY(
      begin: 0.5,
      end: 0,
      delay: Duration(milliseconds: widget.animationDelay),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }
}
