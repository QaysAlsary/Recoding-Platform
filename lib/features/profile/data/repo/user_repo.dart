import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/login/data/models/login_response_model.dart';
import 'package:recoding_platform_project/features/login/data/models/user_model.dart';
import 'package:recoding_platform_project/features/profile/data/models/profile_resp.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';
import 'package:recoding_platform_project/src/core/token.dart';

class UserRepo {
  final ApiConsumer api;
  UserRepo({required this.api});
  Future<Either<String, ProfileResponse>> getUserProfile() async {
    try {
      final response = await api.get(
        EndPoint.baseUrl + EndPoint.getProfile,
      );

      return Right(ProfileResponse.fromJson(response));
    } on ServerException catch (e) {
      print(e.errModel.errorMessage);
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> updateUserProfile(
      {String? name,
      String? currentPassword,
      String? newPassword,
      String? newPasswordConfirm,
      XFile? profileImage,
      String? email}) async {
    try {
      int? userId = await IdManager.getId();

      final response = await api.post(
          EndPoint.baseUrl + EndPoint.urlUserProfile(userId),
          isFromData: true,
          data: {
            if (name != null) ApiKey.name: name,
            if (currentPassword != null) ApiKey.currentPass: currentPassword,
            if (newPassword != null) ApiKey.newPass: newPassword,
            if (newPasswordConfirm != null)
              ApiKey.newPassConfirm: newPasswordConfirm,
            if (email != null && email.isNotEmpty) ApiKey.email: email,
            if (profileImage != null)
              ApiKey.profilePic: await MultipartFile.fromFile(
                profileImage.path,
                filename: profileImage.name,
              ),
          });

      final messageResult = response;
      if (profileImage != null) {
        print("profileeeeeee");
      } else {
        print("profile is nullllllllllll");
      }
      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> updateProfileInfo(
      {String? name, required String currentPassword, String? email}) async {
    try {
      int? userId = await IdManager.getId();

      final response = await api.post(
          EndPoint.baseUrl + EndPoint.urlUserProfile(userId),
          isFromData: true,
          data: {
            if (name != null) ApiKey.name: name,
            ApiKey.currentPass: currentPassword,
            if (email != null) ApiKey.email: email,
          });

      final messageResult = response;
      print("12333 : $messageResult");
      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}
