import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_event.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';

import '../../../../src/components/input_text_form_field.dart';

class SecurityColumn extends StatelessWidget {
  SecurityColumn(
      {super.key,
      required this.currentPassword,
      required this.newPassword,
      required this.newPasswordConfirm,
      required this.isObscured});
  final TextEditingController currentPassword;
  final TextEditingController newPassword;
  final TextEditingController newPasswordConfirm;
  final bool isObscured;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Change Password:",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: 25.sp, fontWeight: FontWeight.w400)),
            SizedBox(
              height: 20.h,
            ),
            InputTextFormField(
              obscureText: isObscured,
              prefixIcon: Icon(
                size: 25.sp,
                Icons.key_outlined,
                color: Color(0xff9a9a9a),
              ),
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
              hintText: "Current Password",
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              controller: currentPassword,
            ),
            InputTextFormField(
              obscureText: isObscured,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              prefixIcon: Icon(
                size: 25.sp,
                Icons.key_outlined,
                color: Color(0xff9a9a9a),
              ),
              hintText: "New Password",
              controller: newPassword,
            ),
            InputTextFormField(
              obscureText: isObscured,
              controller: newPasswordConfirm,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              prefixIcon: Icon(
                size: 25.sp,
                Icons.key_outlined,
                color: Color(0xff9a9a9a),
              ),
              hintText: "Confirm Password",
            ),
            SizedBox(
              height: 83.8.h,
            ),
            AuthButton(
              onPressed: () {
                if (_formKey.currentState?.validate() != true) return;
                if (newPassword.text.length < 8 ||
                    newPasswordConfirm.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("The password must be at least 8 characters."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (newPassword.text != newPasswordConfirm.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                context.read<ProfileBloc>().add(
                      UpdateProfileSecurity(
                          currentPassword: currentPassword.text,
                          newPassword: newPassword.text,
                          newPasswordConfirm: newPasswordConfirm.text),
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
