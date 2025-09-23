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
class InputTextFormField extends StatefulWidget {
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
  final TextStyle? hintStyle;
  final bool? enabled;
  final int? maxLines;
  final TextStyle? textStyle;

  const InputTextFormField({
    super.key,
    this.enabled = true,
    this.controller,
    this.textStyle,
    this.maxLines = 1,
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
    this.hintStyle,
  });

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 322.56.w,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            validator: widget.validator,
            cursorColor: AppColors.blue,
            style: widget.textStyle ?? Theme.of(context).textTheme.labelMedium,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ??
                  Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade500,
                      ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              prefixIcon: widget.prefixIcon ??
                  (widget.prefixIconIcon != null
                      ? Icon(
                          widget.prefixIconIcon,
                          size: 30,
                          color: _focusNode.hasFocus
                              ? AppColors.blue
                              : Colors.black.withOpacity(0.45),
                        )
                      : null),
              suffixIcon: widget.suffixIcon ??
                  (widget.suffixIconIcon != null
                      ? Icon(
                          widget.suffixIconIcon,
                          size: 30,
                          color: _focusNode.hasFocus
                              ? AppColors.blue
                              : Colors.black.withOpacity(0.45),
                        )
                      : null),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 3.73,
                  color: AppColors.black015,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 3.73,
                  color: AppColors.black015,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 3.73,
                  color: AppColors.blue,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 3.73,
                  color: Colors.red.shade400,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 3.73,
                  color: Colors.red.shade600,
                ),
              ),
              errorStyle: widget.errorStyle ??
                  TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          );
        },
      ),
    );
  }
}
