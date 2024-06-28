import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/constants/text_style_constants.dart';

class AppColors {
  static ColorThemeExt of(BuildContext context) {
    return Theme.of(context).extension<ColorThemeExt>()!;
  }
}

class AppTextStyles {
  static TextStyleExt of(BuildContext context) {
    return Theme.of(context).extension<TextStyleExt>()!;
  }
}
