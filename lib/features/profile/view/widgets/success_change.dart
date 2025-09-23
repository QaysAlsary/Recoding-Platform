import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';
import 'package:recoding_platform_project/src/components/custom_app_bar.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class SuccessChangeScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? nextRoute;

  const SuccessChangeScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    this.nextRoute,
  }) : super(key: key);

  @override
  State<SuccessChangeScreen> createState() => _SuccessChangeScreenState();
}

class _SuccessChangeScreenState extends State<SuccessChangeScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    final nextRoute = widget.nextRoute ?? Routes.profile;
    context.go(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SettingsDrawer(),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 180.h),
              Center(
                child: Image.asset(
                  AppImages.mark_success,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                widget.subtitle,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
