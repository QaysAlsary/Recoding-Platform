import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_event.dart';
import 'enum_toggle_tabs_type.dart';

class ToggleTabs extends StatelessWidget {
  const ToggleTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select<ToggleBloc, ToggleTabType>(
      (bloc) => bloc.state.selectedTab,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: selectedTab == ToggleTabType.editProfile
                    ? const Color(0xff6ab3d9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: selectedTab == ToggleTabType.editProfile
                    ? [
                        BoxShadow(
                          color: const Color(0xff6ab3d9).withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24.r),
                onTap: () => context
                    .read<ToggleBloc>()
                    .add(const TabSelected(ToggleTabType.editProfile)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 22.sp,
                        color: selectedTab == ToggleTabType.editProfile
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedTab == ToggleTabType.editProfile
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: selectedTab == ToggleTabType.security
                    ? const Color(0xff6ab3d9)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: selectedTab == ToggleTabType.security
                    ? [
                        BoxShadow(
                          color: const Color(0xff6ab3d9).withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24.r),
                onTap: () => context
                    .read<ToggleBloc>()
                    .add(const TabSelected(ToggleTabType.security)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 22.sp,
                        color: selectedTab == ToggleTabType.security
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Security",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedTab == ToggleTabType.security
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
