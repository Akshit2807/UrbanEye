class UserModel {
  final String id;
  final String email;
  final String role; // 'civilian' or 'social_worker'
  final String firstName;
  final String lastName;
  final String phone;
  final String? address;
  final String? nagarNigam;
  final DateTime createdAt;
  final bool isProfileComplete;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.address,
    this.nagarNigam,
    required this.createdAt,
    this.isProfileComplete = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'nagarNigam': nagarNigam,
      'createdAt': createdAt.toIso8601String(),
      'isProfileComplete': isProfileComplete,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
      nagarNigam: json['nagarNigam'],
      createdAt: DateTime.parse(json['createdAt']),
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }
}
