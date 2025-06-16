import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/home/models/location_model.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';

class HomeRepo {
  final ApiConsumer api;

  HomeRepo({required this.api});

  Future<Either<String, LocationResponse>> getSelectedMarker(
      {required int id}) async {
    try {
      final response = await api.get(
        EndPoint.baseUrl + EndPoint.getSelectedLocatin(id),
      );
      return Right(LocationResponse.fromJson(response));
    } on ServerException catch (e) {
      final errorMessage =
          e.errModel.errorMessage ?? 'An unknown server error occurred.';
      print(errorMessage);
      return Left(errorMessage);
    }
  }

  Future<Either<String, String>> deleteMarker({required int id}) async {
    try {
      final response = await api.delete(
        EndPoint.baseUrl + EndPoint.getSelectedLocatin(id),
      );
      return Right(response['message'] ?? 'Marker deleted successfully');
    } on ServerException catch (e) {
      print(e.errModel.errorMessage);
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> editMarker({
    required int locationId,
    required String name,
    required String description,
    required String? aspect,
    required String? subAspect,
    required String? category,
    List<XFile>? newImages,
  }) async {
    try {
      final response = await api.put(
        EndPoint.baseUrl + EndPoint.getSelectedLocatin(locationId),
        data: {
          'name': name,
          'description': description,
          'aspect': aspect,
          'sub_aspect': subAspect,
          'category': category,
          if (newImages != null) 'images': newImages,
        },
        isFromData: true,
      );
      return Right(response['message'] ?? 'Marker updated successfully');
    } on ServerException catch (e) {
      print(e.errModel.errorMessage);
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> createMarker({
    required String name,
    String? aspectId,
    String? subAspectId,
    String? categoryId,
    required double latitude,
    required double longitude,
    String? description,
    List<XFile>? images,
  }) async {
    try {
      final data = {
        'name': name,
        'aspect_id': aspectId,
        'sub_aspect_id': subAspectId,
        'category_id': categoryId,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
      };

      // Add images if provided
      if (images != null && images.isNotEmpty) {
        // Dio's FormData automatically handles XFile/MultipartFile for 'isFromData: true'
        // if the value is an XFile or a list of XFile
        data['images[]'] = images;
      }

      final response = await api.post(
        EndPoint.baseUrl + EndPoint.locations,
        data: data,
        isFromData: true,
      );
      return Right(response['message'] ?? 'Marker created successfully');
    } on ServerException catch (e) {
      print(e.errModel.errorMessage);
      return Left(e.errModel.errorMessage);
    } catch (e) {
      print('Error creating marker: $e');
      return Left('Failed to create marker: ${e.toString()}');
    }
  }
}
