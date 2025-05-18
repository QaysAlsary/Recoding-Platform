import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../src/components/input_text_form_field.dart';
import '../../../../src/themes/app_icons.dart';

class SecurityColumn extends StatelessWidget {
  const SecurityColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Change Password:",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: 25.sp, fontWeight: FontWeight.w400)),
          SizedBox(
            height: 20.h,
          ),
          InputTextFormField(
            prefixIcon: Icon(
              size: 25,
              Icons.key_outlined,
              color: Color(0xff9a9a9a),
            ),
            suffixIcon: Icon(
              size: 25,
              Icons.visibility,
              color: Color(0xff9a9a9a),
            ),
            hintText: "Current Password",
          ),
          InputTextFormField(
            prefixIcon: Icon(
              size: 25,
              Icons.key_outlined,
              color: Color(0xff9a9a9a),
            ),
            hintText: "New Password",
          ),
          InputTextFormField(
            prefixIcon: Icon(
              size: 25,
              Icons.key_outlined,
              color: Color(0xff9a9a9a),
            ),
            hintText: "Confirm Password",
          ),
          SizedBox(
            height: 83.8.h,
          )
        ]),
      ),
    );
  }
}
