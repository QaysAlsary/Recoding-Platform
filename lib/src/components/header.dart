import 'package:flutter/material.dart';
import 'package:recoding_platform_project/src/themes/app_images.dart';

class Header extends StatelessWidget {
  final String? headerText;

  const Header({super.key, this.headerText});

  @override
  Widget build(BuildContext context)  {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.3,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            AppImages.header,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: screenHeight * 0.07,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                headerText ?? '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
