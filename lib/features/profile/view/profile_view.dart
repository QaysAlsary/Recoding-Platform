import 'package:flutter/material.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view_body.dart';

import '../../../src/components/svg_icon_widget.dart';
import '../../../src/themes/app_icons.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffebebeb),
        actions: [
          Padding(padding: EdgeInsets.only(left: 14)),
          SvgIcon(
            iconTitle: AppIcons.arrow_back,
          ),
          Expanded(
            child: SizedBox(
              width: 10,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                size: 30,
                Icons.notifications_outlined,
                color: Color(0xff9a9a9a),
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                size: 30,
                Icons.settings,
                color: Color(0xff9a9a9a),
              )),
          Padding(padding: EdgeInsets.only(right: 14)),
        ],
      ),
      body: const ProfileViewBody(),
    );
  }
}
