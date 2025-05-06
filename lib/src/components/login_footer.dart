import 'package:flutter/cupertino.dart';
import 'package:recoding_platform_project/src/constants/image_paths.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 26, bottom: 10),
      child: Image.asset(
        AppImages.login_footer,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}
