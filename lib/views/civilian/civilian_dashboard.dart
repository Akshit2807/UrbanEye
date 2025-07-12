// views/civilian/civilian_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'community_page.dart';
import 'leaderboard_page.dart';
import 'report_issue_page.dart';
import 'my_reports_page.dart';

class CivilianDashboard extends StatefulWidget {
  const CivilianDashboard({Key? key}) : super(key: key);

  @override
  State<CivilianDashboard> createState() => _CivilianDashboardState();
}

class _CivilianDashboardState extends State<CivilianDashboard> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardHome(),
    const LeaderboardPage(),
    const CommunityPage(),
    const MyReportsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
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
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _selectedIndex == 0
              ? _buildDashboardHome()
              : _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: _buildEpicBottomNav(),
      floatingActionButton: _selectedIndex == 0 ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Positioned(
              top: 100 + _floatingController.value * 50,
              right: 20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
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
              left: 30,
              child: Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.2),
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

  Widget _buildEpicBottomNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.leaderboard_rounded, 'Rankings'),
          _buildNavItem(2, Icons.forum_rounded, 'Community'),
          _buildNavItem(3, Icons.assignment_rounded, 'Reports'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : AppColors.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportIssuePage(),
                ),
              );
            },
            backgroundColor: AppColors.accent,
            elevation: 15,
            icon: const Icon(
              Icons.add_a_photo_rounded,
              color: Colors.white,
            ),
            label: Text(
              'Report Issue',
              style: AppTextStyles.button.copyWith(fontSize: 14),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardHome() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEpicHeader(),
              const SizedBox(height: 30),
              _buildQuickActions(),
              const SizedBox(height: 30),
              _buildStatsOverview(),
              const SizedBox(height: 30),
              _buildRecentActivity(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpicHeader() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.visibility_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Spacer(),
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
                      Icons.star_rounded,
                      color: Colors.yellow.shade300,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Level 5',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
            ).createShader(bounds),
            child: Text(
              'Good Morning, Alex! ✨',
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
          ).animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideX(begin: 0.3, end: 0, delay: 300.ms),
          const SizedBox(height: 8),
          Text(
            'Ready to make your city better today?',
            style: AppTextStyles.subtitle1.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ).animate()
              .fadeIn(delay: 500.ms, duration: 600.ms),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0, duration: 600.ms);
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 22,
          ),
        ).animate()
            .fadeIn(delay: 700.ms, duration: 600.ms),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Report Issue',
                subtitle: 'AI-powered detection',
                icon: Icons.camera_alt_rounded,
                gradient: AppColors.accentGradient,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportIssuePage(),
                    ),
                  );
                },
                delay: 900,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                title: 'Track Reports',
                subtitle: 'Real-time updates',
                icon: Icons.timeline_rounded,
                gradient: AppColors.primaryGradient,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyReportsPage(),
                    ),
                  );
                },
                delay: 1100,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Community',
                subtitle: 'Connect & share',
                icon: Icons.forum_rounded,
                gradient: AppColors.secondaryGradient,
                onTap: () {
                  setState(() => _selectedIndex = 2);
                },
                delay: 1300,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                title: 'Leaderboard',
                subtitle: 'See top performers',
                icon: Icons.emoji_events_rounded,
                gradient: LinearGradient(
                  colors: [AppColors.warning, AppColors.accentOrange],
                ),
                onTap: () {
                  setState(() => _selectedIndex = 1);
                },
                delay: 1500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    required int delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.subtitle2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: Duration(milliseconds: delay), duration: 600.ms);
  }

  Widget _buildStatsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community Impact',
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 22,
          ),
        ).animate()
            .fadeIn(delay: 1700.ms, duration: 600.ms),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatItem(
                    title: 'Issues Reported',
                    value: '1,247',
                    change: '+12%',
                    icon: Icons.report_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 20),
                  _buildStatItem(
                    title: 'Issues Resolved',
                    value: '892',
                    change: '+8%',
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildStatItem(
                    title: 'Active Users',
                    value: '2,456',
                    change: '+15%',
                    icon: Icons.people_outline,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 20),
                  _buildStatItem(
                    title: 'Response Time',
                    value: '2.4h',
                    change: '-20%',
                    icon: Icons.timer_outlined,
                    color: AppColors.warning,
                  ),
                ],
              ),
            ],
          ),
        ).animate()
            .fadeIn(delay: 1900.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, delay: 1900.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 22,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedIndex = 3);
              },
              child: Text(
                'View All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ).animate()
            .fadeIn(delay: 2100.ms, duration: 600.ms),
        const SizedBox(height: 16),
        _buildActivityItem(
          title: 'Pothole Reported',
          subtitle: 'MG Road, Bhopal • 2 hours ago',
          status: 'In Progress',
          statusColor: AppColors.warning,
          icon: Icons.construction_rounded,
          delay: 2300,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          title: 'Garbage Issue Resolved',
          subtitle: 'Sector 15, Indore • Yesterday',
          status: 'Completed',
          statusColor: AppColors.success,
          icon: Icons.delete_outline_rounded,
          delay: 2500,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          title: 'Street Light Repair',
          subtitle: 'Civil Lines • 3 days ago',
          status: 'Assigned',
          statusColor: AppColors.info,
          icon: Icons.lightbulb_outline_rounded,
          delay: 2700,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required IconData icon,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: AppTextStyles.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideX(begin: 0.3, end: 0, delay: Duration(milliseconds: delay), duration: 600.ms);
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This class is now handled by _buildDashboardHome
  }
}