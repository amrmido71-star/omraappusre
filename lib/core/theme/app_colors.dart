import 'package:flutter/material.dart';

/// Mirrors the CSS custom properties from rehlaty.html (:root block).
class AppColors {
  AppColors._();

  static const blue = Color(0xFF1A56DB);
  static const blueLight = Color(0xFFEBF2FF);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F8EE);
  static const gold = Color(0xFFF59E0B);
  static const goldDark = Color(0xFFD97706);
  static const bg = Color(0xFFF3F6FB);
  static const text = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE5E9F2);

  /// body background behind the 430px app frame
  static const outerBg = Color(0xFFE2E8F0);

  static const red = Color(0xFFE84040);
  static const purple = Color(0xFF7C3AED);
  static const teal = Color(0xFF0D9488);
  static const emerald = Color(0xFF059669);
  static const sky = Color(0xFF0EA5E9);
  static const violet = Color(0xFF6D28D9);
  static const rose = Color(0xFFE11D48);
  static const cyan = Color(0xFF0284C7);
  static const orange = Color(0xFFC2410C);
  static const whatsapp = Color(0xFF25D366);

  static const vipGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, goldDark],
  );

  static const premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, violet],
  );

  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, Color(0xFF15803D)],
  );

  static const blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue, Color(0xFF0E3A9A)],
  );

  /// Rotating palette used for avatars / provider / company logos.
  static const List<Color> avatarPalette = [
    green,
    goldDark,
    teal,
    blue,
    purple,
    Color(0xFFDC2626),
    emerald,
    violet,
    sky,
    rose,
    cyan,
    orange,
  ];

  static Color avatarColorFor(int seed) =>
      avatarPalette[seed.abs() % avatarPalette.length];
}
