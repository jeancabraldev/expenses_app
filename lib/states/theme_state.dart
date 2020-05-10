import 'package:flutter/material.dart';

class ThemeState with ChangeNotifier {
  bool _isDarkModeEnabled;

  ThemeData get currentTheme =>
      _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light();

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void setDarkMode(bool b) {
    _isDarkModeEnabled = b;
    notifyListeners();
  }
}
