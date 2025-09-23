import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';

import '../../../../src/themes/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class TopBarWidget extends StatelessWidget {
  final VoidCallback? onSettingsPressed;
  const TopBarWidget({super.key, this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Avatar
            _buildProfileAvatar(context),

            // Center Logo
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 200.w,
                    minWidth: 120.w,
                  ),
                  child: LoginFooter(
                    width: 200.w,
                  ),
                ),
              ),
            ),

            // Right side buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.read<ProfileBloc>().add(LoadProfile());
          context.push(Routes.profile);
        },
        borderRadius: BorderRadius.circular(22.w),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            String? imageUrl;
            if (state is ProfileLoadSuccessState) {
              imageUrl = state.profileResponse.user.profile_image;
            }

            return ClipOval(
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
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
                    )
                  : Image.asset(
                      AppImages.noProfileImage,
                      fit: BoxFit.cover,
                      width: 44.w,
                      height: 44.w,
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.notifications_none,
          onPressed: () {},
          badge: '1', // Example badge
        ),
        8.horizontalSpace,
        if (onSettingsPressed != null)
          _buildActionButton(
            icon: Icons.settings,
            onPressed: onSettingsPressed!,
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? badge,
  }) {
    return Stack(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.w),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12.w),
              child: Icon(
                icon,
                size: 22.w,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        if (badge != null)
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10.w),
              ),
              constraints: BoxConstraints(
                minWidth: 16.w,
                minHeight: 16.w,
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
