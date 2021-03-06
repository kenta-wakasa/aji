import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();
  static late Preferences instance;
  late SharedPreferences _pref;

  static Future<void> init() async {
    instance = Preferences._();
    instance._pref = await SharedPreferences.getInstance();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = mode.toString().split('.').last;
    await _pref.setString(key(PrefKey.themeMode), value);
  }

  ThemeMode get themeMode {
    final value = _pref.getString(key(PrefKey.themeMode));
    switch (value) {
      case 'system':
        return ThemeMode.system;
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  String key(PrefKey key) {
    return key.toString().split('.').last;
  }
}

enum PrefKey {
  themeMode,
}
