import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';
import 'package:recoding_platform_project/src/components/custom_app_bar.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';

import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';

import 'dart:async';

class VerifyEmailHomeScreen extends StatefulWidget {
  const VerifyEmailHomeScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailHomeScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<VerifyEmailHomeScreen> {
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _userEmail;

  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _startResendTimer();
  }

  @override
  void dispose() {
    codeController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserEmail() async {
    final email = await SecureStorageService.getUserEmail();
    if (mounted) {
      setState(() {
        _userEmail = email;
      });
    }
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
    if (_canResend && _userEmail != null) {
      context
          .read<ProfileBloc>()
          .add(ResendVerificationCode(email: _userEmail!));
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SettingsDrawer(),
      appBar: const CustomAppBar(),
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
        child: BlocConsumer<ProfileBloc, ProfileState>(
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
                  'nextRoute': Routes.home,
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
                      SizedBox(height: 40.h),
                      // Animated logo container
                      Container(
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
                      SizedBox(height: 40.h),
                      // Title with better styling
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16.r),
                          border:
                              Border.all(color: Colors.blue.shade200, width: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Enter Verification Code',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _userEmail != null
                                  ? 'We sent a verification code to\n$_userEmail'
                                  : 'We sent a verification code to your email',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
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
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
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
                            if (_formKey.currentState?.validate() == true &&
                                _userEmail != null) {
                              // Use the ProfileBloc to verify email code
                              context.read<ProfileBloc>().add(
                                    VerifyEmailCode(
                                      email: _userEmail!,
                                      verificationCode:
                                          codeController.text.trim(),
                                    ),
                                  );
                            } else if (_userEmail == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Email not found. Please try again.'),
                                  backgroundColor: Colors.red,
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
                            state is VerifyEmailLoadingState
                                ? 'Verifying...'
                                : 'Verify Email',
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
            );
          },
        ),
      ),
    );
  }
}
