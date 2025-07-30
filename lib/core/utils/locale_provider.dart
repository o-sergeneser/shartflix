import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('tr'); // Varsayılan dil
  Locale get locale => _locale;

  void toggleLocale() {
    if (_locale.languageCode == 'tr') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('tr');
    }
    notifyListeners();
  }
}
