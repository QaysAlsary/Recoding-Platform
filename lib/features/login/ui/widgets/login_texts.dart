import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class LoginTexts extends StatelessWidget {
  const LoginTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome Back!",
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: 45.sp),
        ),
        // Text("Enter your credentials to continue",
        //     style: Theme.of(context)
        //         .textTheme
        //         .labelMedium
        //         ?.copyWith(fontSize: 20.sp, color: AppColors.black073)),
      ],
    );
  }
}
