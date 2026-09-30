import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/translations.dart';
import '../../models/design_request.dart';

/// Details of a previously submitted "صمّم عمرتك" wizard request — shows the
/// exact inputs collected by the wizard plus a status tracker. Unlike
/// [OrderDetailSheet] this is not a confirmed booking: no bus/hotel
/// assignment, no price, no "تواصل مع المشرف".
class DesignRequestDetailSheet extends StatelessWidget {
  final UmrahDesignRequest request;
  const DesignRequestDetailSheet({super.key, required this.request});

  static List<(DesignRequestStage, String)> get _stages => [
        (DesignRequestStage.accepted, tr('design.tracker.accepted')),
        (DesignRequestStage.contacted, tr('design.tracker.contacted')),
        (DesignRequestStage.prepared, tr('design.tracker.prepared')),
        (DesignRequestStage.completed, tr('design.tracker.completed')),
      ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      expand: false,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            Center(
                child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                        color: const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(tr('design.detail_title'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text)),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppColors.bg, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const FaIcon(FontAwesomeIcons.xmark,
                        size: 14, color: AppColors.muted)),
              ),
            ]),
            Text('${request.id} · ${request.date}',
                style: const TextStyle(fontSize: 11, color: AppColors.muted)),
            const SizedBox(height: 16),
            _statusTracker(),
            _section(tr('design.step1.title'), FontAwesomeIcons.route, [
              (tr('design.field.start_point'), tr(request.startPoint)),
              (
                tr('design.field.travelers_count'),
                '${request.adults} ${tr('design.unit.adult')}'
              ),
              (
                tr('design.field.makka_days'),
                '${request.makkaDays} ${tr('design.unit.days')}'
              ),
              (
                tr('design.field.madina_days'),
                '${request.madinaDays} ${tr('design.unit.days')}'
              ),
            ]),
            _section(tr('design.step2.title'), FontAwesomeIcons.bed, [
              (tr('design.field.hotel_rating_makkah'), tr(request.hotelStars)),
              (tr('design.field.room_type'), tr(request.roomType)),
              if (request.hotelPrefs.isNotEmpty)
                (
                  tr('design.field.preferences'),
                  request.hotelPrefs.map(tr).join('، ')
                ),
            ]),
            _section(tr('design.step3.title'), FontAwesomeIcons.plane, [
              (tr('design.field.departure_city'), tr(request.departureCity)),
              (tr('design.field.flight_class'), tr(request.flightClass)),
            ]),
            if (request.extraService != null)
              _section(
                  tr('design.section.extra_services'), FontAwesomeIcons.solidStar, [
                (tr('design.field.service'), tr(request.extraService!)),
              ]),
            _section(
                tr('design.section.contact_info'), FontAwesomeIcons.solidUser, [
              (tr('design.hint.full_name'), request.name),
              (tr('design.hint.phone_number'), request.phone),
            ]),
            if (request.notes.isNotEmpty)
              _section(
                  tr('design.section.notes'), FontAwesomeIcons.solidNoteSticky, [
                ('', request.notes),
              ]),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(tr('common.close'),
                      style: const TextStyle(
                          color: AppColors.muted, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusTracker() {
    final currentIndex = _stages.indexWhere((s) => s.$1 == request.stage);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (var i = 0; i < _stages.length; i++)
          _stageRow(_stages[i].$2,
              done: i <= currentIndex, isLast: i == _stages.length - 1),
      ]),
    );
  }

  Widget _stageRow(String label, {required bool done, required bool isLast}) {
    final color = done ? AppColors.green : AppColors.muted;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: done ? AppColors.green : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5)),
          alignment: Alignment.center,
          child: done
              ? const FaIcon(FontAwesomeIcons.check,
                  size: 9, color: Colors.white)
              : null,
        ),
        if (!isLast)
          Container(
              width: 1.5,
              height: 22,
              color: done ? AppColors.green : AppColors.border),
      ]),
      const SizedBox(width: 10),
      Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 1),
        child: Text(label,
            style: TextStyle(
                fontSize: 12.5, fontWeight: FontWeight.w700, color: color)),
      ),
    ]);
  }

  Widget _section(String title, FaIconData icon, List<(String, String)> allRows) {
    final rows = allRows.where((r) => r.$2.trim().isNotEmpty).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          FaIcon(icon, size: 13, color: AppColors.blue),
          const SizedBox(width: 6),
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text))
        ]),
        const SizedBox(height: 10),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: r.$1.isEmpty
                ? Text(r.$2,
                    style:
                        const TextStyle(fontSize: 12.5, color: AppColors.text))
                : Row(children: [
                    Text(r.$1,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(r.$2,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text)),
                    ),
                  ]),
          ),
      ]),
    );
  }
}
