import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class ProfileErrorBanner extends StatelessWidget {
  const ProfileErrorBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is UserNotVerifiedState) {
          return _buildErrorBanner(
            context: context,
            message: state.message,
            bannerType: BannerType.warning,
            buttonText: 'Verify Email',
            onButtonPressed: () {
              context.push(Routes.verifyEmailHome);
            },
          );
        } else if (state is PasswordMustBeChangedState) {
          return _buildErrorBanner(
            context: context,
            message: state.message,
            bannerType: BannerType.error,
            buttonText: 'Change Password',
            onButtonPressed: () {
              context.push(Routes.changePasswordHome);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorBanner({
    required BuildContext context,
    required String message,
    required BannerType bannerType,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    final colors = _getBannerColors(bannerType);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      // margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Material(
        elevation: 2,
        // borderRadius: BorderRadius.circular(16.r),
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.background,
                colors.background.withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.border,
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                // Subtle pattern overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.5,
                        colors: [
                          colors.accent.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    children: [
                      // Icon container with subtle background
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: colors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: colors.accent.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _getBannerIcon(bannerType),
                          color: colors.accent,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getBannerTitle(bannerType),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.text,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              message,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: colors.subtext,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Action button
                      _buildActionButton(
                        context: context,
                        colors: colors,
                        buttonText: buttonText,
                        onButtonPressed: onButtonPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required BannerColors colors,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onButtonPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.accent,
                colors.accent.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }

  BannerColors _getBannerColors(BannerType type) {
    switch (type) {
      case BannerType.warning:
        return BannerColors(
          background: const Color(0xFFF8F9FA),
          border: const Color(0xFFE9ECEF),
          accent: const Color(0xFF6C757D),
          text: const Color(0xFF212529),
          subtext: const Color(0xFF6C757D),
        );
      case BannerType.error:
        return BannerColors(
          background: const Color(0xFFF8F9FA),
          border: const Color(0xFFE9ECEF),
          accent: const Color(0xFF343A40),
          text: const Color(0xFF212529),
          subtext: const Color(0xFF6C757D),
        );
    }
  }

  IconData _getBannerIcon(BannerType type) {
    switch (type) {
      case BannerType.warning:
        return Icons.email_outlined;
      case BannerType.error:
        return Icons.lock_outline;
    }
  }

  String _getBannerTitle(BannerType type) {
    switch (type) {
      case BannerType.warning:
        return 'Email Verification Required';
      case BannerType.error:
        return 'Password Update Required';
    }
  }
}

enum BannerType { warning, error }

class BannerColors {
  final Color background;
  final Color border;
  final Color accent;
  final Color text;
  final Color subtext;

  const BannerColors({
    required this.background,
    required this.border,
    required this.accent,
    required this.text,
    required this.subtext,
  });
}
