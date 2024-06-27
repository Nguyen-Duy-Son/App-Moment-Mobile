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
            displayLarge: TextStyle(color: Colors.black, fontSize: 57.w, fontWeight: FontWeight.w300),
            displayMedium: TextStyle(color: Colors.black, fontSize: 45.w, fontWeight: FontWeight.w300),
            displaySmall: TextStyle(color: Colors.black, fontSize: 36.w, fontWeight: FontWeight.w300),
            headlineLarge: TextStyle(color: Colors.black, fontSize: 32.w, fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(color: Colors.black, fontSize: 28.w, fontWeight: FontWeight.w700),
            headlineSmall: TextStyle(color: Colors.black, fontSize: 24.w, fontWeight: FontWeight.w700),
            titleLarge: TextStyle(color: Colors.black, fontSize: 22.w, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(color: Colors.black, fontSize: 16.w, fontWeight: FontWeight.w700),
            titleSmall: TextStyle(color: Colors.black, fontSize: 14.w, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(color: Colors.black, fontSize: 14.w, fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(color: Colors.black, fontSize: 12.w, fontWeight: FontWeight.w400),
            bodySmall: TextStyle(color: Colors.black, fontSize: 11.w, fontWeight: FontWeight.w400),
            labelLarge: TextStyle(color: Colors.black, fontSize: 16.w, fontWeight: FontWeight.w300),
            labelMedium: TextStyle(color: Colors.black, fontSize: 14.w, fontWeight: FontWeight.w300),
            labelSmall: TextStyle(color: Colors.black, fontSize: 12.w, fontWeight: FontWeight.w300),
          ),
        ),
      );
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorConstants.primaryDark1,
        appBarTheme: const AppBarTheme(),
        textTheme: GoogleFonts.dongleTextTheme(
          TextTheme(
            displayLarge: TextStyle(color: Colors.white, fontSize: 57.w, fontWeight: FontWeight.w300),
            displayMedium: TextStyle(color: Colors.white, fontSize: 45.w, fontWeight: FontWeight.w300),
            displaySmall: TextStyle(color: Colors.white, fontSize: 36.w, fontWeight: FontWeight.w300),
            headlineLarge: TextStyle(color: Colors.white, fontSize: 32.w, fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(color: Colors.white, fontSize: 28.w, fontWeight: FontWeight.w700),
            headlineSmall: TextStyle(color: Colors.white, fontSize: 24.w, fontWeight: FontWeight.w700),
            titleLarge: TextStyle(color: Colors.white, fontSize: 22.w, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(color: Colors.white, fontSize: 16.w, fontWeight: FontWeight.w700),
            titleSmall: TextStyle(color: Colors.white, fontSize: 14.w, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(color: Colors.white, fontSize: 14.w, fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 12.w, fontWeight: FontWeight.w400),
            bodySmall: TextStyle(color: Colors.white, fontSize: 11.w, fontWeight: FontWeight.w400),
            labelLarge: TextStyle(color: Colors.white, fontSize: 16.w, fontWeight: FontWeight.w300),
            labelMedium: TextStyle(color: Colors.white, fontSize: 14.w, fontWeight: FontWeight.w300),
            labelSmall: TextStyle(color: Colors.white, fontSize: 12.w, fontWeight: FontWeight.w300),
          ),
        ),
      );
}

class ColorThemeExt extends ThemeExtension<ColorThemeExt> {
  const ColorThemeExt({
    required this.primaryColor1,
    required this.primaryColor2,
    required this.primaryColor3,
    required this.primaryColor4,
    required this.primaryColor5,
    required this.primaryColor6,
    required this.primaryColor7,
    required this.primaryColor8,
    required this.primaryColor9,
    required this.primaryColor10,
    required this.primaryColor11,
    required this.primaryColor12,
    required this.neutralColor1,
    required this.neutralColor2,
    required this.neutralColor3,
    required this.neutralColor4,
    required this.neutralColor5,
    required this.neutralColor6,
    required this.neutralColor7,
    required this.neutralColor8,
    required this.neutralColor9,
    required this.neutralColor10,
    required this.neutralColor11,
    required this.neutralColor12,
  });
  final Color primaryColor1;
  final Color primaryColor2;
  final Color primaryColor3;
  final Color primaryColor4;
  final Color primaryColor5;
  final Color primaryColor6;
  final Color primaryColor7;
  final Color primaryColor8;
  final Color primaryColor9;
  final Color primaryColor10;
  final Color primaryColor11;
  final Color primaryColor12;
  final Color neutralColor1;
  final Color neutralColor2;
  final Color neutralColor3;
  final Color neutralColor4;
  final Color neutralColor5;
  final Color neutralColor6;
  final Color neutralColor7;
  final Color neutralColor8;
  final Color neutralColor9;
  final Color neutralColor10;
  final Color neutralColor11;
  final Color neutralColor12;

  @override
  ThemeExtension<ColorThemeExt> copyWith() {
    throw UnimplementedError();
  }

  @override
  ThemeExtension<ColorThemeExt> lerp(covariant ThemeExtension<ColorThemeExt>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}
