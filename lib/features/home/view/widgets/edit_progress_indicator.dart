import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';

class EditProgressIndicator extends StatelessWidget {
  const EditProgressIndicator({
    super.key,
    required this.state,
  });

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    // Check if it's EditMarkerState with upload progress
    if (state is EditMarkerState) {
      final editState = state as EditMarkerState;

      // Only show if uploading or has completed upload
      if (!editState.isUploading && editState.overallProgress == 0.0) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  editState.isUploading ? Icons.upload : Icons.check_circle,
                  color: editState.isUploading ? Colors.blue : Colors.green,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    editState.isUploading
                        ? 'Uploading files...'
                        : 'Upload Complete!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: editState.isUploading ? Colors.blue : Colors.green,
                    ),
                  ),
                ),
                Text(
                  '${(editState.overallProgress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            LinearProgressIndicator(
              value: editState.overallProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                editState.isUploading ? Colors.blue : Colors.green,
              ),
            ),
            if (editState.isUploading) ...[
              SizedBox(height: 8.h),
              Text(
                'Please wait while files are being uploaded...',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Fallback for UploadFiles state (if still used elsewhere)
    if (state is UploadFiles) {
      final upload = state as UploadFiles;

      if (!upload.isUploading && upload.overallProgress == 0.0) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  upload.isUploading ? Icons.upload : Icons.check_circle,
                  color: upload.isUploading ? Colors.blue : Colors.green,
                ),
                SizedBox(width: 8.w),
                Text(upload.isUploading ? 'Uploading...' : 'Upload Complete'),
                const Spacer(),
                Text('${(upload.overallProgress * 100).toInt()}%'),
              ],
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(value: upload.overallProgress),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
