import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkErrorHandler {
  static Exception handleError(dynamic error, BuildContext context) {
    String errorMessage = 'An unexpected error occurred. Please try again.';

    if (error is DioException) {
      errorMessage = _handleDioException(error);
    } else if (error is ApiException) {
      errorMessage = error.message;
    } else if (error is NetworkException) {
      errorMessage = error.message;
    } else if (error is Exception) {
      errorMessage = error.toString();
    } else if (error is Error) {
      errorMessage = error.toString();
    }

    _showSnackBar(context, errorMessage);
    return ApiException(errorMessage);
  }

  static String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.cancel:
        return 'Request was canceled.';
      case DioExceptionType.badResponse:
        return _extractMessageFromResponse(e.response) ??
            'Received an invalid response from server.';
      default:
        return 'Network error. Please check your internet connection.';
    }
  }

  // message from server response
  static String? _extractMessageFromResponse(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response?.data as Map<String, dynamic>;
      try {
        if (data['message'] != null) return data['message'];
        if (data['error'] != null) return data['error'];
        if (data['detail'] != null) return data['detail'];
        if (data['errors'] != null && data['errors']['email'] != null) {
          final emailErrors = data['errors']['email'];
          if (emailErrors is List && emailErrors.isNotEmpty) {
            return emailErrors[0].toString();
          }
          if (emailErrors is String) {
            return emailErrors;
          }
        }
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static void _showSnackBar(BuildContext context, String errorMessage) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.blueGrey,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      // Fallback: if no ScaffoldMessenger found, print to console
    }
  }

  static String getErrorMessage(Exception exception) {
    if (exception is NetworkException || exception is ApiException) {
      return exception.toString();
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
