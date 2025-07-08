import 'package:urbaneye/models/user_model.dart';

class SocialWorkerModel extends UserModel {
  final String category; // 'government', 'ngo', 'private'
  final String areaOfService;
  final List<String> skills;
  final double rating;
  final int completedTasks;

  SocialWorkerModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    required this.category,
    required this.areaOfService,
    required this.skills,
    this.rating = 0.0,
    this.completedTasks = 0,
    DateTime? createdAt,
    bool isProfileComplete = false,
  }) : super(
    id: id,
    email: email,
    role: 'social_worker',
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    address: address,
    createdAt: createdAt ?? DateTime.now(),
    isProfileComplete: isProfileComplete,
  );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'category': category,
      'areaOfService': areaOfService,
      'skills': skills,
      'rating': rating,
      'completedTasks': completedTasks,
    });
    return json;
  }

  factory SocialWorkerModel.fromJson(Map<String, dynamic> json) {
    return SocialWorkerModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
      category: json['category'],
      areaOfService: json['areaOfService'],
      skills: List<String>.from(json['skills'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      completedTasks: json['completedTasks'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }
}
