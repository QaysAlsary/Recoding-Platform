import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/remember_me.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class RemembermeForgotPassword extends StatelessWidget {
  const RemembermeForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RememberMeCheckbox(),
        TextButton(
            onPressed: () {
              context.push(Routes.passwordReset);
            },
            child: Text(
              "Forgot Password?",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(fontSize: 16.sp, color: AppColors.black073),
            ))
      ],
    );
  }
}
