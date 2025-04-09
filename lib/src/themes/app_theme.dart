import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recoding_platform_project/src/utils/extensions.dart';

import 'app_colors.dart';

ThemeData get appTheme => ThemeData(
      primarySwatch: AppColors.primary.toMaterialColor(),
      brightness: Brightness.light,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      textTheme: textTheme,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),
    );

TextTheme get textTheme => TextTheme(
      displayLarge: TextStyle(
        fontSize: 38.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 25.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      labelLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      titleMedium: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 40.sp,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: Color(0xff9E4D20),
      ),
    );
