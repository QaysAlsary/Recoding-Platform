import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc/register_bloc.dart';
import '../../bloc/bloc/register_event.dart';
import '../../bloc/bloc/register_state.dart';
import 'dart:async';

class VerifyEmailReg extends StatefulWidget {
  final String email;
  const VerifyEmailReg({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyEmailReg> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<VerifyEmailReg> {
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
          .read<RegisterBloc>()
          .add(ResendVerificationCodeRegister(email: widget.email));
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is VerifyEmailRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is VerifyEmailRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.push(Routes.success, extra: {
              'title': 'Account Created!',
              'subtitle':
                  'Your account has been created successfully! You will be redirected to the login page.',
              'nextRoute': Routes.login
            });
          } else if (state is ResendVerificationCodeRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ResendVerificationCodeRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyEmailRegisterLoading;
          return SingleChildScrollView(
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
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
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
                              child: BlocBuilder<RegisterBloc, RegisterState>(
                                builder: (context, state) {
                                  final isLoading = state
                                      is ResendVerificationCodeRegisterLoading;
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
                          onPressed: isLoading
                              ? () {}
                              : () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    context.read<RegisterBloc>().add(
                                          VerifyEmailCodeRegister(
                                            email: widget.email,
                                            verificationCode:
                                                codeController.text.trim(),
                                          ),
                                        );
                                  }
                                },
                          text: isLoading ? 'Verifying...' : 'Confirm',
                        ),
                        SizedBox(height: 50.h),
                        LoginFooter()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
