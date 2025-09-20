import 'package:dio/dio.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final noAuthPaths = [
      '/login',
      '/register',
      '/forgot-password',
      '/verify-code',
      '/resend-code',
      '/reset-password'
    ];
    final token = await SecureStorageService.getUserToken();

    if (!noAuthPaths.contains(options.path)) {
      if (token != null && token.isNotEmpty) {
        options.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      } else {}
    } else {
      options.headers.addAll({
        'Accept': 'application/json',
      });
    }

    super.onRequest(options, handler);
  }
}
