import 'package:recoding_platform_project/features/login/data/models/user_model.dart';

class ProfileResponse {
  final User user;

  ProfileResponse({required this.user});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      user: User.fromJson(json['user']),
    );
  }
}
