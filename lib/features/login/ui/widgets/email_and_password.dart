import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword(
      {super.key,
      required this.emailController,
      required this.passwordController});

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InputTextFormField(
        controller: widget.emailController,
        hintText: 'Email',
        prefixIconIcon: Icons.email_outlined,
        width: 340.w,
        height: 60.h,
        margin: EdgeInsets.symmetric(vertical: 5),
      ),
      InputTextFormField(
        controller: widget.passwordController,
        hintText: 'Password',
        obscureText: isObsecureText,
        prefixIconIcon: Icons.vpn_key_outlined,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isObsecureText = !isObsecureText;
            });
          },
          child: Icon(
            isObsecureText ? Icons.visibility_off : Icons.visibility,
            size: 25,
            color: Colors.black.withOpacity(0.45),
          ),
        ),
        width: 340.w,
        height: 60.h,
        margin: EdgeInsets.symmetric(vertical: 5),
      ),
    ]);
  }
}
