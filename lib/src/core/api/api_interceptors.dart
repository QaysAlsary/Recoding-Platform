import 'package:dio/dio.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';
import 'package:recoding_platform_project/src/di/session.dart';

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
    final secureToken = await SecureStorageService.getUserToken();
    final sessionToken = SessionManager().token;

    if (!noAuthPaths.contains(options.path)) {
      final token = (secureToken != null && secureToken.isNotEmpty)
          ? secureToken
          : sessionToken;
      if (token != null && token.isNotEmpty) {
        options.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      } else {
        options.headers.addAll({
          'Accept': 'application/json',
        });
      }
    } else {
      options.headers.addAll({
        'Accept': 'application/json',
      });
    }

    super.onRequest(options, handler);
  }
}
