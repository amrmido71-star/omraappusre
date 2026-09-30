import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/sub_page_header.dart';
import '../../widgets/legal_section.dart';
import '../../l10n/translations.dart';

/// Mirrors `#pg-about`.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: SubPageHeader(title: tr('legal.about.title_page')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              Image.asset('assets/images/omraway_kaaba.png',
                  width: 96, fit: BoxFit.contain),
              const SizedBox(height: 14),
              Text(tr('legal.about.app_name'),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text)),
              Text(tr('legal.about.version'),
                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            ]),
          ),
          LegalSection(
              icon: FontAwesomeIcons.solidStar,
              title: tr('legal.about.who_we_are.title'),
              text: tr('legal.about.who_we_are.body')),
          LegalSection(
              icon: FontAwesomeIcons.bullseye,
              title: tr('legal.about.vision.title'),
              text: tr('legal.about.vision.body')),
          LegalSection(
              icon: FontAwesomeIcons.solidHeart,
              title: tr('legal.about.values.title'),
              bullets: [
                tr('legal.about.values.bullet1'),
                tr('legal.about.values.bullet2'),
                tr('legal.about.values.bullet3'),
                tr('legal.about.values.bullet4'),
              ]),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(14)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const FaIcon(FontAwesomeIcons.chartLine,
                    size: 14, color: AppColors.blue),
                const SizedBox(width: 7),
                Text(tr('legal.about.stats_title'),
                    style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text))
              ]),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
                children: [
                  _Stat('+٢٠٠', tr('legal.about.stat_companies_label')),
                  _Stat('+١٠K', tr('legal.about.stat_travelers_label')),
                  _Stat('+٥٠٠', tr('legal.about.stat_trips_label')),
                  _Stat('٤.٨', tr('legal.about.stat_rating_label')),
                ],
              ),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                  child: Text(tr('legal.about.copyright'),
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.muted)))),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String num;
  final String label;
  const _Stat(this.num, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(num,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.blue)),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600)),
          ]),
    );
  }
}
