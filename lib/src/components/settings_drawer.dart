import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';
import 'package:shimmer/shimmer.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  String? _userEmail;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await SecureStorageService.getUserEmail();
    if (mounted) {
      setState(() {
        _userEmail = email;
        _userName = email?.split('@').first ?? 'User';
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await SecureStorageService.clearUserData();
    if (context.mounted) {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F9FA),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Header Section
            _buildProfileHeader(),

            // Divider
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              color: const Color(0xFFE9ECEF),
            ),

            // Menu Items Section
            Expanded(
              child: _buildMenuItems(context),
            ),

            // Sign Out Section
            _buildSignOutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String displayName = _userName ?? 'User';
        String displayEmail = _userEmail ?? 'user@example.com';
        String? userPosition;
        String? userDepartment;
        String? userProfileImage;

        // Get real profile data if available
        if (state is ProfileLoadSuccessState) {
          final user = state.profileResponse.user;

          displayName = user.name.isNotEmpty ? user.name : displayName;
          displayEmail = user.email.isNotEmpty ? user.email : displayEmail;
          userPosition = user.position.isNotEmpty ? user.position : null;
          userDepartment = user.department.isNotEmpty ? user.department : null;
          userProfileImage =
              user.profile_image!.isNotEmpty ? user.profile_image : null;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF343A40),
                const Color(0xFF495057),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar
              Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: userProfileImage == null
                      ? Icon(
                          Icons.person_outline,
                          size: 40.sp,
                          color: Colors.white,
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userProfileImage!,
                            fit: BoxFit.cover,
                            width: 44.w,
                            height: 44.w,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset(AppImages.noProfileImage),
                          ),
                        )),

              SizedBox(height: 16.h),

              // User Name
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),

              SizedBox(height: 4.h),

              // User Email
              Text(
                displayEmail,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),

              // Show position and department if available
              if (userPosition != null || userDepartment != null) ...[
                SizedBox(height: 8.h),
                if (userPosition != null)
                  Text(
                    userPosition,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                if (userDepartment != null)
                  Text(
                    userDepartment,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
              ],

              SizedBox(height: 16.h),

              // Profile Button
              Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(Routes.profile);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 16.sp,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      children: [
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'App preferences and configuration',
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to settings page
          },
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage your notification preferences',
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to notifications page
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to help page
          },
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () {
            Navigator.of(context).pop();
            // TODO: Navigate to about page
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C757D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: const Color(0xFF6C757D),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF212529),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: const Color(0xFF6C757D),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => _signOut(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC3545).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.logout_outlined,
                    size: 20.sp,
                    color: const Color(0xFFDC3545),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC3545),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Sign out of your account',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6C757D),
                        ),
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
}
