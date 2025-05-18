import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../src/components/input_text_form_field.dart';

class EditProfileColumn extends StatelessWidget {
  const EditProfileColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 55).w,
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Account info:",
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
              Icons.person,
              color: Color(0xff9a9a9a),
            ),
            hintText: "Full Name",
          ),
          InputTextFormField(
            prefixIcon: Icon(
              size: 25,
              Icons.email_outlined,
              color: Color(0xff9a9a9a),
            ),
            hintText: "Email",
          ),
          InputTextFormField(
            prefixIcon: Icon(
              size: 25,
              Icons.key,
              color: Color(0xff9a9a9a),
            ),
            hintText: "Password",
            suffixIcon: Icon(
              size: 25,
              Icons.visibility,
              color: Color(0xff9a9a9a),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Your password is required in order to change your email.",
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 24.h,
          )
        ]),
      ),
    );
  }
}
