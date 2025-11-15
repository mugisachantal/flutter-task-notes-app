import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyIsDark = 'isDarkMode';

  static Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDark) ?? false;
  }

  static Future<void> setIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, value);
  }
}
