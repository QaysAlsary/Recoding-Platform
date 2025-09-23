import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:recoding_platform_project/features/register/data/models/register_response_model.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/dio_consumer.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';

class RegisterRepository {
  final ApiConsumer _apiConsumer;

  RegisterRepository({ApiConsumer? apiConsumer, Dio? dio})
      : _apiConsumer = apiConsumer ?? DioConsumer(dio: dio ?? Dio());

  Future<Either<String, RegisterResponse>> register(String name, String email,
      String password, String password_confirmation) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password_confirmation,
        },
        headers: {'Accept': 'application/json'},
      );
      return Right(RegisterResponse.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> verifyEmailCode({
    required String email,
    required String verificationCode,
  }) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.verifyCode,
        isFromData: true,
        data: {
          'email': email,
          'verification_code': verificationCode,
        },
        headers: {'Accept': 'application/json'},
      );
      if (response is Map<String, dynamic> && response.containsKey('message')) {
        return Right(
            response['message'] as String? ?? 'Verification successful');
      }
      if (response is String) return Right(response);
      return Right('Verification successful');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> resendVerificationCode(String email) async {
    try {
      final response = await _apiConsumer.post(
        EndPoint.resendCode,
        data: {'email': email},
        headers: {'Accept': 'application/json'},
      );
      if (response is Map<String, dynamic> && response.containsKey('message')) {
        return Right(
            response['message'] as String? ?? 'Code resent successfully');
      }
      if (response is String) return Right(response);
      return Right('Code resent successfully');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}
