// views/auth/role_selection_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> with TickerProviderStateMixin {
  String? selectedRole;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF334155),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Elements
            _buildBackgroundElements(),

            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 80),
                        _buildRoleCards(),
                        const SizedBox(height: 60),
                        _buildContinueButton(),
                        const SizedBox(height: 40),
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

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Floating orbs
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Positioned(
              top: 100 + _floatingController.value * 20,
              right: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Positioned(
              bottom: 150,
              left: 30,
              child: Container(
                width: 120 + _pulseController.value * 20,
                height: 120 + _pulseController.value * 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Rotating geometric shapes
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Positioned(
              top: 200,
              left: 30,
              child: Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Main Logo with Epic Animation
        Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing ring
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 120 + _pulseController.value * 40,
                  height: 120 + _pulseController.value * 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3 - _pulseController.value * 0.2),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

            // Main logo container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                    Color(0xFFEC4899),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.visibility_rounded,
                size: 50,
                color: Colors.white,
              ),
            ).animate()
                .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut)
                .then()
                .shimmer(delay: 1000.ms, duration: 3000.ms),
          ],
        ),

        const SizedBox(height: 40),

        // App Title with Gradient Text
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ).createShader(bounds),
          child: Text(
            'UrbanEye',
            style: AppTextStyles.hero.copyWith(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
        ).animate()
            .fadeIn(delay: 400.ms, duration: 800.ms)
            .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 800.ms)
            .then()
            .shimmer(delay: 1500.ms, duration: 2000.ms),

        const SizedBox(height: 16),

        // Subtitle with typing effect
        Text(
          'See the city, shape the future',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textSecondary,
            fontSize: 18,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ).animate()
            .fadeIn(delay: 800.ms, duration: 800.ms)
            .slideY(begin: 0.3, end: 0, delay: 800.ms, duration: 800.ms),

        const SizedBox(height: 12),

        // Feature highlights
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'AI-Powered • Real-time • Community-driven',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ).animate()
            .fadeIn(delay: 1200.ms, duration: 600.ms)
            .scale(delay: 1200.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildRoleCards() {
    return Column(
      children: [
        Text(
          'Choose your role',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
            fontSize: 28,
          ),
        ).animate()
            .fadeIn(delay: 1400.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, delay: 1400.ms),

        const SizedBox(height: 40),

        // Civilian Card
        _buildEpicRoleCard(
          role: 'civilian',
          title: 'Civilian',
          subtitle: 'Report civic issues and make your city better',
          description: 'Perfect for residents who want to contribute to their community',
          icon: Icons.person_rounded,
          gradient: AppColors.primaryGradient,
          features: ['Report Issues', 'Track Progress', 'AI Analysis'],
          delay: 1600,
        ),

        const SizedBox(height: 24),

        // Social Worker Card
        _buildEpicRoleCard(
          role: 'social_worker',
          title: 'Social Worker',
          subtitle: 'Help resolve issues and build better communities',
          description: 'For professionals who solve community problems',
          icon: Icons.volunteer_activism_rounded,
          gradient: AppColors.secondaryGradient,
          features: ['Accept Requests', 'Earn Rewards', 'Build Reputation'],
          delay: 1800,
        ),
      ],
    );
  }

  Widget _buildEpicRoleCard({
    required String role,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required List<String> features,
    required int delay,
  }) {
    final isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(isSelected ? 1.02 : 1.0)
          ..translate(0.0, isSelected ? -5.0 : 0.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: isSelected ? gradient : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : AppColors.textTertiary.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.4)
                    : Colors.black.withOpacity(0.1),
                blurRadius: isSelected ? 30 : 15,
                offset: Offset(0, isSelected ? 15 : 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Icon with animated background
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 80 + _pulseController.value * 20,
                          height: 80 + _pulseController.value * 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1 - _pulseController.value * 0.05),
                          ),
                        );
                      },
                    ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 36,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Title and subtitle
              Text(
                title,
                style: AppTextStyles.heading3.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected
                      ? Colors.white.withOpacity(0.8)
                      : AppColors.textTertiary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Features
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: features.map((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withOpacity(0.3)
                            : AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      feature,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (isSelected) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Selected',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 800.ms)
        .slideY(begin: 0.5, end: 0, delay: Duration(milliseconds: delay), duration: 800.ms)
        .then()
        .shimmer(delay: Duration(milliseconds: delay + 1000), duration: 1500.ms);
  }

  Widget _buildContinueButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: selectedRole != null
            ? const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        )
            : null,
        color: selectedRole != null ? null : AppColors.textTertiary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: selectedRole != null ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: selectedRole != null
              ? () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, _) =>
                    LoginPage(role: selectedRole!),
                transitionsBuilder: (context, animation, _, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  );
                },
              ),
            );
          }
              : null,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue Your Journey',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: selectedRole != null
                        ? Colors.white
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: selectedRole != null
                      ? Colors.white
                      : AppColors.textTertiary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: 2000.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: 2000.ms, duration: 600.ms);
  }
}