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
      colorScheme: colorScheme,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),
      inputDecorationTheme: inputDecorationTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      cardTheme: cardTheme,
      appBarTheme: appBarTheme,
      scaffoldBackgroundColor: Colors.grey.shade50,
    );

ColorScheme get colorScheme => ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.blue,
      surface: Colors.white,
      background: Colors.grey.shade50,
      error: Colors.red.shade600,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.black,
      onBackground: AppColors.black,
      onError: Colors.white,
    );

InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14.sp,
      ),
      errorStyle: TextStyle(
        color: Colors.red.shade600,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );

ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

CardThemeData get cardTheme => CardThemeData(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );

AppBarTheme get appBarTheme => AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.1),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: AppColors.black,
        size: 24.sp,
      ),
    );

TextTheme get textTheme => TextTheme(
      displayLarge: TextStyle(
        fontSize: 38.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      headlineLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      titleSmall: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      labelLarge: TextStyle(
        fontSize: 18.sp,
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      labelMedium: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      labelSmall: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black,
      ),
    );
