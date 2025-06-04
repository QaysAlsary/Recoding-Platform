import 'user_model.dart';

class LoginResponse {
  final String message;
  final String? accessToken;
  final User? user;
  final Map<String, dynamic>? errors;

  LoginResponse({
    required this.message,
    this.accessToken,
    this.user,
    this.errors,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      accessToken: json['access_token'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      errors: json['errors'],
    );
  }
}
