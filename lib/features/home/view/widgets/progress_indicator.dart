import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';

class UploadProgressIndicator extends StatelessWidget {
  const UploadProgressIndicator({
    super.key,
    required this.state,
  });

  final CreateMarkerFormState state;

  @override
  Widget build(BuildContext context) {
    if (!state.isUploading && state.overallProgress == 0.0) {
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
                state.isUploading ? Icons.upload : Icons.check_circle,
                color: state.isUploading ? Colors.blue : Colors.green,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  state.isUploading ? 'Uploading files...' : 'Upload Complete!',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: state.isUploading ? Colors.blue : Colors.green,
                  ),
                ),
              ),
              Text(
                '${(state.overallProgress * 100).toInt()}%',
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
            value: state.overallProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              state.isUploading ? Colors.blue : Colors.green,
            ),
          ),
          if (state.isUploading) ...[
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
}
