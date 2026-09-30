import 'package:flutter/material.dart';

/// Mirrors [AppState]'s static-ValueNotifier idiom — the single source of
/// truth for the app's active language, read by MaterialApp/Directionality
/// in main.dart and by every tr() call.
class LocaleState {
  LocaleState._();

  static const supportedLocales = [
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('tr'),
    Locale('id'),
    Locale('ur'),
    Locale('ms'),
  ];

  static const rtlLocales = {'ar', 'ur'};

  static const nativeNames = {
    'ar': 'العربية',
    'en': 'English',
    'fr': 'Français',
    'tr': 'Türkçe',
    'id': 'Bahasa Indonesia',
    'ur': 'اردو',
    'ms': 'Bahasa Melayu',
  };

  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('ar'));
}
