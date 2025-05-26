import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/login/bloc/login_bloc.dart';
import 'package:recoding_platform_project/features/login/bloc/login_event.dart';
import 'package:recoding_platform_project/features/login/bloc/login_state.dart'; // لازم تضيف استيراد الحالة
import 'package:recoding_platform_project/features/login/ui/widgets/creat_account_button.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/email_and_password.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/login_texts.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/rememberme_forgot_password.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/network_error_handler.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              print('UI received error: ${state.error}'); // <<< للتأكد
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.loginResponse.message),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
              print('Login success message: ${state.loginResponse.message}');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              SizedBox(height: 20.h),
              LoginTexts(),
              SizedBox(height: 10.h),
              EmailAndPassword(
                emailController: emailController,
                passwordController: passwordController,
              ),
              RemembermeForgotPassword(),
              AuthButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  context.read<LoginBloc>().add(
                        LoginButtonPressed(email: email, password: password),
                      );
                },
                text: "Login",
                buttonWidth: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 40.w),
              ),
              CreatAccountButton(),
              Spacer(),
              LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
