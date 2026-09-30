import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/translations.dart';
import '../../models/trip.dart';
import '../../state/app_state.dart';
import '../../widgets/sub_page_header.dart';
import '../trip_detail/trip_detail_screen.dart';

/// Mirrors the website's `/profile/comparisons` page — a side-by-side
/// comparison table (up to 3 trips, same cap the backend enforces) rather
/// than a plain list, since the whole point of "compare" is seeing the
/// specs lined up together.
class ComparisonsScreen extends StatefulWidget {
  const ComparisonsScreen({super.key});

  @override
  State<ComparisonsScreen> createState() => _ComparisonsScreenState();
}

class _ComparisonsScreenState extends State<ComparisonsScreen> {
  bool _loading = true;
  List<Trip> _trips = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await context.read<AppState>().fetchComparisons();
    if (!mounted) return;
    setState(() {
      _trips = trips.map((t) => t.toTrip()).toList();
      _loading = false;
    });
  }

  Future<void> _remove(int i) async {
    final trip = _trips[i];
    if (trip.apiId == null) return;
    setState(() => _trips.removeAt(i));
    final result = await context.read<AppState>().toggleComparison(trip.apiId!);
    if (!mounted) return;
    if (result != false) {
      // Toggle failed or somehow re-added — put it back rather than
      // silently losing it from the list.
      setState(() => _trips.insert(i, trip));
    }
  }

  int _starCount(Trip t) => t.stars.split('').where((c) => c == '★').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: SubPageHeader(title: tr('more_menu.comparisons')),
      body: _loading
          ? const Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2)))
          : _trips.isEmpty
              ? Center(
                  child: Text(tr('comparisons.empty'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _labelColumn(),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < _trips.length; i++)
                                  _tripColumn(i),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  static const _rowHeight = 46.0;

  Widget _labelColumn() {
    final labels = [
      tr('comparisons.row.trip'),
      tr('comparisons.row.price'),
      tr('comparisons.row.duration'),
      tr('comparisons.row.rating'),
      tr('comparisons.row.provider'),
      tr('feat.flight'),
      tr('feat.transport'),
      tr('feat.guide'),
    ];
    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 168),
          for (final l in labels)
            SizedBox(
              height: _rowHeight,
              child: Text(l,
                  style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted)),
            ),
        ],
      ),
    );
  }

  Widget _tripColumn(int i) {
    final t = _trips[i];
    return Container(
      width: 150,
      margin: const EdgeInsetsDirectional.only(end: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TripDetailScreen(trip: t))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: t.networkImage != null
                    ? CachedNetworkImage(
                        imageUrl: t.networkImage!,
                        width: double.infinity,
                        height: 90,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                            height: 90, decoration: BoxDecoration(gradient: t.bg)),
                        errorWidget: (_, __, ___) => Container(
                            height: 90,
                            decoration: BoxDecoration(gradient: t.bg),
                            alignment: Alignment.center,
                            child: Text(t.emoji, style: const TextStyle(fontSize: 26))),
                      )
                    : Container(
                        height: 90,
                        decoration: BoxDecoration(gradient: t.bg),
                        alignment: Alignment.center,
                        child: Text(t.emoji, style: const TextStyle(fontSize: 26))),
              ),
            ),
            PositionedDirectional(
              top: 4,
              end: 4,
              child: GestureDetector(
                onTap: () => _remove(i),
                child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const FaIcon(FontAwesomeIcons.xmark,
                        size: 12, color: AppColors.red)),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: Text(tr(t.title),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.text)),
          ),
          const SizedBox(height: 4),
          _cell(tr(t.price),
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w900, color: t.accent)),
          _cell('${t.days} ${tr('trip.days.unit')}'),
          _cell('${_starCount(t)} ★'),
          _cell(tr(t.provider), maxLines: 1),
          _featCell(t.feats.contains('feat.flight')),
          _featCell(t.feats.contains('feat.transport')),
          _featCell(t.feats.contains('feat.guide')),
        ],
      ),
    );
  }

  Widget _cell(String text, {TextStyle? style, int maxLines = 1}) => SizedBox(
        height: _rowHeight,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: style ??
                  const TextStyle(fontSize: 12, color: AppColors.text)),
        ),
      );

  Widget _featCell(bool has) => SizedBox(
        height: _rowHeight,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: FaIcon(has ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circleXmark,
              size: 16, color: has ? AppColors.green : AppColors.border),
        ),
      );
}
