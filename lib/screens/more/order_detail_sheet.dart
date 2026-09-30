import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../models/order.dart';
import '../../services/live_updates.dart';
import '../../state/app_state.dart';
import '../../widgets/app_toast.dart';
import '../../l10n/translations.dart';
import '../../widgets/order_actions.dart';

/// Mirrors `#orderDetailSheet`. [order] is built from the bookings *list*
/// endpoint, which omits hotel/bus/room assignment (see ApiBooking's
/// "detail-only fields" comment) — so on open this re-fetches the single
/// booking via GET /bookings/{id} and swaps in that fuller detail once it
/// lands, instead of showing "not assigned yet" for data that actually
/// exists server-side.
class OrderDetailSheet extends StatefulWidget {
  final Order order;
  const OrderDetailSheet({super.key, required this.order});

  @override
  State<OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends State<OrderDetailSheet>
    with LiveReload<OrderDetailSheet> {
  @override
  Future<void> onLiveUpdate() => _loadDetail();

  late Order _order;
  bool _loadingDetail = true;
  bool _payingNow = false;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final apiId = widget.order.apiId;
    if (apiId == null) {
      setState(() => _loadingDetail = false);
      return;
    }
    final detail = await context.read<AppState>().fetchBookingDetail(apiId);
    if (!mounted) return;
    setState(() {
      if (detail != null) _order = detail.toOrder();
      _loadingDetail = false;
    });
  }

  Order get order => _order;

  /// Retry payment for a booking that was created but never paid (closed
  /// the payment screen, connection dropped, gateway declined, etc.).
  Future<void> _payNow() async {
    if (_payingNow) return;
    setState(() => _payingNow = true);
    await payForOrder(context, order);
    if (!mounted) return;
    setState(() => _payingNow = false);
    // Re-check the real server-side status either way — the WebView
    // redirect alone isn't proof of capture.
    await _loadDetail();
  }

  Future<void> _cancelBooking() async {
    if (_cancelling) return;
    setState(() => _cancelling = true);
    final cancelled = await cancelOrder(context, order);
    if (!mounted) return;
    setState(() => _cancelling = false);
    if (cancelled) await _loadDetail();
  }

