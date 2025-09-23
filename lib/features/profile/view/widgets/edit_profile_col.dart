import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

import '../../../../src/components/input_text_form_field.dart';
import 'package:go_router/go_router.dart';

class EditProfileColumn extends StatelessWidget {
  final TextEditingController name;
  EditProfileColumn({
    super.key,
    required this.name,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleBloc, ToggleState>(
      builder: (context, state) {
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
                        Icon(Icons.person,
                            color: Color(0xff6ab3d9), size: 28.sp),
                        SizedBox(width: 10.w),
                        Text(
                          "Change Name:",
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
                      controller: name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Full name must be at least 3 characters';
                        }
                        if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
                          return 'Full name can only contain English letters';
                        }
                        return null; // valid
                      },
                      prefixIcon: Icon(
                        size: 25.sp,
                        Icons.person,
                        color: Color(0xff9a9a9a),
                      ),
                      hintText: "Full Name",
                    ),
                    SizedBox(height: 20.h),
                    AuthButton(
                      backGroundColor: Color(0xff6ab3d9),
                      textColor: Colors.white,
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        if (!_formKey.currentState!.validate()) return;
                        context.read<ProfileBloc>().add(
                              UpdateProfileInfo(
                                name: name.text,
                              ),
                            );
                      },
                      text: "Save Changes",
                    ),
                    SizedBox(height: 24.h),
                    Divider(thickness: 1.1, color: Colors.grey.shade200),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            color: Color(0xff6ab3d9), size: 24.sp),
                        SizedBox(width: 10.w),
                        Text(
                          "Change Email",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.sp,
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    AuthButton(
                      backGroundColor: Color(0xff6ab3d9),
                      textColor: Colors.white,
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        context.push(Routes.changeEmail);
                      },
                      text: "Change Email",
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
