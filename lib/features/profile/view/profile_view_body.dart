import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/edit_profile_col.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/security_col.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/toggle_taps.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';

import '../bloc/profile_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewBody extends StatelessWidget {
  ProfileViewBody({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController currentPasswordSecurity = TextEditingController();

  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirm = TextEditingController();

  void clearSecurityTextControllers() {
    currentPasswordSecurity.clear();
    newPassword.clear();
    newPasswordConfirm.clear();
  }

  void clearUserInfoTextControllers() {
    name.clear();
    // currentPassword is for security, not user info, so no need to clear here again
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
          clearSecurityTextControllers();
          clearUserInfoTextControllers();
        } else if (state is UpdateProfileFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
          clearSecurityTextControllers();
          clearUserInfoTextControllers();
          context.read<ProfileBloc>().add(LoadProfile());
        } else if (state is UpdateProfileSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          clearSecurityTextControllers();
          clearUserInfoTextControllers();
          context.read<ProfileBloc>().add(LoadProfile());
        }
      },
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        } else if (state is ProfileLoadSuccessState) {
          final profileImageUrl = state.profileResponse.user.profile_image;
          final fullImageUrl =
              profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? (profileImageUrl.startsWith('http')
                      ? profileImageUrl
                      : EndPoint.imageBaseUrl + profileImageUrl)
                  : null;
          return BlocProvider<ToggleBloc>(
            create: (context) => ToggleBloc(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 24.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Color(0xff6ab3d9),
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 110.r,
                                        height: 110.r,
                                        child: fullImageUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: fullImageUrl,
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade300,
                                                  highlightColor:
                                                      Colors.grey.shade100,
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  AppImages.noProfileImage,
                                                  fit: BoxFit.cover,
                                                ),
                                                fit: BoxFit.cover,
                                                cacheKey: fullImageUrl,
                                              )
                                            : Image.asset(
                                                AppImages.noProfileImage,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        HapticFeedback.selectionClick();
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final image = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        if (image != null) {
                                          context.read<ProfileBloc>().add(
                                              UpdateProfilePic(image: image));
                                        }
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.08),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                          color: Color(0xff6ab3d9),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 24.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.profileResponse.user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 26.sp,
                                          ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      state.profileResponse.user.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Colors.grey.shade700,
                                            fontSize: 16.sp,
                                          ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${state.profileResponse.user.position}, ${state.profileResponse.user.department}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey.shade500,
                                            fontSize: 15.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Divider(thickness: 1.2, color: Colors.grey.shade200),
                      SizedBox(height: 12.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 18.h, horizontal: 18.w),
                        child: const ToggleTabs(),
                      ),
                      SizedBox(height: 18.h),
                      BlocBuilder<ToggleBloc, ToggleState>(
                        builder: (context, toggleState) {
                          if (toggleState is EditProfileState) {
                            clearSecurityTextControllers();
                            return EditProfileColumn(
                              name: name,
                            );
                          } else if (toggleState is SecurityState) {
                            clearUserInfoTextControllers();
                            return SecurityColumn(
                              currentPassword: currentPasswordSecurity,
                              newPassword: newPassword,
                              newPasswordConfirm: newPasswordConfirm,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          // fallback for initial or error states
          return const Scaffold(
            body: Center(child: Text("No profile data available.")),
          );
        }
      },
    );
  }
}
