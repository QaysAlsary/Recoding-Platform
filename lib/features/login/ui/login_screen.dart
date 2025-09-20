import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/bloc/login_event.dart';
import 'package:recoding_platform_project/features/login/bloc/login_state.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/creat_account_button.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/email_and_password.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/login_texts.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/rememberme_forgot_password.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/routing/router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    HapticFeedback.mediumImpact();
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final isChecked = context.read<LoginBloc>().isChecked;
      context.read<LoginBloc>().add(
            LoginButtonPressed(
                email: email, password: password, isChecked: isChecked),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
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
            } else if (state is LoginSuccess) {
              goRouter.go(Routes.home);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(child: Text(state.loginResponse.message!)),
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
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final isLoading = state is LoginLoading;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top section with header
                      Header(),
                      // SizedBox(height: 20.h),

                      // Content section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          children: [
                            LoginTexts(),
                            SizedBox(height: 10.h),
                            EmailAndPassword(
                              emailController: emailController,
                              passwordController: passwordController,
                            ),
                            RemembermeForgotPassword(),
                            SizedBox(height: 20.h),
                            AuthButton(
                              backGroundColor: Color(0xff6ab3d9),
                              textColor: Colors.white,
                              onPressed: isLoading ? () {} : _handleLogin,
                              text: isLoading ? "Logging in..." : "Login",
                              buttonWidth: double.infinity,
                            ),
                            SizedBox(height: 20.h),
                            if (!isLoading) CreatAccountButton(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),

                      // Footer at bottom
                      LoginFooter(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
