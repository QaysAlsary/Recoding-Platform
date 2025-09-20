import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view_body.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

import '../../../src/components/svg_icon_widget.dart';
import '../../../src/themes/app_icons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      endDrawer: const SettingsDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          const Padding(padding: EdgeInsets.only(left: 14)),
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              context.go(Routes.home);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgIcon(
                iconTitle: AppIcons.arrow_back,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: LoginFooter(),
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              // TODO: Implement notifications
            },
            icon: const Icon(
              size: 30,
              Icons.notifications_outlined,
              color: Color(0xff9a9a9a),
            ),
            tooltip: 'Notifications',
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                size: 30,
                Icons.settings,
                color: Color(0xff9a9a9a),
              ),
              tooltip: 'Settings',
            );
          }),
          const Padding(padding: EdgeInsets.only(right: 14)),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: ProfileViewBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
