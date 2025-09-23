import 'package:dio/dio.dart';

import 'package:recoding_platform_project/src/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  ServerException({required this.errModel});
}

void handleDioExceptions(DioException e) {
  final data = e.response?.data ??
      {
        "message":
            "Failed to connect to the server. Please check your internet connection and try again."
      };
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
      throw ServerException(errModel: ErrorModel.fromJson(data));
    case DioExceptionType.badResponse:
      throw ServerException(errModel: ErrorModel.fromJson(data));
    default:
      throw ServerException(errModel: ErrorModel.fromJson(data));
  }
}
