import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';


class CreateMarkerButton extends StatelessWidget {
  const CreateMarkerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 38.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue.withOpacity(0.65),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
          onPressed: () {

          },
          child:  Text('Create Marker' , style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
