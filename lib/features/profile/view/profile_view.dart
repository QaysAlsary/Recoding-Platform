import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_bloc.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view_body.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';

import '../../../src/components/svg_icon_widget.dart';
import '../../../src/themes/app_icons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffebebeb),
        actions: [
          const Padding(padding: EdgeInsets.only(left: 14)),
          InkWell(
            onTap: () {
              context.pop();
            },
            child: SvgIcon(
              iconTitle: AppIcons.arrow_back,
            ),
          ),
          Expanded(
            child: Center(
              child: LoginFooter(),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              size: 30,
              Icons.notifications_outlined,
              color: Color(0xff9a9a9a),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              size: 30,
              Icons.settings,
              color: Color(0xff9a9a9a),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 14)),
        ],
      ),
      body: ProfileViewBody(),
    );
  }
}
