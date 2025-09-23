import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_event.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';

import '../../../../src/components/input_text_form_field.dart';

class SecurityColumn extends StatelessWidget {
  SecurityColumn({
    super.key,
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  final TextEditingController currentPassword;
  final TextEditingController newPassword;
  final TextEditingController newPasswordConfirm;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleBloc, ToggleState>(
      builder: (context, state) {
        final isObscured = state is SecurityState
            ? state.isObscured
            : (state is EditProfileState ? state.isObscured : true);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline,
                            color: Color(0xff6ab3d9), size: 28.sp),
                        SizedBox(width: 10.w),
                        Text(
                          "Change Password:",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                                color: Colors.black,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    InputTextFormField(
                      obscureText: isObscured,
                      prefixIcon: Icon(
                        size: 25.sp,
                        Icons.key_outlined,
                        color: Color(0xff9a9a9a),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          context
                              .read<ToggleBloc>()
                              .add(TogglePasswordVisibility());
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
                    SizedBox(height: 16.h),
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
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
                      child: Text(
                        "Password must be at least 8 characters.",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13.sp,
                        ),
                      ),
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
                    SizedBox(height: 24.h),
                    AuthButton(
                      backGroundColor: Color(0xff6ab3d9),
                      textColor: Colors.white,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (!_formKey.currentState!.validate()) return;
                        if (newPassword.text.length < 8 ||
                            newPasswordConfirm.text.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "The password must be at least 8 characters."),
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
                                newPasswordConfirm: newPasswordConfirm.text,
                              ),
                            );
                      },
                      text: "Save Changes",
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
