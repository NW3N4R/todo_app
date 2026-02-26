import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar'); // default Sorani

  Locale get locale => _locale;

  void setEnglish() {
    _locale = const Locale('en', 'US');
    notifyListeners();
  }

  void setKurdish() {
    _locale = const Locale('ar');
    notifyListeners();
  }
}
