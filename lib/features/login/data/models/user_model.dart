import 'package:image_picker/image_picker.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String position;
  final String department;
  final String layer;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int isVerified;
  final String? profile_image;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.department,
    required this.layer,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    this.profile_image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("User JSON => $json");
    return User(
      id: json['id'] ?? 0,
      name: json['name'],
      email: json['email'],
      position: json['position'] ?? "",
      department: json['department'] ?? "",
      layer: json['layer'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      isVerified: json['is_verified'] ?? 0,
      profile_image: json['profile_image'],
    );
  }
}
