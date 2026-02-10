import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_event.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/custom_app_bar.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SettingsDrawer(),
      appBar: const CustomAppBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ChangeEmailFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ChangeEmailSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to email verification screen with email parameter
            context.push(Routes.emailVerification, extra: newEmail.text.trim());
          }
        },
        builder: (context, profileState) {
          return BlocBuilder<ToggleBloc, ToggleState>(
            builder: (context, toggleState) {
              final isObscured = toggleState is SecurityState
                  ? toggleState.isObscured
                  : (toggleState is EditProfileState
                      ? toggleState.isObscured
                      : true);

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32.h),
                        Image.asset(
                          AppImages.platform_logo,
                          width: 120.w,
                          height: 120.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "Change Email:",
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        SizedBox(height: 20.h),
                        InputTextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required to save changes';
                            }
                            return null;
                          },
                          controller: currentPassword,
                          obscureText: isObscured,
                          prefixIcon: Icon(
                            size: 25.sp,
                            Icons.key,
                            color: Color(0xff9a9a9a),
                          ),
                          hintText: "Current Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              context
                                  .read<ToggleBloc>()
                                  .add(TogglePasswordVisibility());
                            },
                            icon: Icon(
                              size: 20.sp,
                              isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xff9a9a9a),
                            ),
                          ),
                        ),
                        InputTextFormField(
                          controller: newEmail,
                          prefixIcon: Icon(
                            size: 25.sp,
                            Icons.email_outlined,
                            color: Color(0xff9a9a9a),
                          ),
                          hintText: "New Email",
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "For security related reasons, when you change your email it will be required to change your password.",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        SizedBox(height: 24.h),
                        AuthButton(
                          backGroundColor: Color(0xff6ab3d9),
                          textColor: Colors.white,
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            if (_formKey.currentState?.validate() != true) {
                              return;
                            }
                            if (currentPassword.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Current password is required"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (newEmail.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("New email is required"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            // Note: Password validation should be done server-side
                            // For now, we'll skip this client-side validation
                            // as it's not secure to store passwords locally

                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(newEmail.text.trim())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Enter a valid email address"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Use the ProfileBloc to change email
                            context.read<ProfileBloc>().add(
                                  ChangeEmail(
                                    newEmail: newEmail.text.trim(),
                                    currentPassword:
                                        currentPassword.text.trim(),
                                  ),
                                );
                          },
                          text: profileState is ChangeEmailLoadingState
                              ? "Submitting..."
                              : "Submit",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
