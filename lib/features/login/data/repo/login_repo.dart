import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recoding_platform_project/features/login/data/models/login_response_model.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/token.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class LoginRepository {
  final Dio _dio;

  LoginRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        EndPoint.baseUrl + EndPoint.login,
        data: {'email': email, 'password': password},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print(response.data);
        final loginResponse = LoginResponse.fromJson(response.data);
        await TokenManager.saveToken(loginResponse.accessToken!);
        await IdManager.saveId(loginResponse.user!.id);
        await PassManager.savePassword(password);
        print("user Logined successfully");
        goRouter.go(Routes.home);
      }
      return LoginResponse.fromJson(response.data);
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
}
