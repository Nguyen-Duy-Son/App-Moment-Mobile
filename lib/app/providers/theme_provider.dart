import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/config/theme_config.dart';

class ThemeProvider extends ChangeNotifier {
  //final is
  ThemeData themeData = ThemeConfig.lightTheme;
  void setThemeData(ThemeData themeData) {
    this.themeData = themeData;
    print(themeData.scaffoldBackgroundColor);
    notifyListeners();
  }
}
