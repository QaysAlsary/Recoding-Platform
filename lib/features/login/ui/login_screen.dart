import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/creat_account_button.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/email_and_password.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/login_texts.dart';
import 'package:recoding_platform_project/features/login/ui/widgets/rememberme_forgot_password.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
          onPressed: () => print("login button pressed"),
          text: "Login",
          buttonWidth: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 40.w),
        ),
        CreatAccountButton(),
        Spacer(),
        LoginFooter(),
      ])),
    );
  }
}
