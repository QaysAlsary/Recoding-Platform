import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/edit_profile_col.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/security_col.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/toggle_taps.dart';

import '../../../src/components/svg_icon_widget.dart';
import '../../../src/themes/app_icons.dart';
import '../bloc/profile_bloc.dart';
import '../../../../src/components/auth_button.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SafeArea(
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
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/prof.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: SvgIcon(iconTitle: AppIcons.penInCircle),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jehad Alghamyan",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Text(
                              "jegh505@gmail.com",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Text(
                              "Volunteer, Public Health",
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
                  if (state is EditProfileState) const EditProfileColumn(),
                  if (state is SecurityState) const SecurityColumn(),
                  AuthButton(
                    onPressed: () {},
                    text: "Save Changes",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
