import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';

//Example for using it in a screen:
//            AuthButton(
//                 text: 'Login',
//                 onPressed: {},
//               )
class RoundedRectangleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? buttonWidth;
  final double? buttonHeight;
  final bool clickable;
  final ButtonStyle? buttonStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final String text;
  final TextStyle? textStyle;

  const RoundedRectangleButton({
    required this.onPressed,
    required this.text,
    this.clickable = true,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonStyle,
    this.boxDecoration,
    this.padding,
    this.margin,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: buttonHeight ?? 57.h,
      margin: margin,
      padding: padding,
      decoration: boxDecoration,
      child: ElevatedButton(
        onPressed: clickable ? onPressed : null,
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.black073,
              elevation: 0,
              overlayColor: Colors.blue,
              shadowColor: Colors.transparent,
              side: const BorderSide(color: AppColors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: textStyle ??
                  Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue),
            ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xff66b1d7),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
