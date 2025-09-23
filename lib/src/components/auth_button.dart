import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/app_colors.dart';

//Example for using it in a screen:
//            AuthButton(
//                 text: 'Login',
//                 onPressed: {},
//               )
class AuthButton extends StatefulWidget {
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
  final Color? backGroundColor;
  final Color? textColor;
  final bool? sideBar;

  const AuthButton({
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
    this.backGroundColor,
    this.textColor,
    this.sideBar,
    super.key,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.clickable;
    final backgroundColor = isEnabled
        ? (widget.backGroundColor ?? Colors.transparent)
        : Colors.grey.shade300;
    final textColor =
        isEnabled ? (widget.textColor ?? Colors.black) : Colors.grey.shade600;

    return Container(
      width: widget.buttonWidth ?? 321.w,
      height: widget.buttonHeight ?? 50.h,
      margin: widget.margin,
      padding: widget.padding,
      decoration: widget.boxDecoration,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: isEnabled ? _handleTapDown : null,
              onTapUp: isEnabled ? _handleTapUp : null,
              onTapCancel: isEnabled ? _handleTapCancel : null,
              child: ElevatedButton(
                onPressed: isEnabled ? widget.onPressed : null,
                style: widget.buttonStyle ??
                    ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      foregroundColor: AppColors.black073,
                      elevation: _isPressed ? 2 : 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                      side: widget.sideBar == true
                          ? BorderSide(color: AppColors.blue, width: 2)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                child: Text(
                  widget.text,
                  style: widget.textStyle ??
                      Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
