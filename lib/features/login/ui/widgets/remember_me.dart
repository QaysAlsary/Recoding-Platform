import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class RememberMeCheckbox extends StatefulWidget {
  @override
  _RememberMeCheckboxState createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
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
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
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
  }
}
