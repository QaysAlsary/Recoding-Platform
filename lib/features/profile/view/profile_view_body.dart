import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/edit_profile_col.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/security_col.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/toggle_taps.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';

import '../bloc/profile_bloc.dart';

class ProfileViewBody extends StatelessWidget {
  ProfileViewBody({super.key});

  final TextEditingController name = TextEditingController();
  final TextEditingController currentPasswordSecurity = TextEditingController();
  final TextEditingController currentPassword = TextEditingController();

  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirm = TextEditingController();
  final TextEditingController email = TextEditingController();

  void clearSecurityTextControllers() {
    currentPasswordSecurity.clear();
    newPassword.clear();
    newPasswordConfirm.clear();
  }

  void clearUserInfoTextControllers() {
    name.clear();
    email.clear();
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileLoadSuccessState) {
          final profileImageUrl = state.profileResponse.user.profile_image;

          return BlocProvider<ToggleBloc>(
            create: (context) => ToggleBloc(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 19.h),
                    Row(
                      children: [
                        SizedBox(width: 19.w),
                        Stack(
                          children: [
                            SizedBox(
                              width: 100.r,
                              height: 100.r,
                              child: InkWell(
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final image = await picker.pickImage(
                                      source: ImageSource.gallery);

                                  if (image != null) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(UpdateProfilePic(image: image));
                                  }
                                },
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: profileImageUrl != null &&
                                            profileImageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: profileImageUrl,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/prof.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 23,
                                height: 23,
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    size: 18,
                                    color: Color(0xffadadad),
                                    Icons.edit_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.profileResponse.user.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                state.profileResponse.user.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              Text(
                                '${state.profileResponse.user.position}, ${state.profileResponse.user.department}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      color: const Color(0xffe1e1e1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 21, horizontal: 25),
                      child: const ToggleTabs(),
                    ),
                    SizedBox(height: 22.h),
                    BlocBuilder<ToggleBloc, ToggleState>(
                      builder: (context, toggleState) {
                        if (toggleState is EditProfileState) {
                          clearSecurityTextControllers();
                          return EditProfileColumn(
                            email: email,
                            name: name,
                            password: currentPassword,
                            isObscured: toggleState.isObscured,
                          );
                        } else if (toggleState is SecurityState) {
                          clearUserInfoTextControllers();
                          return SecurityColumn(
                            currentPassword: currentPasswordSecurity,
                            newPassword: newPassword,
                            newPasswordConfirm: newPasswordConfirm,
                            isObscured: toggleState.isObscured,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
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
