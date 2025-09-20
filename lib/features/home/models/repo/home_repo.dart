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
      final errorMessage = e.errModel.errorMessage;

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

    // List<XFile>? newImages,
    // List<XFile>? newPdfs,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'description': description,
        'aspect_id': aspect,
        'sub_aspect_id': subAspect,
        'category_id': category,
      };

      final response = await api.put(
        EndPoint.baseUrl + EndPoint.getSelectedLocatin(locationId),
        data: data,
      );

      return Right(response['message'] ?? 'Marker updated successfully');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left('Failed to update marker: ${e.toString()}');
    }
  }

  Future<Either<String, String>> uploadImagesFilestoExistingMarker({
    required int locationId,
    List<XFile>? newImages,
    List<XFile>? newPdfs,
    Function(double)? onProgress,
  }) async {
    try {
      // Check if there are actually files to upload
      final hasImages = newImages != null && newImages.isNotEmpty;
      final hasPdfs = newPdfs != null && newPdfs.isNotEmpty;

      if (!hasImages && !hasPdfs) {
        return const Right('No files to upload');
      }

      final Map<String, dynamic> data = {};

      // Add images if provided
      if (hasImages) {
        final List<MultipartFile> imageFiles = await Future.wait(
          newImages!.map((image) async {
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

      // Add PDFs if provided
      if (hasPdfs) {
        final List<MultipartFile> pdfFiles = await Future.wait(
          newPdfs!.map((pdf) async {
            final bytes = await pdf.readAsBytes();
            return MultipartFile.fromBytes(
              bytes,
              filename: pdf.name,
              contentType:
                  MediaType.parse(pdf.mimeType ?? 'application/octet-stream'),
            );
          }),
        );
        data['references[]'] = pdfFiles;
      }

      // Make the upload request with progress tracking
      final response = await api.post(
        isFromData: true,
        EndPoint.baseUrl +
            EndPoint.getSelectedLocatin(locationId) +
            '/' +
            EndPoint.uploadFiles,
        data: data,
        onProgress: (progress) {
          if (onProgress != null) {
            onProgress(progress);
          }
        },
      );

      final uploadedImagesCount = hasImages ? newImages!.length : 0;
      final uploadedPdfsCount = hasPdfs ? newPdfs!.length : 0;
      final defaultMessage =
          'Successfully uploaded $uploadedImagesCount image(s) and $uploadedPdfsCount file(s)';

      return Right(response['message'] ?? defaultMessage);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
      return Left('Failed to upload files: ${e.toString()}');
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
    List<XFile>? pdfs,
    Function(double)? onProgress,
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

      // Add pdfs if provided
      if (pdfs != null && pdfs.isNotEmpty) {
        final List<MultipartFile> pdfFiles = await Future.wait(
          pdfs.map((pdf) async {
            final bytes = await pdf.readAsBytes();
            return MultipartFile.fromBytes(bytes,
                filename: pdf.name,
                contentType: MediaType.parse(
                    pdf.mimeType ?? 'application/octet-stream'));
          }),
        );
        data['references[]'] = pdfFiles;
      }
      final response = await api.post(
        EndPoint.baseUrl + EndPoint.locations,
        data: data,
        isFromData: true,
        onProgress: onProgress,
      );
      return Right(response['message'] ?? 'Marker created successfully');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    } catch (e) {
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
      final errorMessage = e.errModel.errorMessage;

      return Left(errorMessage);
    } catch (e) {
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
      final errorMessage = e.errModel.errorMessage;

      return Left(errorMessage);
    } catch (e) {
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
      final errorMessage = e.errModel.errorMessage;

      return Left(errorMessage);
    } catch (e) {
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
      final errorMessage = e.errModel.errorMessage;

      return Left(errorMessage);
    } catch (e) {
      return Left('Failed to fetch categories: ${e.toString()}');
    }
  }

  Future<Either<String, String>> deleteReferenceFile(
      {required int locationId, required int fileId}) async {
    try {
      final response = await api.delete(
        EndPoint.baseUrl + 'locations/$locationId/delete-reference/$fileId',
      );
      return Right(
          response['message'] ?? 'Reference file deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> deleteImage(
      {required int locationId, required int imageId}) async {
    try {
      final response = await api.delete(
        EndPoint.baseUrl + 'locations/$locationId/delete-image/$imageId',
      );
      return Right(response['message'] ?? 'Image deleted successfully');
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}
