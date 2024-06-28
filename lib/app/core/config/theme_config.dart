// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/constants/text_style_constants.dart';

class ThemeConfig {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        extensions: [
          ColorConstants.colorThemeLightExt,
          TextStyleConstant.textStyleLightExt,
        ],
        scaffoldBackgroundColor: ColorConstants.primaryLight10,
        appBarTheme: const AppBarTheme(),
        textTheme: GoogleFonts.dongleTextTheme(
          TextTheme(
            displayLarge: TextStyle(color: ColorConstants.neutralLight120, fontSize: 57.w, fontWeight: FontWeight.w300),
            displayMedium: TextStyle(color: ColorConstants.neutralLight120, fontSize: 45.w, fontWeight: FontWeight.w300),
            displaySmall: TextStyle(color: ColorConstants.neutralLight120, fontSize: 36.w, fontWeight: FontWeight.w300),
            headlineLarge: TextStyle(color: ColorConstants.neutralLight120, fontSize: 32.w, fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(color: ColorConstants.neutralLight120, fontSize: 28.w, fontWeight: FontWeight.w700),
            headlineSmall: TextStyle(color: ColorConstants.neutralLight120, fontSize: 24.w, fontWeight: FontWeight.w700),
            titleLarge: TextStyle(color: ColorConstants.neutralLight120, fontSize: 22.w, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(color: ColorConstants.neutralLight120, fontSize: 16.w, fontWeight: FontWeight.w700),
            titleSmall: TextStyle(color: ColorConstants.neutralLight120, fontSize: 14.w, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(color: ColorConstants.neutralLight120, fontSize: 14.w, fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(color: ColorConstants.neutralLight120, fontSize: 12.w, fontWeight: FontWeight.w400),
            bodySmall: TextStyle(color: ColorConstants.neutralLight120, fontSize: 11.w, fontWeight: FontWeight.w400),
            labelLarge: TextStyle(color: ColorConstants.neutralLight120, fontSize: 16.w, fontWeight: FontWeight.w300),
            labelMedium: TextStyle(color: ColorConstants.neutralLight120, fontSize: 14.w, fontWeight: FontWeight.w300),
            labelSmall: TextStyle(color: ColorConstants.neutralLight120, fontSize: 12.w, fontWeight: FontWeight.w300),
          ),
        ),
      );
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        extensions: [
          ColorConstants.colorThemeDarkExt,
          TextStyleConstant.textStyleDarkExt,
        ],
        scaffoldBackgroundColor: ColorConstants.primaryDark10,
        appBarTheme: const AppBarTheme(),
        textTheme: GoogleFonts.dongleTextTheme(
          TextTheme(
            displayLarge: TextStyle(color: ColorConstants.neutralDark120, fontSize: 57.w, fontWeight: FontWeight.w300),
            displayMedium: TextStyle(color: ColorConstants.neutralDark120, fontSize: 45.w, fontWeight: FontWeight.w300),
            displaySmall: TextStyle(color: ColorConstants.neutralDark120, fontSize: 36.w, fontWeight: FontWeight.w300),
            headlineLarge: TextStyle(color: ColorConstants.neutralDark120, fontSize: 32.w, fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(color: ColorConstants.neutralDark120, fontSize: 28.w, fontWeight: FontWeight.w700),
            headlineSmall: TextStyle(color: ColorConstants.neutralDark120, fontSize: 24.w, fontWeight: FontWeight.w700),
            titleLarge: TextStyle(color: ColorConstants.neutralDark120, fontSize: 22.w, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(color: ColorConstants.neutralDark120, fontSize: 16.w, fontWeight: FontWeight.w700),
            titleSmall: TextStyle(color: ColorConstants.neutralDark120, fontSize: 14.w, fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(color: ColorConstants.neutralDark120, fontSize: 14.w, fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(color: ColorConstants.neutralDark120, fontSize: 12.w, fontWeight: FontWeight.w400),
            bodySmall: TextStyle(color: ColorConstants.neutralDark120, fontSize: 11.w, fontWeight: FontWeight.w400),
            labelLarge: TextStyle(color: ColorConstants.neutralDark120, fontSize: 16.w, fontWeight: FontWeight.w300),
            labelMedium: TextStyle(color: ColorConstants.neutralDark120, fontSize: 14.w, fontWeight: FontWeight.w300),
            labelSmall: TextStyle(color: ColorConstants.neutralDark120, fontSize: 12.w, fontWeight: FontWeight.w300),
          ),
        ),
      );
}
