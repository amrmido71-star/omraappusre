import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme/app_colors.dart';

/// Mirrors `.terms-sec` — a titled card of body text and/or bullet list,
/// reused by the Terms, Privacy and About pages.
class LegalSection extends StatelessWidget {
  final FaIconData icon;
  final String title;
  final String? text;
  final List<String>? bullets;
  const LegalSection(
      {super.key,
      required this.icon,
      required this.title,
      this.text,
      this.bullets});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          FaIcon(icon, size: 14, color: AppColors.blue),
          const SizedBox(width: 7),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text))),
        ]),
        const SizedBox(height: 10),
        if (text != null)
          Text(text!,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.muted, height: 1.8)),
        if (bullets != null)
          Padding(
            padding: EdgeInsets.only(top: text != null ? 8 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final b in bullets!)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text('•',
                                  style: TextStyle(
                                      color: AppColors.blue,
                                      fontWeight: FontWeight.w900))),
                          const SizedBox(width: 6),
                          Expanded(
                              child: Text(b,
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.muted,
                                      height: 1.7))),
                        ]),
                  ),
              ],
            ),
          ),
      ]),
    );
  }
}
