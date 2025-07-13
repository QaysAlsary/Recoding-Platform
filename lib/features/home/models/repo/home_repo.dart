import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/home/models/aspect_model.dart';
import 'package:recoding_platform_project/features/home/models/location_model.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/src/core/api/api_consumer.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../sub_aspect_model.dart';
import '../category_model.dart';

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
    required int? aspect,
    required int? subAspect,
    required int? category,
    List<XFile>? newImages,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'description': description,
        'aspect_id': aspect,
        'sub_aspect_id': subAspect,
        'category_id': category,
      };
      print("ggllgg :$data");
      print('=== EDIT MARKER DEBUG ===');
      print('Sending to server:');
      print(
          'URL: ${EndPoint.baseUrl + EndPoint.getSelectedLocatin(locationId)}');
      print('Data: $data');
      print('Method: POST');

      // Add images if provided
      if (newImages != null && newImages.isNotEmpty) {
        final List<MultipartFile> imageFiles = await Future.wait(
          newImages.map((image) async {
            final bytes = await image.readAsBytes();
            return MultipartFile.fromBytes(
              bytes,
              filename: image.name,
              contentType: MediaType.parse(image.mimeType ?? 'image/jpeg'),
            );
          }),
        );
        data['images[]'] = imageFiles;
      }

      final response = await api.put(
        EndPoint.baseUrl + EndPoint.getSelectedLocatin(locationId),
        data: data,
      );
      print('Server response: $response');
      print('=== END DEBUG ===');
      return Right(response['message'] ?? 'Marker updated successfully');
    } on ServerException catch (e) {
      print(e.errModel.errorMessage);
      return Left(e.errModel.errorMessage);
    } catch (e) {
      print('Error updating marker: $e');
      return Left('Failed to update marker: ${e.toString()}');
    }
  }

  Future<Either<String, String>> createMarker({
    required String name,
    int? aspectId,
    int? subAspectId,
    int? categoryId,
    required double latitude,
    required double longitude,
    String? description,
    List<XFile>? images,
  }) async {
    try {
      final Map<String, dynamic> data = {
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
        // Convert XFile to MultipartFile for each image
        final List<MultipartFile> imageFiles = await Future.wait(
          images.map((image) async {
            final bytes = await image.readAsBytes();
            return MultipartFile.fromBytes(
              bytes,
              filename: image.name,
              contentType: MediaType.parse(image.mimeType ?? 'image/jpeg'),
            );
          }),
        );
        data['images[]'] = imageFiles;
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

  Future<Either<String, List<MarkerData>>> getAllMarkers() async {
    try {
      final response = await api.get(
        EndPoint.baseUrl + EndPoint.locations,
      );

      // Assuming the response is a list of markers
      final List<dynamic> markersJson =
          response is List ? response : response['data'];
      final List<MarkerData> markers =
          markersJson.map((json) => MarkerData.fromJson(json)).toList();

      return Right(markers);
    } on ServerException catch (e) {
      final errorMessage =
          e.errModel.errorMessage ?? 'An unknown server error occurred.';
      print('Error fetching markers: $errorMessage');
      return Left(errorMessage);
    } catch (e) {
      print('Error fetching markers: $e');
      return Left('Failed to fetch markers: ${e.toString()}');
    }
  }

  Future<Either<String, List<AspectModel2>>> getAllAspects() async {
    try {
      final response = await api.get(
        EndPoint.baseUrl + EndPoint.getAspect,
      );
      final List<dynamic> data = response;
      final aspects = data.map((e) => AspectModel2.fromJson(e)).toList();
      return Right(aspects);
    } on ServerException catch (e) {
      final errorMessage =
          e.errModel.errorMessage ?? 'An unknown server error occurred.';
      print(errorMessage);
      return Left(errorMessage);
    } catch (e) {
      print('Error fetching aspects: $e');
      return Left('Failed to fetch aspects: ${e.toString()}');
    }
  }

  Future<Either<String, List<SubAspectModel>>> getSubAspectsForAspect(
      int aspectId) async {
    try {
      final response = await api.get(
        EndPoint.baseUrl + 'sub-aspects/$aspectId',
        // EndPoint.baseUrl + EndPoint.getSubAspect(aspectId),
      );
      final List<dynamic> data = response;
      final subAspects = data.map((e) => SubAspectModel.fromJson(e)).toList();
      return Right(subAspects);
    } on ServerException catch (e) {
      final errorMessage =
          e.errModel.errorMessage ?? 'An unknown server error occurred.';
      print(errorMessage);
      return Left(errorMessage);
    } catch (e) {
      print('Error fetching sub-aspects: $e');
      return Left('Failed to fetch sub-aspects: ${e.toString()}');
    }
  }

  Future<Either<String, List<CategoryModel>>> getCategoriesForSubAspect(
      int subAspectId) async {
    try {
      final response = await api.get(
        EndPoint.baseUrl + 'categories/$subAspectId',
      );
      final List<dynamic> data = response;
      final categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      return Right(categories);
    } on ServerException catch (e) {
      final errorMessage =
          e.errModel.errorMessage ?? 'An unknown server error occurred.';
      print(errorMessage);
      return Left(errorMessage);
    } catch (e) {
      print('Error fetching categories: $e');
      return Left('Failed to fetch categories: ${e.toString()}');
    }
  }
}
