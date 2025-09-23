import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/bloc/login_event.dart';
import 'package:recoding_platform_project/features/login/bloc/login_state.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class RememberMeCheckbox extends StatefulWidget {
  @override
  _RememberMeCheckboxState createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final isChecked = context.read<LoginBloc>().isChecked;
      // state is RememberMeToggled ? state.isChecked : false;
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isChecked,
            checkColor: AppColors.blue,
            activeColor: AppColors.black015,
            side: BorderSide(
              color: AppColors.blue, // Border color same as text color
              width: 1, // You can adjust the width here
            ),
            onChanged: (_) {
              context.read<LoginBloc>().add(ToggleRememberMe());
            },
          ),
          Text(
            'Remember Me',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontSize: 16.sp, color: AppColors.black073),
          ),
        ],
      );
    });
  }
}
