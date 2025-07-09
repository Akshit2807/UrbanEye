// views/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../views/civilian/civilian_dashboard.dart';
import '../../views/social_worker/social_worker_dashboard.dart';
import 'widgets/animated_auth_field.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getRoleTitle() {
    return widget.role == 'civilian' ? 'Civilian' : 'Social Worker';
  }

  String _getRoleSubtitle() {
    return widget.role == 'civilian'
        ? 'Report issues, create change'
        : 'Be the change you want to see';
  }

  IconData _getRoleIcon() {
    return widget.role == 'civilian' ? Icons.person_rounded : Icons.volunteer_activism_rounded;
  }

  Gradient _getRoleGradient() {
    return widget.role == 'civilian'
        ? AppColors.primaryGradient
        : AppColors.secondaryGradient;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result != null && result.user != null) {
        final userRole = await _authService.getUserRole(result.user!.uid);

        if (userRole == null) {
          throw Exception('User role not found');
        }

        if (mounted) {
          if (userRole == 'civilian') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CivilianDashboard(),
              ),
            );
          } else if (userRole == 'social_worker') {
            final userData = await _authService.getUserData(result.user!.uid);
            final category = userData?['category'] ?? 'private';

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SocialWorkerDashboard(category: category),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email first'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      await _authService.resetPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getRoleGradient(),
        ),
        child: Stack(
          children: [
            _buildAnimatedBackground(),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildLoginCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Positioned(
              top: 100 + _floatingController.value * 30,
              right: 30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Positioned(
              bottom: 200,
              left: 20,
              child: Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
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
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).scale(delay: 200.ms),

            const Spacer(),

            Text(
              'Sign In',
              style: AppTextStyles.heading2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ).animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),

            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),

        const SizedBox(height: 40),

        // Role indicator with animation
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 100 + _pulseController.value * 20,
                  height: 100 + _pulseController.value * 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3 - _pulseController.value * 0.2),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _getRoleIcon(),
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ).animate()
            .scale(delay: 600.ms, duration: 800.ms, curve: Curves.elasticOut),

        const SizedBox(height: 24),

        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.8)],
          ).createShader(bounds),
          child: Text(
            'Welcome Back!',
            style: AppTextStyles.heading1.copyWith(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ).animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, delay: 800.ms),

        const SizedBox(height: 8),

        Text(
          _getRoleSubtitle(),
          style: AppTextStyles.subtitle1.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ).animate()
            .fadeIn(delay: 1000.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Continue as ${_getRoleTitle()}',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ).animate()
                .fadeIn(delay: 1200.ms, duration: 600.ms),

            const SizedBox(height: 32),

            AnimatedAuthField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              animationDelay: 1400,
              prefixIcon: const Icon(
                Icons.email_rounded,
                color: AppColors.textTertiary,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            AnimatedAuthField(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordController,
              isPassword: true,
              animationDelay: 1600,
              prefixIcon: const Icon(
                Icons.lock_rounded,
                color: AppColors.textTertiary,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ).animate()
                .fadeIn(delay: 1800.ms, duration: 600.ms),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: _getRoleGradient(),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
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
                  onTap: _isLoading ? null : _handleLogin,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      'Sign In',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ).animate()
                .fadeIn(delay: 2000.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 2000.ms),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(child: Divider(color: AppColors.textTertiary.withOpacity(0.3))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.textTertiary.withOpacity(0.3))),
              ],
            ).animate()
                .fadeIn(delay: 2200.ms, duration: 600.ms),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildSocialButton(
                    'Google',
                    Icons.g_mobiledata_rounded,
                        () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSocialButton(
                    'Apple',
                    Icons.apple_rounded,
                        () {},
                  ),
                ),
              ],
            ).animate()
                .fadeIn(delay: 2400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 2400.ms),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, _) =>
                            SignupPage(role: widget.role),
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
                  },
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ).animate()
                .fadeIn(delay: 2600.ms, duration: 600.ms),
          ],
        ),
      ),
    ).animate()
        .fadeIn(delay: 1000.ms, duration: 800.ms)
        .slideY(begin: 0.3, end: 0, delay: 1000.ms, duration: 800.ms);
  }

  Widget _buildSocialButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textTertiary.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}