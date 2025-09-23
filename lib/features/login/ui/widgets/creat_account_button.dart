import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/register/ui/screens/register_screen.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class CreatAccountButton extends StatelessWidget {
  const CreatAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Don’t have an account?",
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontSize: 14.sp, color: AppColors.black073),
      ),
      TextButton(
        onPressed: () {
          context.go(Routes.register);
        },
        child: Text(
          "Create a new account",
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                decoration: TextDecoration.underline,
              ),
        ),
      )
    ]);
  }
}
