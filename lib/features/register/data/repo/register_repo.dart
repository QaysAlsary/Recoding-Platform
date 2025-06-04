import 'package:dio/dio.dart';

import 'package:recoding_platform_project/features/register/data/models/register_response_model.dart';

class RegisterRepository {
  final Dio _dio;

  RegisterRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<RegisterResponse> register(String name, String email, String password,
      String password_confirmation, String layer) async {
    try {
      final response = await _dio.post(
        'http://192.168.239.150:8000/api/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password_confirmation,
          "layer": layer
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
}
