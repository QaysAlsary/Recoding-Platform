import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/profile/data/models/profile_resp.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';

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
      final response = await api.post(
          EndPoint.baseUrl + EndPoint.urlUserProfile(),
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
      } else {}
      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> updateProfileInfo(
      {String? name, required String currentPassword, String? email}) async {
    try {
      int? userId = await SecureStorageService.getUserId();

      final response = await api.post(
          EndPoint.baseUrl + EndPoint.urlUserProfile(),
          isFromData: true,
          data: {
            if (name != null) ApiKey.name: name,
            ApiKey.currentPass: currentPassword,
            if (email != null) ApiKey.email: email,
          });

      final messageResult = response;

      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> changeEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    try {
      final response = await api.post(
        EndPoint.baseUrl + EndPoint.changeEmail,
        isFromData: true,
        data: {
          ApiKey.newEmail: newEmail,
          ApiKey.currentPass: currentPassword,
        },
      );

      final messageResult = response;

      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> verifyEmailCode({
    required String email,
    required String verificationCode,
  }) async {
    try {
      // Use the email passed as parameter

      final response = await api.post(
        EndPoint.baseUrl + EndPoint.verifyCode,
        isFromData: true,
        data: {
          ApiKey.email: email,
          ApiKey.verificationCode: verificationCode,
        },
      );

      final messageResult = response;

      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> changePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await api.post(
        EndPoint.baseUrl + EndPoint.changePassword,
        isFromData: true,
        data: {
          ApiKey.password: password,
          ApiKey.passwordConfirmation: passwordConfirmation,
        },
      );

      final messageResult = response;
      return Right(messageResult[ApiKey.message]);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> resendVerificationCode(String email) async {
    try {
      final response = await api.post(
        EndPoint.baseUrl + EndPoint.resendCode,
        isFromData: true,
        data: {
          ApiKey.email: email,
        },
      );
      final messageResult = response;
      return Right(messageResult[ApiKey.message] ?? 'Code resent successfully');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}
