// models/post_model.dart
class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole; // 'civilian', 'social_worker', 'ngo'
  final String authorAvatar;
  final String content;
  final List<String> imageUrls;
  final List<String> tags;
  final String location;
  final DateTime createdAt;
  final List<String> likedBy;
  final List<CommentModel> comments;
  final bool isEdited;

  PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.content,
    this.imageUrls = const [],
    this.tags = const [],
    required this.location,
    required this.createdAt,
    this.likedBy = const [],
    this.comments = const [],
    this.isEdited = false,
  });

  int get likesCount => likedBy.length;
  int get commentsCount => comments.length;

  bool isLikedBy(String userId) => likedBy.contains(userId);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatar': authorAvatar,
      'content': content,
      'imageUrls': imageUrls,
      'tags': tags,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'likedBy': likedBy,
      'comments': comments.map((c) => c.toJson()).toList(),
      'isEdited': isEdited,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorRole: json['authorRole'],
      authorAvatar: json['authorAvatar'],
      content: json['content'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      likedBy: List<String>.from(json['likedBy'] ?? []),
      comments: (json['comments'] as List?)
          ?.map((c) => CommentModel.fromJson(c))
          .toList() ?? [],
      isEdited: json['isEdited'] ?? false,
    );
  }

  PostModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? authorAvatar,
    String? content,
    List<String>? imageUrls,
    List<String>? tags,
    String? location,
    DateTime? createdAt,
    List<String>? likedBy,
    List<CommentModel>? comments,
    bool? isEdited,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

class CommentModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final List<String> likedBy;

  CommentModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
    this.likedBy = const [],
  });

  int get likesCount => likedBy.length;
  bool isLikedBy(String userId) => likedBy.contains(userId);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likedBy': likedBy,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorRole: json['authorRole'],
      authorAvatar: json['authorAvatar'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  CommentModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorRole,
    String? authorAvatar,
    String? content,
    DateTime? createdAt,
    List<String>? likedBy,
  }) {
    return CommentModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}