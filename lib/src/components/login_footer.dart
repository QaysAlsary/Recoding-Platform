import 'package:flutter/cupertino.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';

class LoginFooter extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? width;
  const LoginFooter({super.key, this.padding, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.only(right: 25, left: 26, bottom: 10),
      child: Image.asset(
        AppImages.login_footer,
        width: width ?? double.infinity,
        // height: height ??,
        fit: BoxFit.fill,
      ),
    );
  }
}
