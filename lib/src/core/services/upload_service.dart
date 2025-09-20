import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UploadService {
  static Future<http.StreamedResponse> uploadWithProgress({
    required String url,
    required Map<String, String> fields,
    required List<XFile> files,
    required String fileFieldName,
    required Function(double) onProgress,
    Map<String, String>? headers,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // Add fields
    request.fields.addAll(fields);

    // Add files
    for (var file in files) {
      var multipartFile = await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
        filename: file.name,
      );
      request.files.add(multipartFile);
    }

    // Calculate total size
    int totalBytes = 0;
    for (var file in request.files) {
      totalBytes += await File(file.filename!).length();
    }

    // Send request and track progress
    var streamedResponse = await request.send();

    // Track download progress (for response)
    int downloadedBytes = 0;
    streamedResponse.stream.listen(
      (chunk) {
        downloadedBytes += chunk.length;
        double progress = downloadedBytes / totalBytes;
        onProgress(progress.clamp(0.0, 1.0));
      },
    );

    return streamedResponse;
  }
}
