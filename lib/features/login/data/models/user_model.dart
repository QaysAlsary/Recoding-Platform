class User {
  final int id;
  final String name;
  final String email;
  final String position;
  final String department;
  final String layer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isVerified;

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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
      department: json['department'],
      layer: json['layer'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isVerified: json['is_verified'],
    );
  }
}
