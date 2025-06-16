import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_bloc.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_event.dart';
import 'package:recoding_platform_project/features/register/bloc/bloc/register_state.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/choose_layer.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/register_cridentials.dart';
import 'package:recoding_platform_project/features/register/ui/widgets/register_texts.dart';

import '../../../../src/components/auth_button.dart';
import '../../../../src/components/header.dart';
import '../../../../src/components/login_footer.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController layerController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailure) {
              print('UI received error: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            } else if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.registerResponse.message),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
              print(
                  'Register success message: ${state.registerResponse.message}');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              RegisterTexts(),
              SizedBox(height: 5.h),
              RegisterCridentials(
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                nameController: nameController,
              ),
              SizedBox(
                height: 10,
              ),
              ChooseLayer(layerController: layerController),
              SizedBox(
                height: 10,
              ),
              AuthButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final name = nameController.text.trim();
                  final password_confirmation =
                      confirmPasswordController.text.trim();
                  final layer = layerController.text.trim();
                  context.read<RegisterBloc>().add(
                        RegisterButtonPressed(
                            email: email,
                            password: password,
                            name: name,
                            password_confirmation: password_confirmation,
                            layer: layer),
                      );
                },
                text: "Create Account",
                buttonWidth: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 40.w),
              ),
              SizedBox(
                height: 50,
              ),
              LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
