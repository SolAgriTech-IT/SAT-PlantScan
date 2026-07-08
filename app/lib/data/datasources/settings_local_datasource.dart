import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const _languageKey = 'language_code';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String> getLanguageCode() async {
    return _prefs?.getString(_languageKey) ?? 'fr';
  }

  Future<void> setLanguageCode(String code) async {
    await _prefs?.setString(_languageKey, code);
  }
}
