// views/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:urbaneye/views/auth/widgets/auth_button.dart';
import 'dart:ui';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'widgets/animated_auth_field.dart';
import 'widgets/glassmorphic_container.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement Firebase Auth login
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      setState(() {
        _isLoading = false;
      });

      // Navigate to appropriate dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Welcome back! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getRoleGradient(),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
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

                const SizedBox(height: 60),

                // Main Content Card
                GlassmorphicContainer(
                  borderRadius: BorderRadius.circular(32),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with floating icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: _getRoleGradient(),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getRoleIcon(),
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ).animate()
                                  .fadeIn(delay: 600.ms, duration: 600.ms)
                                  .scale(delay: 600.ms, duration: 600.ms)
                                  .then()
                                  .shimmer(delay: 1200.ms, duration: 2000.ms),

                              const SizedBox(width: 20),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome Back!',
                                      style: AppTextStyles.heading2,
                                    ).animate()
                                        .fadeIn(delay: 800.ms, duration: 600.ms)
                                        .slideX(begin: 0.3, end: 0, delay: 800.ms),

                                    Text(
                                      _getRoleTitle(),
                                      style: AppTextStyles.subtitle2.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).animate()
                                        .fadeIn(delay: 1000.ms, duration: 600.ms)
                                        .slideX(begin: 0.3, end: 0, delay: 1000.ms),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            _getRoleSubtitle(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ).animate()
                              .fadeIn(delay: 1200.ms, duration: 600.ms),

                          const SizedBox(height: 48),

                          // Form Fields
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

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
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

                          const SizedBox(height: 40),

                          // Login Button
                          GradientButton(
                            text: 'Sign In',
                            gradient: _getRoleGradient(),
                            onPressed: _handleLogin,
                            isLoading: _isLoading,
                            animationDelay: 2000,
                          ),

                          const SizedBox(height: 32),

                          // Social Login Options
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'or continue with',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300)),
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

                          // Signup Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.bodyMedium,
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
                  ),
                ).animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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