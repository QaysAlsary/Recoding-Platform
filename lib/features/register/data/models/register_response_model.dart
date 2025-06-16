class RegisterResponse {
  final String message;
  final UserData userData;

  RegisterResponse({
    required this.message,
    required this.userData,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? '',
      userData: UserData.fromJson(json['user_data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user_data': userData.toJson(),
    };
  }
}

class UserData {
  final String position;
  final String department;

  UserData({
    required this.position,
    required this.department,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      position: json['position'] ?? '',
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'department': department,
    };
  }
}
