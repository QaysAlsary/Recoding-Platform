import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension WidgetExtensions on Widget {
  Widget center() => Center(
        child: this,
      );

  Widget pOnly(
          {double t = 0.0, double e = 0.0, double b = 0.0, double s = 0.0}) =>
      Padding(
        padding:
            EdgeInsetsDirectional.only(bottom: b, start: s, end: e, top: t),
        child: this,
      );

  Widget pSymmetric({double h = 0.0, double v = 0.0}) => Padding(
        padding: REdgeInsets.symmetric(horizontal: h, vertical: v),
        child: this,
      );

  Widget pAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget size({double? h, double? w}) => SizedBox(
        width: w,
        height: h,
        child: this,
      );
  Widget inkWell(VoidCallback action) => InkWell(
        onTap: action,
        child: this,
      );
}
