// lib/features/home/view/widgets/edit_build_gallery.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import '../../bloc/home_bloc.dart';
import '../../models/location_model.dart';

class EditBuildGallery extends StatelessWidget {
  final EditMarkerState state;
  final Location location;

  // Callbacks
  final Function(String imageUrl)? onRemoveOldImage;
  final Function(File file)? onRemoveNewImage;
  final Function(Map<String, dynamic> fileData)? onRemoveOldFile;
  final Function(File file)? onRemoveNewFile;

  const EditBuildGallery({
    super.key,
    required this.state,
    required this.location,
    this.onRemoveOldImage,
    this.onRemoveNewImage,
    this.onRemoveOldFile,
    this.onRemoveNewFile,
  });

  @override
  Widget build(BuildContext context) {
    // Use location from state if available, otherwise fall back to widget.location
    final currentLocation = state.location ?? location;

    // Old images from location.images
    final List<String> oldImages = currentLocation.images
        .map((img) {
          if (img is Map<String, dynamic> && img['image_path'] != null) {
            return '${EndPoint.imageBaseUrl}${img['image_path']}';
          } else if (img is String) {
            return '${EndPoint.imageBaseUrl}$img';
          }
          return null;
        })
        .whereType<String>() // يشيل الـnulls
        .toList();
    final newImages = (state is EditMarkerState) ? state.newImages : [];
    final oldFiles =
        currentLocation.references.whereType<Map<String, dynamic>>().toList();
    final newFiles = (state is EditMarkerState) ? state.newPdfs : [];

    Widget buildImageItem(
        {required Widget imageWidget, required VoidCallback onRemove}) {
      return Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r), child: imageWidget),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Colors.red),
              ),
            ),
          ),
        ],
      );
    }

    Widget buildFileItem({
      required String fileName,
      required VoidCallback onRemove,
    }) {
      return Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r)),
            child: Center(
              child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Colors.red),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                fileName,
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Old Images
        if (oldImages.isNotEmpty) ...[
          Text('Old Images:'),
          SizedBox(
            height: 120.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: oldImages.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final imgUrl = oldImages[index];
                return buildImageItem(
                  imageWidget: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[300]),
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                  ),
                  onRemove: () {
                    if (onRemoveOldImage != null) onRemoveOldImage!(imgUrl);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],

        // New Images
        if (newImages.isNotEmpty) ...[
          Text('New Images:'),
          SizedBox(
            height: 120.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: newImages.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final file = newImages[index];
                return buildImageItem(
                  imageWidget: Image.file(file, fit: BoxFit.cover),
                  onRemove: () {
                    if (onRemoveNewImage != null) onRemoveNewImage!(file);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],

        // Old Files
        if (oldFiles.isNotEmpty) ...[
          Text('Old Files:'),
          SizedBox(
            height: 120.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: oldFiles.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final file = oldFiles[index];
                final fileName = file['file_name'] ?? 'File';
                return buildFileItem(
                  fileName: fileName,
                  onRemove: () {
                    if (onRemoveOldFile != null) onRemoveOldFile!(file);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],

        // New Files
        if (newFiles.isNotEmpty) ...[
          Text('New Files:'),
          SizedBox(
            height: 120.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: newFiles.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final file = newFiles[index];
                final fileName = file.path.split('/').last;
                return buildFileItem(
                  fileName: fileName,
                  onRemove: () {
                    if (onRemoveNewFile != null) onRemoveNewFile!(file);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
