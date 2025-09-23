import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';

class RegisterCridentials extends StatefulWidget {
  const RegisterCridentials({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;

  @override
  State<RegisterCridentials> createState() => _RegisterCridentialsState();
}

class _RegisterCridentialsState extends State<RegisterCridentials> {
  bool isObsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InputTextFormField(
        controller: widget.nameController,
        hintText: 'Name',
        prefixIconIcon: Icons.person_2_outlined,
        width: 340.w,
        height: 60.h,
        margin: EdgeInsets.symmetric(vertical: 5),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
      InputTextFormField(
        controller: widget.emailController,
        hintText: 'Email',
        prefixIconIcon: Icons.email_outlined,
        width: 340.w,
        height: 60.h,
        margin: EdgeInsets.symmetric(vertical: 5),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(value.trim())) {
            return 'Please enter a valid email';
          }
          return null;
        },
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
      ),
      InputTextFormField(
        controller: widget.confirmPasswordController,
        hintText: 'Confirm Password',
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value.trim().length < 8) {
            return 'Password must be at least 8 characters';
          }
          if (value != widget.passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    ]);
  }
}
