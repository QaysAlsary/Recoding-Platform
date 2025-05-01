import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String iconTitle;
  final Color? color;
  final double? h;
  final double? w;
  final bool isDierctional;

  const SvgIcon({
    super.key,
    required this.iconTitle,
    this.color,
    this.h,
    this.w,
    this.isDierctional = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconTitle,
      height: h,
      width: w,
      matchTextDirection: isDierctional,
      color: color,
    );
  }
}
