import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';

//Example for using it in a screen:
//               InputTextFormField(
//                 controller: TextEditingController(),
//                 hintText: 'Email',
//                 prefixIcon:AppIcons.email,
//                 suffixIcon: AppIcons.eye,
//                 validator: (value) => ValidatorUtils().validatePassword(value!),
//               ),
class OutlineInputTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final double? width; // Width of the field
  final double? height; // Height of the field
  final EdgeInsetsGeometry? margin; // Margin around the field
  final EdgeInsetsGeometry? padding; // Padding inside the field
  final bool obscureText;
  final String? hintText; // Hint text
  // final String? prefixIcon; // Prefix icon
  // final String? suffixIcon; // Suffix icon
  final Icon? icon; // Custom leading
  // icon
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? helper;
  final TextStyle? errorStyle;
  final Widget? counter;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final TextStyle? hintStyle;

  const OutlineInputTextForm(
      {super.key,
      this.controller,
      this.decoration,
      this.width,
      this.height,
      this.margin,
      this.padding,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.icon,
      this.errorStyle,
      this.validator,
      this.keyboardType,
      this.obscureText = false,
      this.counter,
      this.helper,
      this.onChanged,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        cursorColor: AppColors.blue,
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ??
              Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w400),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 18).w,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15).w,
                  child: Icon(
                    prefixIcon,
                    color: Color(0xff999999),
                  ),
                  // SvgIcon(
                  //   w: 43.w,
                  //   h: 43.h,
                  //   iconTitle: prefixIcon!,
                  // ),
                )
              : null,
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 11, right: 15).w,
                  child: Icon(
                    suffixIcon,
                    size: 25,
                    color: Color(0xff999999),
                  ),
                  // SvgIcon(
                  //   w: 32.w,
                  //   h: 32.h,
                  //   iconTitle: suffixIcon!,
                  // ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: Color(0xff999999),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: Color(0xff999999),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: Color(0xff999999),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
