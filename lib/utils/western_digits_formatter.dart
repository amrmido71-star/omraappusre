import 'package:flutter/services.dart';

/// Numeric fields (OTP codes, document numbers) must always show/store
/// plain Western digits with no invisible directional marks — an Arabic
/// keyboard on an RTL-locale device commonly does two things that break a
/// digit box: (1) types Eastern Arabic-Indic digits (٠١٢٣...) instead of
/// 0-9, and (2) silently inserts an invisible bidi control character
/// (e.g. U+061C Arabic Letter Mark, or a right-to-left mark/embedding)
/// alongside the digit. That second one is the nastier bug: the stored
/// character is a perfectly normal "2"/"3"/"4", but Flutter's text
/// painter still renders it with RTL glyph shaping because of the
/// invisible mark sitting next to it — showing up as a horizontally
/// *mirrored* digit (reported by a user: "2"/"3"/"4" rendering backwards)
/// even though nothing in the field's own configured `Directionality`
/// looks wrong. Stripping every bidi/format control character fixes this
/// regardless of what the keyboard silently injects.
class WesternDigitsFormatter extends TextInputFormatter {
  static const _easternArabic = '٠١٢٣٤٥٦٧٨٩';
  static const _extendedArabic = '۰۱۲۳۴۵۶۷۸۹';

  /// Zero-width/format & bidi control characters that must never survive
  /// into a numeric field's stored text (ZWSP/ZWNJ/ZWJ, LRM/RLM, the
  /// explicit embed/override/isolate controls, and the Arabic Letter Mark).
  /// Built from bare code points (not escape sequences in a string
  /// literal) so the source file itself never embeds an actual
  /// bidi-control character.
  static final _invisibleControls = RegExp(
    '[${[
      for (var c = 0x200B; c <= 0x200F; c++) c,
      for (var c = 0x202A; c <= 0x202E; c++) c,
      for (var c = 0x2066; c <= 0x2069; c++) c,
      0x061C,
    ].map((c) => String.fromCharCode(c)).join()}]',
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final buffer = StringBuffer();
    for (final ch in newValue.text.replaceAll(_invisibleControls, '').split('')) {
      final eastern = _easternArabic.indexOf(ch);
      final extended = _extendedArabic.indexOf(ch);
      if (eastern != -1) {
        buffer.write(eastern);
      } else if (extended != -1) {
        buffer.write(extended);
      } else {
        buffer.write(ch);
      }
    }
    final converted = buffer.toString();
    if (converted == newValue.text) return newValue;
    return newValue.copyWith(
      text: converted,
      selection: TextSelection.collapsed(offset: converted.length),
    );
  }
}
