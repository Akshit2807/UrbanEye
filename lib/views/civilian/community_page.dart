// views/civilian/community_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _postController = TextEditingController();

  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'author': 'Priya Sharma',
      'role': 'Civilian',
      'avatar': '👩‍💼',
      'time': '2 hours ago',
      'content': 'Amazing work by the Municipal Corporation team! They fixed the pothole on MG Road within 24 hours of my report. This is what efficient governance looks like! 🙌',
      'likes': 24,
      'comments': 8,
      'isLiked': false,
      'tags': ['Success Story', 'Municipal'],
      'location': 'Bhopal',
    },
    {
      'id': '2',
      'author': 'Rajesh Kumar',
      'role': 'Social Worker',
      'avatar': '👨‍🔧',
      'time': '4 hours ago',
      'content': 'Just completed another street light repair in Sector 15. Thanks to all the civilians who report these issues promptly. Together we\'re making our city safer! 💡✨',
      'likes': 31,
      'comments': 12,
      'isLiked': true,
      'tags': ['Infrastructure', 'Team Work'],
      'location': 'Indore',
    },
    {
      'id': '3',
      'author': 'Green Earth Foundation',
      'role': 'NGO',
      'avatar': '🌱',
      'time': '6 hours ago',
      'content': 'Our weekend cleanup drive was a huge success! 150+ volunteers participated and we collected over 2 tons of waste from the riverbank. Special thanks to everyone who joined us! 🌍♻️',
      'likes': 67,
      'comments': 23,
      'isLiked': false,
      'tags': ['Environment', 'Volunteer'],
      'location': 'Bhopal',
    },
    {
      'id': '4',
      'author': 'Amit Patel',
      'role': 'Civilian',
      'avatar': '👨‍💻',
      'time': '8 hours ago',
      'content': 'The new AI-powered reporting feature is incredible! It correctly identified the type of issue and even suggested the urgency level. Technology making civic participation easier! 🤖',
      'likes': 19,
      'comments': 5,
      'isLiked': true,
      'tags': ['Technology', 'Innovation'],
      'location': 'Jabalpur',
    },
    {
      'id': '5',
      'author': 'Urban Care Society',
      'role': 'NGO',
      'avatar': '🏙️',
      'time': '12 hours ago',
      'content': 'Looking for volunteers for our upcoming road safety awareness campaign. We need passionate individuals who want to make a difference in their community. DM us if interested! 🚦',
      'likes': 43,
      'comments': 18,
      'isLiked': false,
      'tags': ['Volunteer', 'Safety'],
      'location': 'Ujjain',
    },
  ];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildCreatePost(),
          Expanded(
            child: _buildPostsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
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
                  Icons.forum_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Community',
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '1.2k Online',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Share experiences, connect with others, and celebrate community wins',
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

  Widget _buildCreatePost() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '👤',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _postController,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts or experiences...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPostOption(Icons.photo_camera_rounded, 'Photo'),
              const SizedBox(width: 16),
              _buildPostOption(Icons.location_on_rounded, 'Location'),
              const SizedBox(width: 16),
              _buildPostOption(Icons.local_offer_rounded, 'Tag'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Post',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: 300.ms);
  }

  Widget _buildPostOption(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.textTertiary,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post, index);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
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
          // Header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: _getRoleGradient(post['role']),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    post['avatar'],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post['author'],
                          style: AppTextStyles.subtitle2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getRoleColor(post['role']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            post['role'],
                            style: AppTextStyles.caption.copyWith(
                              color: _getRoleColor(post['role']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post['time'],
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post['location'],
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          Text(
            post['content'],
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (post['tags'] as List<String>).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$tag',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              _buildActionButton(
                icon: post['isLiked'] ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                label: '${post['likes']}',
                color: post['isLiked'] ? AppColors.accent : AppColors.textTertiary,
                onTap: () {
                  setState(() {
                    post['isLiked'] = !post['isLiked'];
                    post['likes'] += post['isLiked'] ? 1 : -1;
                  });
                },
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: '${post['comments']}',
                color: AppColors.textTertiary,
                onTap: () {},
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.share_rounded,
                label: 'Share',
                color: AppColors.textTertiary,
                onTap: () {},
              ),
              const Spacer(),
              _buildActionButton(
                icon: Icons.bookmark_border_rounded,
                label: '',
                color: AppColors.textTertiary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: 500 + (index * 200)), duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: Duration(milliseconds: 500 + (index * 200)), duration: 600.ms);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Gradient _getRoleGradient(String role) {
    switch (role) {
      case 'Social Worker':
        return AppColors.secondaryGradient;
      case 'NGO':
        return AppColors.accentGradient;
      default:
        return AppColors.primaryGradient;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Social Worker':
        return AppColors.secondary;
      case 'NGO':
        return AppColors.accent;
      default:
        return AppColors.primary;
    }
  }
}