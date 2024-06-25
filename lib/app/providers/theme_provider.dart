import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //final is
  ThemeData themeData = ThemeData.light();
  void setThemeData(ThemeData themeData) {
    this.themeData = themeData;
    print(themeData.scaffoldBackgroundColor);
    notifyListeners();
  }
}
