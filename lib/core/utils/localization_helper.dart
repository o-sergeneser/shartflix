import 'package:flutter/material.dart';

String getText(BuildContext context, String tr, String en) {
  Locale locale = Localizations.localeOf(context);
  return locale.languageCode == 'tr' ? tr : en;
}
