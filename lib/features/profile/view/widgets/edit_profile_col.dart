import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_event.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/core/token.dart';

import '../../../../src/components/input_text_form_field.dart';

class EditProfileColumn extends StatelessWidget {
  final bool isObscured;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  EditProfileColumn(
      {super.key,
      required this.isObscured,
      required this.name,
      required this.email,
      required this.password});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 55).w,
      child: Align(
        alignment: Alignment.topLeft,
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Account info:",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: 25.sp, fontWeight: FontWeight.w400)),
            SizedBox(
              height: 20.h,
            ),
            InputTextFormField(
              controller: name,
              prefixIcon: Icon(
                size: 25.sp,
                Icons.person,
                color: Color(0xff9a9a9a),
              ),
              hintText: "Full Name",
            ),
            InputTextFormField(
              controller: email,
              prefixIcon: Icon(
                size: 25.sp,
                Icons.email_outlined,
                color: Color(0xff9a9a9a),
              ),
              hintText: "Email",
            ),
            InputTextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required to save changes';
                }
                return null;
              },
              controller: password,
              obscureText: isObscured,
              prefixIcon: Icon(
                size: 25.sp,
                Icons.key,
                color: Color(0xff9a9a9a),
              ),
              hintText: "Password",
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<ToggleBloc>().add(TogglePasswordVisibility());
                },
                icon: Icon(
                  size: 20.sp,
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Color(0xff9a9a9a),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
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
            ),
            AuthButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() != true) return;
                if (password.text != await PassManager.getPassword()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Current password is not correct"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                // if (newPassword.text != newPasswordConfirm.text) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text("Passwords do not match"),
                //       backgroundColor: Colors.red,
                //     ),
                //   );
                //   return;
                // }

                context.read<ProfileBloc>().add(
                      UpdateProfileInfo(
                          currentPassword: password.text,
                          name: name.text,
                          email: email.text),
                    );
              },
              text: "Save Changes",
            ),
          ]),
        ),
      ),
    );
  }
}
