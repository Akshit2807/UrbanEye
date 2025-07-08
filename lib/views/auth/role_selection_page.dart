import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:urbaneye/views/auth/widgets/auth_button.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'widgets/floating_role_card.dart';
import 'login_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Animated Logo and Title
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.report_problem_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ).animate()
                    .fadeIn(duration: 600.ms)
                    .scale(delay: 200.ms, duration: 600.ms)
                    .then()
                    .shimmer(delay: 1000.ms, duration: 2000.ms),

                const SizedBox(height: 32),

                Text(
                  'Civic Reporter',
                  style: AppTextStyles.hero.copyWith(color: Colors.white),
                ).animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 600.ms),

                const SizedBox(height: 12),

                Text(
                  'Building better communities together',
                  style: AppTextStyles.subtitle1.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, delay: 600.ms, duration: 600.ms),

                const SizedBox(height: 80),

                // Role Selection Cards
                Text(
                  'Choose your role',
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ).animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, delay: 800.ms, duration: 600.ms),

                const SizedBox(height: 40),

                FloatingRoleCard(
                  title: 'Civilian',
                  subtitle: 'Report civic issues in your community and make a difference',
                  icon: Icons.person_rounded,
                  isSelected: selectedRole == 'civilian',
                  animationDelay: 1000,
                  onTap: () {
                    setState(() {
                      selectedRole = 'civilian';
                    });
                  },
                ),

                const SizedBox(height: 24),

                FloatingRoleCard(
                  title: 'Social Worker',
                  subtitle: 'Help resolve community issues and build better neighborhoods',
                  icon: Icons.volunteer_activism_rounded,
                  isSelected: selectedRole == 'social_worker',
                  animationDelay: 1200,
                  onTap: () {
                    setState(() {
                      selectedRole = 'social_worker';
                    });
                  },
                ),

                const Spacer(),

                // Continue Button
                GradientButton(
                  text: 'Continue Your Journey',
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                  animationDelay: 1400,
                  onPressed: selectedRole != null
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
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
