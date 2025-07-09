// services/community_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Create a new post
  Future<void> createPost({
    required String content,
    required String location,
    List<String> tags = const [],
    List<String> imageUrls = const [],
  }) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    // Get user data
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    if (!userDoc.exists) throw Exception('User data not found');

    final userData = userDoc.data()!;
    final postId = _firestore.collection('posts').doc().id;

    final post = PostModel(
      id: postId,
      authorId: currentUserId!,
      authorName: '${userData['firstName']} ${userData['lastName']}',
      authorRole: userData['role'],
      authorAvatar: _getAvatarForRole(userData['role']),
      content: content,
      imageUrls: imageUrls,
      tags: tags,
      location: location,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('posts').doc(postId).set(post.toJson());
  }

  // Get posts stream
  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<PostModel> posts = [];

      for (var doc in snapshot.docs) {
        final postData = doc.data();

        // Get comments for this post
        final commentsSnapshot = await _firestore
            .collection('posts')
            .doc(doc.id)
            .collection('comments')
            .orderBy('createdAt', descending: false)
            .get();

        final comments = commentsSnapshot.docs
            .map((commentDoc) => CommentModel.fromJson(commentDoc.data()))
            .toList();

        postData['comments'] = comments.map((c) => c.toJson()).toList();
        posts.add(PostModel.fromJson(postData));
      }

      return posts;
    });
  }

  // Like/Unlike a post
  Future<void> togglePostLike(String postId) async {
    if (currentUserId == null) return;

    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      if (!postDoc.exists) return;

      final data = postDoc.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);

      if (likedBy.contains(currentUserId)) {
        likedBy.remove(currentUserId);
      } else {
        likedBy.add(currentUserId!);
      }

      transaction.update(postRef, {'likedBy': likedBy});
    });
  }

  // Add a comment to a post
  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    // Get user data
    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    if (!userDoc.exists) throw Exception('User data not found');

    final userData = userDoc.data()!;
    final commentId = _firestore.collection('posts').doc(postId).collection('comments').doc().id;

    final comment = CommentModel(
      id: commentId,
      authorId: currentUserId!,
      authorName: '${userData['firstName']} ${userData['lastName']}',
      authorRole: userData['role'],
      authorAvatar: _getAvatarForRole(userData['role']),
      content: content,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set(comment.toJson());
  }

  // Like/Unlike a comment
  Future<void> toggleCommentLike(String postId, String commentId) async {
    if (currentUserId == null) return;

    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    await _firestore.runTransaction((transaction) async {
      final commentDoc = await transaction.get(commentRef);
      if (!commentDoc.exists) return;

      final data = commentDoc.data()!;
      final likedBy = List<String>.from(data['likedBy'] ?? []);

      if (likedBy.contains(currentUserId)) {
        likedBy.remove(currentUserId);
      } else {
        likedBy.add(currentUserId!);
      }

      transaction.update(commentRef, {'likedBy': likedBy});
    });
  }

  // Delete a post (only by author)
  Future<void> deletePost(String postId) async {
    if (currentUserId == null) return;

    final postDoc = await _firestore.collection('posts').doc(postId).get();
    if (!postDoc.exists) return;

    final postData = postDoc.data()!;
    if (postData['authorId'] != currentUserId) {
      throw Exception('Not authorized to delete this post');
    }

    // Delete all comments first
    final commentsSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();

    for (var commentDoc in commentsSnapshot.docs) {
      await commentDoc.reference.delete();
    }

    // Delete the post
    await _firestore.collection('posts').doc(postId).delete();
  }

  // Delete a comment (only by author)
  Future<void> deleteComment(String postId, String commentId) async {
    if (currentUserId == null) return;

    final commentDoc = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .get();

    if (!commentDoc.exists) return;

    final commentData = commentDoc.data()!;
    if (commentData['authorId'] != currentUserId) {
      throw Exception('Not authorized to delete this comment');
    }

    await commentDoc.reference.delete();
  }

  // Get leaderboard data
  Future<Map<String, List<Map<String, dynamic>>>> getLeaderboardData() async {
    final usersSnapshot = await _firestore.collection('users').get();
    final socialWorkersSnapshot = await _firestore.collection('social_workers').get();

    Map<String, List<Map<String, dynamic>>> leaderboards = {
      'Municipal Corporation': [],
      'NGO Workers': [],
      'Private Workers': [],
    };

    // Process social workers
    for (var doc in socialWorkersSnapshot.docs) {
      final data = doc.data();
      final category = data['category'] ?? 'private';

      String leaderboardKey;
      switch (category) {
        case 'government':
          leaderboardKey = 'Municipal Corporation';
          break;
        case 'ngo':
          leaderboardKey = 'NGO Workers';
          break;
        default:
          leaderboardKey = 'Private Workers';
      }

      leaderboards[leaderboardKey]!.add({
        'id': doc.id,
        'name': '${data['firstName']} ${data['lastName']}',
        'rating': data['rating'] ?? 0.0,
        'completedTasks': data['completedTasks'] ?? 0,
        'category': data['category'] ?? 'private',
        'areaOfService': data['areaOfService'] ?? '',
      });
    }

    // Sort each leaderboard by rating
    for (var key in leaderboards.keys) {
      leaderboards[key]!.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));

      // Add rank
      for (int i = 0; i < leaderboards[key]!.length; i++) {
        leaderboards[key]![i]['rank'] = i + 1;
      }
    }

    return leaderboards;
  }

  // Get user's current position in leaderboard
  Future<Map<String, dynamic>?> getUserLeaderboardPosition(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return null;

    final userData = userDoc.data()!;
    if (userData['role'] != 'social_worker') return null;

    final socialWorkerDoc = await _firestore.collection('social_workers').doc(userId).get();
    if (!socialWorkerDoc.exists) return null;

    final socialWorkerData = socialWorkerDoc.data()!;
    final leaderboards = await getLeaderboardData();

    final category = socialWorkerData['category'] ?? 'private';
    String leaderboardKey;
    switch (category) {
      case 'government':
        leaderboardKey = 'Municipal Corporation';
        break;
      case 'ngo':
        leaderboardKey = 'NGO Workers';
        break;
      default:
        leaderboardKey = 'Private Workers';
    }

    final leaderboard = leaderboards[leaderboardKey]!;
    final userPosition = leaderboard.firstWhere(
          (item) => item['id'] == userId,
      orElse: () => {},
    );

    if (userPosition.isEmpty) return null;

    return {
      'category': leaderboardKey,
      'rank': userPosition['rank'],
      'totalParticipants': leaderboard.length,
      'rating': userPosition['rating'],
      'completedTasks': userPosition['completedTasks'],
    };
  }

  String _getAvatarForRole(String role) {
    switch (role) {
      case 'social_worker':
        return '👨‍🔧';
      case 'ngo':
        return '🌱';
      default:
        return '👤';
    }
  }
}