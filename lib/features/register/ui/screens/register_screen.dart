import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_bloc.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_event.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_state.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/choose_layer.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/login_account_button.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/register_cridentials.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/register_texts.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

import '../../../../src/components/auth_button.dart';
import '../../../../src/components/header.dart';
import '../../../../src/components/login_footer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    HapticFeedback.mediumImpact();
    if (_formKey.currentState?.validate() == true) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();
      final password_confirmation = confirmPasswordController.text.trim();
      context.read<RegisterBloc>().add(RegisterButtonPressed(
          name: name,
          email: email,
          password: password,
          password_confirmation: password_confirmation));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailure) {
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
            } else if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(child: Text(state.registerResponse.message)),
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
                Routes.verifyEmailReg,
                extra: {'email': emailController.text.trim()},
              );
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              final isLoading = state is RegisterLoading;

              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Header(),
                      RegisterTexts(),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          children: [
                            RegisterCridentials(
                              emailController: emailController,
                              passwordController: passwordController,
                              confirmPasswordController:
                                  confirmPasswordController,
                              nameController: nameController,
                            ),
                            SizedBox(height: 10.h),
                            AuthButton(
                              backGroundColor: Color(0xff6ab3d9),
                              textColor: Colors.white,
                              onPressed: isLoading ? () {} : _handleRegister,
                              text: isLoading
                                  ? "Creating Account..."
                                  : "Create Account",
                              buttonWidth: double.infinity,
                            ),
                            SizedBox(height: 10.h),
                            if (!isLoading) LoginAccountButton(),
                          ],
                        ),
                      ),
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
