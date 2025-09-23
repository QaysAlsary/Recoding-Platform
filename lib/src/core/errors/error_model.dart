import 'package:recoding_platform_project/src/core/api/end_ponits.dart';

class ErrorModel {
  final int? status;
  final String errorMessage;

  ErrorModel({this.status, required this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    String message = 'An unknown error occurred.'; // Default fallback message

    // Prioritize 'errors' field for validation messages
    if (jsonData.containsKey('errors') && jsonData['errors'] is Map) {
      final errorsMap = jsonData['errors'] as Map<String, dynamic>;
      if (errorsMap.isNotEmpty) {
        // Take the first error from the first field that has errors
        final firstKey = errorsMap.keys.first;
        final firstErrorList = errorsMap[firstKey];
        if (firstErrorList is List && firstErrorList.isNotEmpty) {
          message = firstErrorList[0]?.toString() ?? 'Validation error';
        }
      }
    } else if (jsonData.containsKey('message')) {
      // Fallback to a general 'message' field
      message =
          jsonData['message']?.toString() ?? 'Server message not available';
    } else if (jsonData.containsKey(ApiKey.errorMessage)) {
      // Fallback to a specific API error message key
      message = jsonData[ApiKey.errorMessage]?.toString() ??
          'API error message not available';
    }

    // Safely extract status code
    int? statusCode;
    if (jsonData.containsKey(ApiKey.status) && jsonData[ApiKey.status] is int) {
      statusCode = jsonData[ApiKey.status] as int;
    }

    return ErrorModel(
      status: statusCode,
      errorMessage: message,
    );
  }
}
