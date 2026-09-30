import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/order.dart';
import '../../services/live_updates.dart';
import '../../state/app_state.dart';
import '../../widgets/order_card.dart';
import '../../widgets/sub_page_header.dart';
import '../../l10n/translations.dart';

/// "رحلاتي" — a focused shortcut to just the *current/upcoming* bookings
/// (pending awaiting provider confirmation, or confirmed and not yet
/// departed), nearest-first, with no completed/cancelled history at all.
/// Explicitly distinct from `OrdersScreen` ("حجوزاتي"), which is the full
/// archive across every status/date — this screen is that same data
/// pre-filtered to "what do I need to look at right now", per the user's
/// own distinction between the two.
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with LiveReload<MyTripsScreen> {
  @override
  Future<void> onLiveUpdate() => _load();

  bool _loading = true;
  List<Order> _trips = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bookings = await context.read<AppState>().fetchBookings();
    if (!mounted) return;
    // Bookings never disappear, so an empty result on a refresh means a
    // failed request — keep what's on screen instead of blanking it.
    if (bookings.isEmpty && _trips.isNotEmpty) return;
    setState(() {
      _trips = bookings
          .map((b) => b.toOrder())
          .where((o) =>
              o.status == OrderStatus.pending ||
              o.status == OrderStatus.confirmed)
          .toList()
        ..sort(compareOrdersByUpcomingDate);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: SubPageHeader(title: tr('my_trips.title')),
      body: _loading
          ? const Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2)))
          : _trips.isEmpty
              ? Center(
                  child: Text(tr('orders.no_trips'),
                      style: const TextStyle(color: AppColors.muted)))
              : ListView(
                  padding: const EdgeInsets.all(14),
                  children: [
                    for (final t in _trips)
                      OrderCard(order: t, onChanged: _load)
                  ],
                ),
    );
  }
}
