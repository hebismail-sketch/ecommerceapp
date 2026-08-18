import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  AppSettings();

  ThemeMode _themeMode = ThemeMode.light;

  Locale _locale = const Locale('ar');

  bool _notificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;

  Locale get locale => _locale;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString('themeMode');

    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    final language = prefs.getString('languageCode');

    if (language != null) {
      _locale = Locale(language);
    }

    _notificationsEnabled =
        prefs.getBool('notificationsEnabled') ?? true;

    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'themeMode',
      mode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'languageCode',
      languageCode,
    );

    notifyListeners();
  }

  Future<void> changeNotifications(bool value) async {
    _notificationsEnabled = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'notificationsEnabled',
      value,
    );

    notifyListeners();
  }
}