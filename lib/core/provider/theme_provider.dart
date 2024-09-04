import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class ThemeProvider with ChangeNotifier {
  final prefs = SharedPreferences.getInstance();
  ThemeData _themeData = lightMode;

  ThemeData get themeData {
    return _themeData;
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      saveTheme(false);
    } else {
      themeData = lightMode;
      saveTheme(true);
    }
  }

  void saveTheme(isLight) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme", isLight);
  }

  Future<void> tryGetTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('theme')) {
      _themeData = prefs.getBool("theme") ?? true ? lightMode : darkMode;
    }
    notifyListeners();
  }
}
