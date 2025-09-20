import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';
import 'package:recoding_platform_project/src/components/custom_app_bar.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  const EmailVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleResendCode() {
    if (_canResend) {
      context
          .read<ProfileBloc>()
          .add(ResendVerificationCode(email: widget.email));
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SettingsDrawer(),
      appBar: const CustomAppBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is VerifyEmailFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is VerifyEmailSuccessState) {
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
                'title': 'Email Verified Successfully!',
                'subtitle':
                    'Your email has been successfully verified and updated.',
                'nextRoute': Routes.changePassword,
              },
            );
          } else if (state is ResendVerificationCodeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ResendVerificationCodeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.h),
                    Center(
                      child: Image.asset(
                        AppImages.platform_logo,
                        width: 200.w,
                        height: 200.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Enter Verification Code:',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'To Verify New Email , Enter The Code We Sent To Your Email',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    InputTextFormField(
                      controller: codeController,
                      hintText: 'Confirmation Code',
                      prefixIcon: Icon(
                        Icons.key,
                        color: const Color(0xff9a9a9a),
                        size: 25.sp,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the code';
                        }
                        if (value.length < 6 || value.length > 6) {
                          return 'Code must be 6 digits';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Code must be numbers only';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                        ),
                        TextButton(
                          onPressed: _canResend ? _handleResendCode : null,
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              final isLoading =
                                  state is ResendVerificationCodeLoading;
                              return Text(
                                isLoading
                                    ? "Resending..."
                                    : _canResend
                                        ? "Resend Code"
                                        : "Resend Code in $_resendCountdown seconds",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: _canResend
                                          ? Color(0xff6ab3d9)
                                          : Colors.grey[400],
                                      decoration: _canResend
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                    ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    AuthButton(
                      backGroundColor: Color(0xff6ab3d9),
                      textColor: Colors.white,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (_formKey.currentState?.validate() == true) {
                          // Use the ProfileBloc to verify email code
                          context.read<ProfileBloc>().add(
                                VerifyEmailCode(
                                  email: widget.email,
                                  verificationCode: codeController.text.trim(),
                                ),
                              );
                        }
                      },
                      text: state is VerifyEmailLoadingState
                          ? 'Verifying...'
                          : 'Confirm',
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
