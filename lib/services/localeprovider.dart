import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar'); // default Sorani

  Locale get locale => _locale;
  LocaleProvider() {
    _loadLocale(); // Load saved language on startup
  }
  void setEnglish() async {
    _locale = const Locale('en', 'US');
    notifyListeners();
    await _saveLocale('en');
  }

  void setKurdish() async {
    _locale = const Locale('ar');
    notifyListeners();
    await _saveLocale('ar');
  }

  Future<void> _saveLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');

    if (langCode != null) {
      if (langCode == 'en') {
        _locale = const Locale('en', 'US');
      } else if (langCode == 'ckb') {
        _locale = const Locale('ckb');
      } else {
        _locale = Locale(langCode);
      }
      notifyListeners();
    }
  }
}
