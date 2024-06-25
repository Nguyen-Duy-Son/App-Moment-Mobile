// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';

class ThemeConfig {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: ColorConstants.primaryLight1,
        appBarTheme: const AppBarTheme(),
        textTheme: GoogleFonts.dongleTextTheme(
          TextTheme(
            displayLarge: TextStyle(color: Colors.black),
            displayMedium: TextStyle(color: Colors.black),
            displaySmall: TextStyle(color: Colors.black),
            headlineLarge: TextStyle(color: Colors.black, fontSize: 40.w),
            headlineMedium: TextStyle(color: Colors.black),
            headlineSmall: TextStyle(color: Colors.black),
            titleLarge: TextStyle(color: Colors.black),
            titleMedium: TextStyle(color: Colors.black),
            titleSmall: TextStyle(color: Colors.black),
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black),
            labelLarge: TextStyle(color: Colors.black),
            labelMedium: TextStyle(color: Colors.black),
            labelSmall: TextStyle(color: Colors.black),
          ),
        ),
      );
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorConstants.primaryDark1,
        appBarTheme: const AppBarTheme(),
        textTheme: GoogleFonts.dongleTextTheme(
          TextTheme(
            displayLarge: TextStyle(color: Colors.white),
            displayMedium: TextStyle(color: Colors.white),
            displaySmall: TextStyle(color: Colors.white),
            headlineLarge: TextStyle(color: Colors.white, fontSize: 40.w),
            headlineMedium: TextStyle(color: Colors.white),
            headlineSmall: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleSmall: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodySmall: TextStyle(color: Colors.white),
            labelLarge: TextStyle(color: Colors.white),
            labelMedium: TextStyle(color: Colors.white),
            labelSmall: TextStyle(color: Colors.white),
          ),
        ),
      );
}
