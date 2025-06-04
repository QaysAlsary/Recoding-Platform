import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/profile_bloc.dart';
import '../../../../src/components/svg_icon_widget.dart';
import '../../../../src/themes/app_icons.dart';
import '../../../../src/themes/app_theme.dart';
import 'enum_toggle_tabs_type.dart';

class ToggleTabs extends StatelessWidget {
  const ToggleTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((ProfileBloc bloc) => bloc.state.selectedTab);

    return Row(
      children: [
        GestureDetector(
          onTap: () => context
              .read<ProfileBloc>()
              .add(const TabSelected(ToggleTabType.editProfile)),
          child: Row(
            children: [
              Opacity(
                opacity: selectedTab == ToggleTabType.editProfile ? 1.0 : 0.5,
                child: Icon(
                  size: 25,
                  Icons.edit_outlined,
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                "Edit Profile",
                style: appTheme.textTheme.labelLarge?.copyWith(
                  fontSize:
                      selectedTab == ToggleTabType.editProfile ? 22.sp : 18.sp,
                  color: appTheme.textTheme.labelLarge!.color!.withOpacity(
                    selectedTab == ToggleTabType.editProfile ? 1.0 : 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => context
              .read<ProfileBloc>()
              .add(const TabSelected(ToggleTabType.security)),
          child: Row(
            children: [
              Opacity(
                  opacity: selectedTab == ToggleTabType.security ? 1.0 : 0.5,
                  child: Icon(
                    size: 25,
                    Icons.lock_outlined,
                  )),
              SizedBox(
                width: 6.w,
              ),
              Text(
                "Security",
                style: appTheme.textTheme.labelLarge?.copyWith(
                  fontSize:
                      selectedTab == ToggleTabType.security ? 22.sp : 18.sp,
                  color: appTheme.textTheme.labelLarge!.color!.withOpacity(
                    selectedTab == ToggleTabType.security ? 1.0 : 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
