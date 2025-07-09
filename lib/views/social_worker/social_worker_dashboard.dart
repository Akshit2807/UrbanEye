// views/social_worker/social_worker_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class SocialWorkerDashboard extends StatefulWidget {
  final String category; // 'government', 'ngo', 'private'

  const SocialWorkerDashboard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<SocialWorkerDashboard> createState() => _SocialWorkerDashboardState();
}

class _SocialWorkerDashboardState extends State<SocialWorkerDashboard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'id': '#REQ001',
      'title': 'Pothole Repair Needed',
      'location': 'MG Road, Bhopal',
      'priority': 'High',
      'timeAgo': '2 hours ago',
      'category': 'Road Maintenance',
      'description': 'Large pothole causing traffic disruption',
      'reportedBy': 'John Doe',
      'estimatedTime': '2-3 days',
      'budget': '₹15,000',
      'image': null,
    },
    {
      'id': '#REQ002',
      'title': 'Garbage Collection Issue',
      'location': 'Sector 15, Indore',
      'priority': 'Medium',
      'timeAgo': '5 hours ago',
      'category': 'Waste Management',
      'description': 'Regular pickup schedule disrupted',
      'reportedBy': 'Jane Smith',
      'estimatedTime': '1-2 days',
      'budget': '₹8,000',
      'image': null,
    },
    {
      'id': '#REQ003',
      'title': 'Street Light Repair',
      'location': 'Civil Lines, Bhopal',
      'priority': 'Low',
      'timeAgo': '1 day ago',
      'category': 'Infrastructure',
      'description': 'Multiple street lights not functioning',
      'reportedBy': 'Alex Johnson',
      'estimatedTime': '3-5 days',
      'budget': '₹12,000',
      'image': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  String get _categoryTitle {
    switch (widget.category) {
      case 'government':
        return 'Government Officer';
      case 'ngo':
        return 'NGO Worker';
      case 'private':
        return 'Private Contractor';
      default:
        return 'Social Worker';
    }
  }

  IconData get _categoryIcon {
    switch (widget.category) {
      case 'government':
        return Icons.account_balance_rounded;
      case 'ngo':
        return Icons.volunteer_activism_rounded;
      case 'private':
        return Icons.business_center_rounded;
      default:
        return Icons.work_rounded;
    }
  }

  Gradient get _categoryGradient {
    switch (widget.category) {
      case 'government':
        return AppColors.primaryGradient;
      case 'ngo':
        return AppColors.secondaryGradient;
      case 'private':
        return AppColors.accentGradient;
      default:
        return AppColors.primaryGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildStatsCards(),
                  const SizedBox(height: 30),
                  _buildPendingRequests(),
                  const SizedBox(height: 30),
                  _buildLeaderboard(),
                  const SizedBox(height: 30),
                  _buildQuickActions(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _categoryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * 3.14159,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _categoryIcon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showAnalytics(),
                    icon: const Icon(
                      Icons.analytics_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => _showNotifications(),
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '3',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome Back! 🚀',
            style: AppTextStyles.heading2.copyWith(color: Colors.white),
          ).animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideX(begin: 0.3, end: 0, delay: 300.ms),
          const SizedBox(height: 8),
          Text(
            _categoryTitle,
            style: AppTextStyles.subtitle1.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ).animate()
              .fadeIn(delay: 500.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            'Ready to make a difference today?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ).animate()
              .fadeIn(delay: 700.ms, duration: 600.ms),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0, duration: 600.ms);
  }

  Widget _buildStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Overview',
          style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
        ).animate()
            .fadeIn(delay: 900.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Completed',
                value: '24',
                subtitle: 'This month',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.success,
                delay: 1100,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Pending',
                value: '${_pendingRequests.length}',
                subtitle: 'Awaiting action',
                icon: Icons.pending_actions_rounded,
                color: AppColors.warning,
                delay: 1300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Rating',
                value: '4.8',
                subtitle: '⭐ Average',
                icon: Icons.star_rounded,
                color: AppColors.accent,
                delay: 1500,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Rank',
                value: '#3',
                subtitle: 'In your category',
                icon: Icons.emoji_events_rounded,
                color: AppColors.info,
                delay: 1700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.subtitle2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: Duration(milliseconds: delay), duration: 600.ms);
  }

  Widget _buildPendingRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Requests',
              style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
            ),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_pendingRequests.length} New',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ).animate()
            .fadeIn(delay: 1900.ms, duration: 600.ms),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pendingRequests.length,
          itemBuilder: (context, index) {
            return _buildRequestCard(_pendingRequests[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showRequestDetails(request),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(request['priority']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request['priority'],
                        style: AppTextStyles.caption.copyWith(
                          color: _getPriorityColor(request['priority']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      request['timeAgo'],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  request['title'],
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request['location'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  request['description'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request['category'],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request['budget'],
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _declineRequest(request['id']),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptRequest(request['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: 2100 + (index * 200)), duration: 600.ms)
        .slideX(begin: 0.3, end: 0, delay: Duration(milliseconds: 2100 + (index * 200)), duration: 600.ms);
  }

  Widget _buildLeaderboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard - ${_categoryTitle}s',
          style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
        ).animate()
            .fadeIn(delay: 2700.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildLeaderboardItem(
                rank: 1,
                name: 'Sarah Wilson',
                score: '98 points',
                isCurrentUser: false,
              ),
              const SizedBox(height: 12),
              _buildLeaderboardItem(
                rank: 2,
                name: 'Mike Johnson',
                score: '87 points',
                isCurrentUser: false,
              ),
              const SizedBox(height: 12),
              _buildLeaderboardItem(
                rank: 3,
                name: 'You',
                score: '76 points',
                isCurrentUser: true,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _showFullLeaderboard(),
                child: Text(
                  'View Full Leaderboard',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ).animate()
            .fadeIn(delay: 2900.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, delay: 2900.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildLeaderboardItem({
    required int rank,
    required String name,
    required String score,
    required bool isCurrentUser,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: AppTextStyles.subtitle2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.subtitle2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            score,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
        ).animate()
            .fadeIn(delay: 3100.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Analytics',
                subtitle: 'View reports',
                icon: Icons.analytics_rounded,
                color: AppColors.info,
                onTap: _showAnalytics,
                delay: 3300,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                title: 'Profile',
                subtitle: 'Manage account',
                icon: Icons.person_rounded,
                color: AppColors.secondary,
                onTap: _showProfile,
                delay: 3500,
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
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.subtitle2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
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
    ).animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: Duration(milliseconds: delay), duration: 600.ms);
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.warning; // Gold
      case 2:
        return AppColors.textTertiary; // Silver
      case 3:
        return AppColors.accent; // Bronze
      default:
        return AppColors.primary;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.info;
      default:
        return AppColors.textTertiary;
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showRequestSearch();
      },
      backgroundColor: AppColors.primary,
      elevation: 8,
      icon: const Icon(
        Icons.search_rounded,
        color: Colors.white,
      ),
      label: Text(
        'Find Requests',
        style: AppTextStyles.button.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }

  void _acceptRequest(String requestId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request $requestId accepted! 🎉'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement accept logic
  }

  void _declineRequest(String requestId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request $requestId declined'),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement decline logic
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Notifications',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationItem(
                'New request assigned',
                'Pothole repair on MG Road',
                '2 min ago',
                Icons.assignment_rounded,
              ),
              _buildNotificationItem(
                'Task completed',
                'Street light repair finished',
                '1 hour ago',
                Icons.check_circle_rounded,
              ),
              _buildNotificationItem(
                'Rating received',
                'You received 5-star rating',
                '3 hours ago',
                Icons.star_rounded,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile page coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFullLeaderboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Full leaderboard coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRequestSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request search coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            request['title'],
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(request['priority']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            request['priority'],
                            style: AppTextStyles.caption.copyWith(
                              color: _getPriorityColor(request['priority']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      request['id'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Details
                    _buildDetailRow('Category', request['category']),
                    _buildDetailRow('Location', request['location']),
                    _buildDetailRow('Reported By', request['reportedBy']),
                    _buildDetailRow('Estimated Time', request['estimatedTime']),
                    _buildDetailRow('Budget', request['budget']),
                    _buildDetailRow('Time Ago', request['timeAgo']),

                    const SizedBox(height: 24),

                    Text(
                      'Description',
                      style: AppTextStyles.subtitle2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      request['description'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _declineRequest(request['id']);
                            },
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Decline'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _acceptRequest(request['id']);
                            },
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Accept'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}