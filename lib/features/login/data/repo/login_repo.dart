import 'package:dio/dio.dart';
import 'package:recoding_platform_project/features/login/data/models/login_response_model.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class LoginRepository {
  final Dio _dio;

  LoginRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://192.168.239.150:8000/api/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print("user Logined successfully");
        goRouter.go(Routes.register);
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
