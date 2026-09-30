import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/translations.dart';
import '../../models/api_notification.dart';
import '../../services/live_updates.dart';
import '../../state/app_state.dart';
import '../../widgets/sub_page_header.dart';

(FaIconData, Color, Color) _styleFor(String type) {
  switch (type) {
    case 'booking.confirmed':
    case 'booking.payment_paid':
      return (
        FontAwesomeIcons.solidCircleCheck,
        AppColors.greenLight,
        AppColors.green
      );
    case 'booking.cancelled':
    case 'booking.payment_failed':
      return (
        FontAwesomeIcons.circleXmark,
        const Color(0xFFFFE4E4),
        const Color(0xFFE84040)
      );
    case 'booking.hotel_assigned':
    case 'booking.hotel_changed':
    case 'booking.hotel_cleared':
    case 'booking.room_assigned':
    case 'booking.room_changed':
    case 'booking.room_cleared':
    case 'booking.housing_updated':
    case 'trip.hotel_updated':
      return (
        FontAwesomeIcons.solidBuilding,
        AppColors.blueLight,
        AppColors.blue
      );
    case 'booking.roommates':
    case 'booking.roommates_updated':
      return (FontAwesomeIcons.userGroup, AppColors.blueLight, AppColors.blue);
    case 'booking.bus_assigned':
    case 'booking.bus_changed':
    case 'booking.bus_cleared':
    case 'trip.buses_updated':
      return (
        FontAwesomeIcons.bus,
        const Color(0xFFEEE8FF),
        const Color(0xFF7C3AED)
      );
    case 'trip.flight_updated':
      return (
        FontAwesomeIcons.plane,
        const Color(0xFFEEE8FF),
        const Color(0xFF7C3AED)
      );
    case 'trip.departure_point_updated':
      return (
        FontAwesomeIcons.locationDot,
        AppColors.greenLight,
        AppColors.green
      );
    default:
      return (
        FontAwesomeIcons.solidBell,
        const Color(0xFFF3F4F6),
        AppColors.muted
      );
  }
}

/// Mirrors `#pg-notifs`.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with LiveReload<NotificationsScreen> {
  @override
  Future<void> onLiveUpdate() => _load();

  bool _loading = true;
  List<ApiNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final (notifications, _) =
        await context.read<AppState>().fetchNotifications();
    if (!mounted) return;
    // Notifications are never deleted — empty on a refresh = failed request.
    if (notifications.isEmpty && _notifications.isNotEmpty) return;
    setState(() {
      _notifications = notifications;
      _loading = false;
    });
  }

  Future<void> _markAllRead() async {
    setState(() {
      _notifications = _notifications
          .map((n) => ApiNotification(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              isRead: true,
              timeAgo: n.timeAgo))
          .toList();
    });
    await context.read<AppState>().markAllNotificationsRead();
  }

  Future<void> _tapNotification(int index) async {
    final n = _notifications[index];
    if (n.isRead) return;
    setState(() {
      _notifications[index] = ApiNotification(
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          isRead: true,
          timeAgo: n.timeAgo);
    });
    await context.read<AppState>().markNotificationRead(n.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: SubPageHeader(
          title: tr('more_menu.notifications'),
          actionLabel: tr('more_menu.notifications.mark_all'),
          onAction: _markAllRead),
      body: _loading
          ? const Center(
              child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2)))
          : _notifications.isEmpty
              ? Center(
                  child: Text(tr('more_menu.notifications.empty'),
                      style: const TextStyle(color: AppColors.muted)))
              : ListView.separated(
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, i) {
                    final n = _notifications[i];
                    final (icon, bg, color) = _styleFor(n.type);
                    return GestureDetector(
                      onTap: () => _tapNotification(i),
                      child: Container(
                        color:
                            n.isRead ? Colors.white : const Color(0xFFFAFBFF),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: FaIcon(icon, size: 16, color: color)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(n.title,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.text)),
                                      if (n.body != null) ...[
                                        const SizedBox(height: 3),
                                        Text(n.body!,
                                            style: const TextStyle(
                                                fontSize: 11.5,
                                                color: AppColors.muted,
                                                height: 1.5)),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(n.timeAgo,
                                          style: const TextStyle(
                                              fontSize: 10.5,
                                              color: AppColors.muted)),
                                    ]),
                              ),
                              if (!n.isRead)
                                Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                        color: AppColors.blue,
                                        shape: BoxShape.circle)),
                            ]),
                      ),
                    );
                  },
                ),
    );
  }
}
