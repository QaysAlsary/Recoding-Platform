import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/bloc/login_event.dart';
import 'package:recoding_platform_project/features/login/bloc/login_state.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<PasswordReset> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
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
            // Navigate to verify email screen with the email
            context.push(
              Routes.verifyEmail,
              extra: {'email': emailController.text.trim()},
            );
          } else if (state is ForgotPasswordFailure) {
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
                        'Password Reset',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 50.sp,
                              fontWeight: FontWeight.w400,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Provide the email address associated with your account to recover your password.',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      InputTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.mail,
                          color: const Color(0xff9a9a9a),
                          size: 25.sp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is ForgotPasswordLoading;
                          return AuthButton(
                            backGroundColor: Color(0xff6ab3d9),
                            textColor: Colors.white,
                            onPressed: isLoading
                                ? () {}
                                : () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      context.read<LoginBloc>().add(
                                            ForgotPasswordRequested(
                                              email:
                                                  emailController.text.trim(),
                                            ),
                                          );
                                    }
                                  },
                            text:
                                isLoading ? 'Sending...' : 'Reset my password',
                          );
                        },
                      ),
                      SizedBox(height: 200.h),
                      LoginFooter()
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
