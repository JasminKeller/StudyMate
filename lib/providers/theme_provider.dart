import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../theme/theme.dart';

// to manually change the dark and light Mode

class ThemeProvider with ChangeNotifier {
  bool _darkMode;

  ThemeProvider(this._darkMode);

  ThemeData get themeData => _darkMode ? darkMode : lightMode;

  bool get isDarkMode => _darkMode;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
    Hive.box('settings').put('darkMode', _darkMode);
    if (kDebugMode) {
      print('Dark Mode Value: $_darkMode');
      print('Dark Mode Hive Box: ${Hive.box('settings').get('darkMode')}');
    }

  }
}


