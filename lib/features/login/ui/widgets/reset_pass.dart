import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/bloc/login_event.dart';
import 'package:recoding_platform_project/features/login/bloc/login_state.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class ResetPass extends StatefulWidget {
  final String email;
  const ResetPass({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.response,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            // Navigate to success screen
            context.push(
              Routes.success,
              extra: {
                'title': 'Password Changed!',
                'subtitle':
                    'Your password has been changed successfully! You will be redirected to the login page.',
              },
            );
          } else if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                duration: Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),
                      Text(
                        'Reset Password',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w400,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Setting new password for ${widget.email}',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      InputTextFormField(
                        controller: newPasswordController,
                        hintText: 'New Password',
                        obscureText: _obscureNewPassword,
                        prefixIcon: Icon(
                          Icons.key,
                          color: const Color(0xff9a9a9a),
                          size: 25.sp,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: _toggleNewPasswordVisibility,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      InputTextFormField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _obscureNewPassword,
                        prefixIcon: Icon(
                          Icons.key,
                          color: const Color(0xff9a9a9a),
                          size: 25.sp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is ResetPasswordLoading;
                          return AuthButton(
                            backGroundColor: Color(0xff6ab3d9),
                            textColor: Colors.white,
                            onPressed: isLoading
                                ? () {}
                                : () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      context.read<LoginBloc>().add(
                                            ResetPasswordRequested(
                                              email: widget.email,
                                              password: newPasswordController
                                                  .text
                                                  .trim(),
                                              passwordConfirmation:
                                                  confirmPasswordController.text
                                                      .trim(),
                                            ),
                                          );
                                    }
                                  },
                            text: isLoading
                                ? 'Resetting...'
                                : 'Reset My Password',
                          );
                        },
                      ),
                      SizedBox(height: 180.h),
                      LoginFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
