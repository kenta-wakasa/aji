import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/preferences.dart';

final themeProvider = ChangeNotifierProvider<ThemeProvider>(
  (ref) => ThemeProvider._(),
);

class ThemeProvider extends ChangeNotifier {
  ThemeProvider._() {
    init();
  }
  ThemeMode _mode;
  Color mainColor;
  ThemeData themeData;
  ThemeData themeDataLight;
  ThemeData themeDataDark;
  AppBarTheme appBarTheme;
  TextTheme textTheme;

  ThemeMode get mode => _mode;

  void init() {
    _mode = Preferences.instance.themeMode;
    mainColor = Colors.lightBlue[700];
    appBarTheme = AppBarTheme(
      foregroundColor: mainColor,
      backgroundColor: ThemeData().scaffoldBackgroundColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: mainColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      elevation: 0.4,
      iconTheme: IconThemeData(color: mainColor),
    );

    textTheme = const TextTheme(
        headline6: TextStyle(
      fontWeight: FontWeight.bold,
    ));

    themeDataLight = ThemeData(
      primaryColor: mainColor,
      accentColor: mainColor,
      appBarTheme: appBarTheme,
      textTheme: textTheme,
    );
    themeDataDark = ThemeData(
      primaryColor: mainColor,
      accentColor: mainColor,
      appBarTheme: appBarTheme.copyWith(
        backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
        shadowColor: Colors.white,
      ),
      textTheme: textTheme,
      brightness: Brightness.dark,
    );
  }

  void switchThemeMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    await Preferences.instance.setThemeMode(mode);
    _mode = mode;
    notifyListeners();
  }

  String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'システム設定';
      case ThemeMode.light:
        return 'ライトモード';
      case ThemeMode.dark:
        return 'ダークモード';
    }
    return null;
  }
}
