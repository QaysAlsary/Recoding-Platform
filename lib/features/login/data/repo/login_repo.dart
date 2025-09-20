import 'package:dartz/dartz.dart';
import 'package:recoding_platform_project/features/login/data/models/login_response_model.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/dio_consumer.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';
import 'package:recoding_platform_project/src/di/session.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:dio/dio.dart';

class LoginRepository {
  final ApiConsumer _apiConsumer;

  LoginRepository({ApiConsumer? apiConsumer})
      : _apiConsumer = apiConsumer ?? DioConsumer(dio: Dio());

  Future<Either<String, LoginResponse>> login(
      String email, String password, bool isChecked) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.login,
        data: {'email': email, 'password': password},
        headers: {'Accept': 'application/json'},
      );

      if (response != null) {
        final loginResponse = LoginResponse.fromJson(response);

        // Save user data using the unified storage service
        await SecureStorageService.saveUserEmail(email);
        if (loginResponse.accessToken != null &&
            loginResponse.accessToken!.isNotEmpty) {
          await SecureStorageService.saveUserToken(loginResponse.accessToken!);
        }
        if (loginResponse.user != null) {
          await SecureStorageService.saveUserId(loginResponse.user!.id);
        }

        if (isChecked) {
          // Token is already saved above, just clear session token
          SessionManager().clearToken();
        } else {
          // Save token in memory only for the session
          SessionManager().setToken(loginResponse.accessToken!);
        }

        // goRouter.go(Routes.home);
        return Right(loginResponse);
      }
      return Left('Login failed');
    } catch (error) {
      return Left(error.toString());
    }
  }

  // API 1: Forgot Password
  Future<Either<String, String>> forgotPassword(String email) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.forgotPassword,
        data: {'email': email}, // Send as form data instead of raw text
        isFromData: true, // Use form data
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response != null) {
        // Handle different response types
        if (response is Map<String, dynamic>) {
          
          final message =
              response['message'] ?? 'Reset email sent successfully';
          return Right(message);
        } else if (response is String) {
          return Right(response);
        } else {
          return Right('Reset email sent successfully');
        }
      }
      return Left('Failed to send reset email');
    } catch (error) {
      return Left(error.toString());
    }
  }

  // API 2: Verify Code
  Future<Either<String, LoginResponse>> verifyCode(
      String email, String verificationCode) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.verifyCode,
        isFromData: true,
        data: {
          'email': email,
          'verification_code': verificationCode,
        },
        headers: {
          'Accept': 'application/json',
        },
      );
                        final loginResponse = LoginResponse.fromJson(response);

      if (response != null) {
        if (response is Map<String, dynamic>) {
          final message = response['message'] ?? 'Code verified successfully';

            // Save user data using the unified storage service
        await SecureStorageService.saveUserEmail(email);
        if (loginResponse.accessToken != null &&
            loginResponse.accessToken!.isNotEmpty) {
          await SecureStorageService.saveUserToken(loginResponse.accessToken!);
        }
        if (loginResponse.user != null) {
          await SecureStorageService.saveUserId(loginResponse.user!.id);
        }

          return Right(message);
        } else if (response is String) {
          return Right(loginResponse);
        } else {
          return Right(loginResponse);
        }
      }
      return Left('Failed to verify code');
    } catch (error) {
      return Left(error.toString());
    }
  }

  // // API 3: Resend Code
  // Future<Either<String, String>> resendCode(String email) async {
  //   try {
  //     final response = await _apiConsumer.post(
  //       EndPoint.resendCode,
  //       data: {'email': email}, // Send as form data
  //       isFromData: true, // Use form data
  //       headers: {
  //         'Accept': 'application/json',
  //       },
  //     );

  //     if (response != null) {
  //       if (response is Map<String, dynamic>) {
  //         final message = response['message'] ?? 'Code resent successfully';
  //         return Right(message);
  //       } else if (response is String) {
  //         return Right(response);
  //       } else {
  //         return Right('Code resent successfully');
  //       }
  //     }
  //     return Left('Failed to resend code');
  //   } catch (error) {
  //     return Left(error.toString());
  //   }
  // }

  // API 4: Reset Password
  Future<Either<String, String>> changePassword(
    String password,
    String passwordConfirmation,
  ) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.resetPassword,
        isFromData: true,
        data: {
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response != null) {
        if (response is Map<String, dynamic>) {
          final message = response['message'] ?? 'Password reset successfully';
          return Right(message);
        } else if (response is String) {
          return Right(response);
        } else {
          return Right('Password reset successfully');
        }
      }
      return Left('Failed to reset password');
    } catch (error) {
      return Left(error.toString());
    }
  }
}
