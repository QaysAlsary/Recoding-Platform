import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:recoding_platform_project/features/register/data/models/register_response_model.dart';

import '../../../../src/core/api/end_ponits.dart';

class RegisterRepository {
  final Dio _dio;

  RegisterRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<RegisterResponse> register(String name, String email, String password,
      String password_confirmation) async {
    try {
      final response = await _dio.post(
        EndPoint.baseUrl + EndPoint.register,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password_confirmation,
          // "layer": layer
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic> && data.containsKey('message')) {
        throw Exception(data['message']);
      }

      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<Either<String, String>> verifyEmailCode({
    required String email,
    required String verificationCode,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'verification_code': verificationCode,
      });
      final response = await _dio.post(
        EndPoint.baseUrl + EndPoint.verifyCode,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return Right(response.data['message'] ?? 'Verification successful');
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return Left(data['message']);
      }
      return Left(e.message ?? 'Network error occurred');
    } catch (e) {
      return Left('An unexpected error occurred.');
    }
  }

  Future<Either<String, String>> resendVerificationCode(String email) async {
    try {
      final response = await _dio.post(
        EndPoint.baseUrl + EndPoint.resendCode,
        data: {'email': email},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? 'Code resent successfully';
        return Right(message);
      } else if (response.data is String) {
        return Right(response.data);
      } else {
        return Right('Code resent successfully');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return Left(data['message']);
      }
      return Left(e.message ?? 'Network error occurred');
    } catch (e) {
      return Left('An unexpected error occurred.');
    }
  }
}
