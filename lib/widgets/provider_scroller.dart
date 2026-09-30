import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../l10n/translations.dart';
import '../models/provider_company.dart';
import 'h_scroll_auto.dart';

/// Mirrors `.prov-scroll` / `.prov-card` — the horizontal "شركات العمرة"
/// provider list, plus its `.sec-hd` section header.
class ProviderScroller extends StatelessWidget {
  final String title;
  final List<ProviderCompany> providers;
  final Color moreColor;
  final VoidCallback? onMoreTap;
  final ValueChanged<ProviderCompany>? onProviderTap;

  const ProviderScroller({
    super.key,
    required this.title,
    required this.providers,
    this.moreColor = AppColors.blue,
    this.onMoreTap,
    this.onProviderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onMoreTap,
                child: Text(tr('common.viewAll'),
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: moreColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          HScrollAuto(
            itemCount: providers.length,
            itemBuilder: (context, i) => _ProviderCard(
              provider: providers[i],
              onTap: onProviderTap == null ? null : () => onProviderTap!(providers[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final ProviderCompany provider;
  final VoidCallback? onTap;
  const _ProviderCard({required this.provider, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 120,
      // Fixed height (rather than sizing to content) because HScrollAuto
      // sizes this row via IntrinsicHeight, which does two layout passes —
      // a dry-run estimate and the real layout — and a wrapped Text's
      // reported height can differ by a sub-pixel between the two (worse
      // with web fonts), causing an intermittent 1-3px overflow. A fixed
      // height reports the same number in both passes, so there's nothing
      // left to disagree on.
      height: 145,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: provider.color, borderRadius: BorderRadius.circular(11)),
            alignment: Alignment.center,
            child: Text(provider.letter,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 6),
          Text(tr(provider.name),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 2),
          Text(provider.stars,
              style: const TextStyle(fontSize: 10, color: AppColors.gold)),
          Text('${provider.trips} ${tr('trip.provider_scroller.trip_count')}',
              style: const TextStyle(fontSize: 10, color: AppColors.muted)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: AppColors.greenLight,
                borderRadius: BorderRadius.circular(10)),
            child: Text('${tr('trip.provider_scroller.verified')} ✓',
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green)),
          ),
        ],
      ),
      ),
    );
  }
}
