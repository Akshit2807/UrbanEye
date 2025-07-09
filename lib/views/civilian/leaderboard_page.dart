// views/civilian/leaderboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Map<String, dynamic>>> _leaderboards = {
    'Municipal Corporation': [
      {
        'name': 'Bhopal Municipal Corporation',
        'score': 4.8,
        'resolved': 156,
        'avgTime': '2.3 days',
        'rating': 4.8,
        'city': 'Bhopal',
        'rank': 1,
      },
      {
        'name': 'Indore Municipal Corporation',
        'score': 4.6,
        'resolved': 142,
        'avgTime': '3.1 days',
        'rating': 4.6,
        'city': 'Indore',
        'rank': 2,
      },
      {
        'name': 'Jabalpur Municipal Corporation',
        'score': 4.4,
        'resolved': 98,
        'avgTime': '3.8 days',
        'rating': 4.4,
        'city': 'Jabalpur',
        'rank': 3,
      },
      {
        'name': 'Ujjain Municipal Corporation',
        'score': 4.2,
        'resolved': 87,
        'avgTime': '4.2 days',
        'rating': 4.2,
        'city': 'Ujjain',
        'rank': 4,
      },
    ],
    'NGO Workers': [
      {
        'name': 'Green Earth Foundation',
        'score': 4.9,
        'resolved': 89,
        'avgTime': '1.8 days',
        'rating': 4.9,
        'category': 'Environmental',
        'rank': 1,
      },
      {
        'name': 'Clean City Initiative',
        'score': 4.7,
        'resolved': 76,
        'avgTime': '2.1 days',
        'rating': 4.7,
        'category': 'Sanitation',
        'rank': 2,
      },
      {
        'name': 'Urban Care Society',
        'score': 4.5,
        'resolved': 64,
        'avgTime': '2.5 days',
        'rating': 4.5,
        'category': 'Infrastructure',
        'rank': 3,
      },
      {
        'name': 'Citizen Welfare Trust',
        'score': 4.3,
        'resolved': 52,
        'avgTime': '2.9 days',
        'rating': 4.3,
        'category': 'General',
        'rank': 4,
      },
    ],
    'Private Workers': [
      {
        'name': 'Rajesh Kumar (Road Specialist)',
        'score': 4.9,
        'resolved': 45,
        'avgTime': '1.2 days',
        'rating': 4.9,
        'specialty': 'Road Repair',
        'rank': 1,
      },
      {
        'name': 'Priya Sharma (Waste Expert)',
        'score': 4.8,
        'resolved': 38,
        'avgTime': '1.5 days',
        'rating': 4.8,
        'specialty': 'Waste Management',
        'rank': 2,
      },
      {
        'name': 'Amit Patel (Electrician)',
        'score': 4.6,
        'resolved': 32,
        'avgTime': '1.8 days',
        'rating': 4.6,
        'specialty': 'Electrical Work',
        'rank': 3,
      },
      {
        'name': 'Sunita Verma (Plumber)',
        'score': 4.4,
        'resolved': 28,
        'avgTime': '2.1 days',
        'rating': 4.4,
        'specialty': 'Water Issues',
        'rank': 4,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList('Municipal Corporation'),
                _buildLeaderboardList('NGO Workers'),
                _buildLeaderboardList('Private Workers'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Leaderboard',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Live',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Top performers making your city better',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0, duration: 600.ms);
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        tabs: const [
          Tab(text: 'Municipal'),
          Tab(text: 'NGO'),
          Tab(text: 'Private'),
        ],
      ),
    ).animate()
        .fadeIn(delay: 300.ms, duration: 600.ms);
  }

  Widget _buildLeaderboardList(String category) {
    final leaders = _leaderboards[category]!;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: leaders.length,
      itemBuilder: (context, index) {
        final leader = leaders[index];
        return _buildLeaderCard(leader, index);
      },
    );
  }

  Widget _buildLeaderCard(Map<String, dynamic> leader, int index) {
    final rank = leader['rank'];
    Color rankColor = AppColors.textTertiary;
    IconData rankIcon = Icons.workspace_premium_rounded;

    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
      rankIcon = Icons.emoji_events_rounded;
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
      rankIcon = Icons.emoji_events_outlined;
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
      rankIcon = Icons.emoji_events_outlined;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: rank <= 3 ? rankColor.withOpacity(0.3) : AppColors.textTertiary.withOpacity(0.1),
          width: rank <= 3 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: rank <= 3
                ? rankColor.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: rank <= 3 ? 20 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank and Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: rank <= 3
                      ? LinearGradient(
                    colors: [rankColor, rankColor.withOpacity(0.7)],
                  )
                      : LinearGradient(
                    colors: [AppColors.textTertiary, AppColors.textTertiary.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      rankIcon,
                      color: Colors.white,
                      size: 24,
                    ),
                    Positioned(
                      bottom: 8,
                      child: Text(
                        '#$rank',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leader['name'],
                      style: AppTextStyles.subtitle1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      leader['city'] ?? leader['category'] ?? leader['specialty'] ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      leader['rating'].toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              _buildStatChip(
                '${leader['resolved']} Resolved',
                Icons.check_circle_rounded,
                AppColors.success,
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                '${leader['avgTime']} Avg',
                Icons.timer_rounded,
                AppColors.info,
              ),
            ],
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: 500 + (index * 200)), duration: 600.ms)
        .slideX(begin: 0.3, end: 0, delay: Duration(milliseconds: 500 + (index * 200)), duration: 600.ms);
  }

  Widget _buildStatChip(String text, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}