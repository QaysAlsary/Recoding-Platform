import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class RegisterTexts extends StatelessWidget {
  const RegisterTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create Your Account!",
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: 40.sp),
        ),
        // Text("Enter your credentials to continue",
        //     style: Theme.of(context)
        //         .textTheme
        //         .labelMedium
        //         ?.copyWith(fontSize: 21.sp, color: AppColors.black073)),
      ],
    );
  }
}
