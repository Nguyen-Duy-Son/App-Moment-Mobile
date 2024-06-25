import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';

class ThemeConfig {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: ColorConstants.primaryLight1,
        textTheme: GoogleFonts.dongleTextTheme(),
      );
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorConstants.primaryDark1,
        textTheme: GoogleFonts.dongleTextTheme(),
      );
}
