import 'package:flutter/material.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';
import 'package:recoding_platform_project/src/components/svg_icon_widget.dart';
import 'package:recoding_platform_project/src/themes/app_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    this.onBackPressed,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xffebebeb),
      actions: [
        const Padding(padding: EdgeInsets.only(left: 14)),
        if (showBackButton)
          InkWell(
            onTap: onBackPressed ?? () => Navigator.of(context).pop(),
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
        Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: const Icon(
              size: 30,
              Icons.settings,
              color: Color(0xff9a9a9a),
            ),
          );
        }),
        const Padding(padding: EdgeInsets.only(right: 14)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
































