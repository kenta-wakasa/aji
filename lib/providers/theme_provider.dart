import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/preferences.dart';

final themeProvider = ChangeNotifierProvider<ThemeProvider>(
  (ref) => ThemeProvider._(),
);

class ThemeProvider extends ChangeNotifier {
  ThemeProvider._() {
    _init();
  }
  Color mainColor = Colors.lightBlue[700]!;
  late ThemeData themeDataLight;
  late ThemeData themeDataDark;
  late AppBarTheme appBarTheme;
  late TextTheme textTheme;

  ThemeMode get mode => Preferences.instance.themeMode;

  void _init() {
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



  Future<void> updateThemeMode(ThemeMode? mode) async {
    await Preferences.instance.setThemeMode(mode!);
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
  }
}
