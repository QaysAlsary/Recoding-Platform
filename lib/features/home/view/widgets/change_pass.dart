import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';

import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';

class ChangePassHomeScreen extends StatelessWidget {
  const ChangePassHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ChangePasswordFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ChangePasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to success screen
          context.go(
            Routes.successChange,
            extra: {
              'title': 'Password Changed!',
              'subtitle':
                  'Your Password have been changed successfully!, you will be redirected to The Home Page.',
              'nextRoute': Routes.home,
            },
          );
        }
      },
      builder: (context, state) {
        final isNewPasswordObscured =
            state is ChangePasswordState ? state.isNewPasswordObscured : true;

        return _ChangePasswordContent(
          isNewPasswordObscured: isNewPasswordObscured,
          isLoading: state is ChangePasswordLoadingState,
        );
      },
    );
  }
}

class _ChangePasswordContent extends StatefulWidget {
  final bool isNewPasswordObscured;
  final bool isLoading;

  const _ChangePasswordContent({
    required this.isNewPasswordObscured,
    required this.isLoading,
  });

  @override
  State<_ChangePasswordContent> createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<_ChangePasswordContent> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SettingsDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
              Colors.blue.shade50,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  // Enhanced logo container
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppImages.platform_logo,
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Enhanced title container
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: Text(
                      'Change Password',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  InputTextFormField(
                    controller: newPasswordController,
                    hintText: 'New Password',
                    obscureText: widget.isNewPasswordObscured,
                    prefixIcon: Icon(
                      Icons.key,
                      color: const Color(0xff9a9a9a),
                      size: 25.sp,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        final bloc = context.read<ProfileBloc>();
                        if (!bloc.isClosed) {
                          bloc.add(const ToggleNewPasswordVisibility());
                        }
                      },
                      icon: Icon(
                        widget.isNewPasswordObscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xff9a9a9a),
                        size: 20.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  InputTextFormField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: widget.isNewPasswordObscured,
                    prefixIcon: Icon(
                      Icons.key,
                      color: const Color(0xff9a9a9a),
                      size: 25.sp,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        return 'Passwords do not match';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 40.h),
                  // Enhanced button with gradient
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff6ab3d9),
                          Color(0xff4a9bc7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff6ab3d9).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (_formKey.currentState?.validate() == true) {
                          context.read<ProfileBloc>().add(
                                ChangePassword(
                                  password: newPasswordController.text.trim(),
                                  passwordConfirmation:
                                      confirmPasswordController.text.trim(),
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        widget.isLoading
                            ? 'Changing Password...'
                            : 'Save Changes',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
