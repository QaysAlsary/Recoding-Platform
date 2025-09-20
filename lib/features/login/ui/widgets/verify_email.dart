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
import 'dart:async';

class VerifyEmail extends StatefulWidget {
  final String email;
  const VerifyEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<VerifyEmail> {
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
    _canResend = false;
    _resendCountdown = 10;
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _handleResendCode() {
    if (_canResend) {
      context
          .read<LoginBloc>()
          .add(ResendCodeRequested(email: widget.email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is VerifyCodeSuccess) {
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
            context.push(
              Routes.resetPass,
              extra: {
                'email': widget.email,
              },
            );
          } else if (state is VerifyCodeFailure) {
            _startResendTimer();
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
          } else if (state is ResendCodeSuccess) {
            _startResendTimer();
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
          } else if (state is ResendCodeFailure) {
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
                        'Enter Verification Code',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w400,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'To verify your account, enter the code we sent to ${widget.email}.',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      InputTextFormField(
                        controller: codeController,
                        hintText: 'Verification code',
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
                      // Resend Code Button
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
                            child: Text(
                              _canResend
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
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is VerifyCodeLoading;
                          return AuthButton(
                            backGroundColor: Color(0xff6ab3d9),
                            textColor: Colors.white,
                            onPressed: isLoading
                                ? () {}
                                : () {
                                    if (_formKey.currentState?.validate() ==
                                        true) {
                                      context.read<LoginBloc>().add(
                                            VerifyCodeRequested(
                                              email: widget.email,
                                              verificationCode:
                                                  codeController.text.trim(),
                                            ),
                                          );
                                    }
                                  },
                            text: isLoading ? 'Verifying...' : 'Confirm',
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