  static Map<OrderStatus, (Color, Color, String)> get _statusStyle => {
        OrderStatus.pending: (
          Color(0xFFFEF3C7),
          Color(0xFFD97706),
          tr('orders.status.pending')
        ),
        OrderStatus.confirmed: (
          AppColors.blueLight,
          AppColors.blue,
          tr('orders.status.confirmed')
        ),
        OrderStatus.completed: (
          AppColors.greenLight,
          AppColors.green,
          tr('orders.status.completed')
        ),
        OrderStatus.cancelled: (
          Color(0xFFFFE4E4),
          Color(0xFFE84040),
          tr('orders.status.cancelled')
        ),
      };

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle[order.status]!;
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
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text(tr('orders.detail_title'),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text)),
                if (_loadingDetail) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.blue)),
                ],
              ]),
              GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: AppColors.bg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const FaIcon(FontAwesomeIcons.xmark,
                          size: 14, color: AppColors.muted))),
            ]),
            const SizedBox(height: 14),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                    color: style.$1, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const FaIcon(FontAwesomeIcons.solidCircle,
                      size: 8, color: Colors.transparent),
                  Text(style.$3,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: style.$2)),
                ])),
            const SizedBox(height: 16),
            _section(tr('orders.section.trip_info'), FontAwesomeIcons.plane, [
              (tr('orders.field.order_number'), order.id, null),
              (
                tr('orders.field.trip'),
                '${order.emoji} ${tr(order.trip)}',
                null
              ),
              (
                tr('orders.field.departure_location'),
                order.departureCity,
                () => _openMap(context, order.departureCity)
              ),
              (tr('orders.field.provider'), order.provider, null),
              (tr('orders.field.travel_date'), order.date, null),
              (tr('orders.field.duration'), order.duration, null),
              (tr('orders.field.travelers_count'), order.pax, null),
            ]),
            if (order.bus != null)
              _section(tr('orders.section.bus_info'), FontAwesomeIcons.bus, [
                (tr('orders.field.bus_number'), order.bus!.num, null),
                (tr('orders.field.capacity'), order.bus!.cap, null),
                (
                  tr('orders.field.bus_supervisor'),
                  order.bus!.supervisor,
                  null
                ),
                (tr('orders.field.supervisor_phone'), order.bus!.phone, null),
              ]),
            _section(tr('orders.section.hotel_info'),
                FontAwesomeIcons.solidBuilding, [
              (tr('orders.field.hotel'), order.hotel.name, null),
              (tr('orders.field.rating'), order.hotel.stars, null),
              (tr('orders.field.location'), order.hotel.location, null),
            ]),
            _roomSection(order.hotel),
            _section(
                tr('orders.section.price_details'), FontAwesomeIcons.receipt, [
              (tr('orders.field.unit_price'), order.priceUnit, null),
              (tr('orders.field.people_count'), order.pax, null),
              (tr('orders.field.total'), order.total, null),
            ]),
            if (order.needsPayment) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _payingNow ? null : _payNow,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: _payingNow
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.creditCard,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(tr('orders.pay_now'),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                ),
              ),
            ],
            if (order.canCancel) ...[
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _cancelling ? null : _cancelBooking,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E4),
                        borderRadius: BorderRadius.circular(20)),
                    child: _cancelling
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Color(0xFFE84040)))
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(FontAwesomeIcons.ban,
                                  size: 11, color: Color(0xFFE84040)),
                              const SizedBox(width: 6),
                              Text(tr('orders.cancel.button'),
                                  style: const TextStyle(
                                      color: Color(0xFFE84040),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 6),
            // WhatsApp contact button removed on request — the call/rate
            // action below is the only contact affordance here now.
            GestureDetector(
              onTap: () => showAppToast(
                  context,
                  order.status == OrderStatus.completed
                      ? tr('orders.rate_thanks_toast')
                      : tr('orders.calling_toast')),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: order.status == OrderStatus.completed
                          ? AppColors.green
                          : AppColors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(tr(order.action),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, FaIconData icon,
      List<(String, String, VoidCallback?)> rows) {
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
          GestureDetector(
            onTap: r.$3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Text(r.$1,
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tr(r.$2),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: r.$3 != null ? AppColors.blue : AppColors.text,
                          decoration: r.$3 != null
                              ? TextDecoration.underline
                              : TextDecoration.none)),
                ),
                if (r.$3 != null) ...[
                  const SizedBox(width: 6),
                  const FaIcon(FontAwesomeIcons.locationDot,
                      size: 12, color: AppColors.blue),
                ],
              ]),
            ),
          ),
      ]),
    );
  }

  Future<void> _openMap(BuildContext context, String cityKey) async {
    final query = Uri.encodeComponent(tr(cityKey));
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      showAppToast(context, tr('orders.map_open_failed'));
    }
  }

  Widget _roomSection(OrderHotelInfo hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const FaIcon(FontAwesomeIcons.bed, size: 13, color: AppColors.blue),
          const SizedBox(width: 6),
          Text(tr('orders.section.room_details'),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text)),
        ]),
        const SizedBox(height: 10),
        for (final r in [
          (tr('orders.field.room_number'), hotel.room),
          (tr('orders.field.room_type'), hotel.roomType)
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              Text(r.$1,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(tr(r.$2),
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
        if (hotel.roommates.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(tr('orders.section.roommates'),
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ),
          for (final name in hotel.roommates)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                const FaIcon(FontAwesomeIcons.solidUser,
                    size: 12, color: AppColors.muted),
                const SizedBox(width: 8),
                Text(tr(name),
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text)),
              ]),
            ),
        ],
      ]),
    );
  }
}
