import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/translations.dart';
import '../../widgets/sub_page_header.dart';

List<(String, String)> _faqs() => [
      (tr('more_menu.help.faq1_q'), tr('more_menu.help.faq1_a')),
      (tr('more_menu.help.faq2_q'), tr('more_menu.help.faq2_a')),
      (tr('more_menu.help.faq3_q'), tr('more_menu.help.faq3_a')),
      (tr('more_menu.help.faq4_q'), tr('more_menu.help.faq4_a')),
    ];

/// Mirrors `#pg-help`.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _open;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allFaqs = _faqs();
    final q = _query.trim().toLowerCase();
    final faqs = q.isEmpty
        ? allFaqs
        : allFaqs
            .where((f) =>
                f.$1.toLowerCase().contains(q) || f.$2.toLowerCase().contains(q))
            .toList();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: SubPageHeader(title: tr('more_menu.help_center')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.border, width: 1.5),
                borderRadius: BorderRadius.circular(11)),
            child: TextField(
              controller: _searchCtrl,
              textAlign: TextAlign.right,
              onChanged: (v) => setState(() {
                _query = v;
                _open = null;
              }),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: tr('more_menu.help.search_hint'),
                  hintStyle:
                      const TextStyle(color: AppColors.muted, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 14),
          if (faqs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(tr('more_menu.help.search_no_results'),
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 13)),
              ),
            ),
          for (var i = 0; i < faqs.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Column(children: [
                InkWell(
                  onTap: () => setState(() => _open = _open == i ? null : i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(faqs[i].$1,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.text))),
                          AnimatedRotation(
                              turns: _open == i ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.keyboard_arrow_down,
                                  size: 18, color: AppColors.muted)),
                        ]),
                  ),
                ),
                if (_open == i)
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 13),
                    decoration: const BoxDecoration(
                        border:
                            Border(top: BorderSide(color: AppColors.border))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(faqs[i].$2,
                          style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.muted,
                              height: 1.7)),
                    ),
                  ),
              ]),
            ),
        ],
      ),
    );
  }
}
