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
class InputTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final double? width; // Width of the field
  final double? height; // Height of the field
  final EdgeInsetsGeometry? margin; // Margin around the field
  final EdgeInsetsGeometry? padding; // Padding inside the field
  final bool obscureText;
  final String? hintText; // Hint text
  final Widget? prefixIcon; // Prefix icon
  final Widget? suffixIcon; // Suffix icon
  final Widget? icon; // Custom leading icon
  final Widget? helper;
  final TextStyle? errorStyle;
  final Widget? counter;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final IconData? prefixIconIcon;
  final IconData? suffixIconIcon;

  InputTextFormField({
    super.key,
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
    this.prefixIconIcon,
    this.suffixIconIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 322.56.w,
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
          hintStyle: Theme.of(context).textTheme.labelMedium,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          prefixIcon: Icon(
            prefixIconIcon,
            size: 30,
            color: Colors.black.withOpacity(0.45),
          )

          // ?? Padding(
          //   padding: const EdgeInsets.only(left: 5, right: 11).w,
          //   child: SvgIcon(
          //     w: 43.w,
          //     h: 43.h,
          //     iconTitle: prefixIcon!,
          //   ),
          // ) ??
          // null
          ,
          suffixIcon: suffixIcon ??
              Icon(
                suffixIconIcon,
                size: 30,
                color: Colors.black.withOpacity(0.45),
              ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3.73,
              color: AppColors.black015,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3.73,
              color: AppColors.black015,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: 3.73,
              color: AppColors.black015,
            ),
          ),
        ),
      ),
    );
  }
}
