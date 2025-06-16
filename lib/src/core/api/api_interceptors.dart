import 'package:dio/dio.dart';
import 'package:recoding_platform_project/src/core/token.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final noAuthPaths = ['/login', '/register'];
    final token = await TokenManager.getToken();

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
