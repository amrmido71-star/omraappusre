/// A notification as returned by the real Front API (`/notifications`).
class ApiNotification {
  final int id;
  final String type;
  final String title;
  final String? body;
  final bool isRead;
  final String timeAgo;

  /// Extra ids from the server (booking_id, trip_id, announcement_id ...).
  final Map<String, dynamic> data;

  const ApiNotification({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    required this.isRead,
    required this.timeAgo,
    this.data = const {},
  });

  int? get bookingId => (data['booking_id'] as num?)?.toInt();

  ApiNotification copyWith({bool? isRead}) => ApiNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        isRead: isRead ?? this.isRead,
        timeAgo: timeAgo,
        data: data,
      );

  factory ApiNotification.fromJson(Map<String, dynamic> j) => ApiNotification(
        id: j['id'] as int,
        type: j['type'] as String? ?? '',
        title: j['title'] as String? ?? '',
        body: j['body'] as String?,
        isRead: j['is_read'] as bool? ?? false,
        timeAgo: j['time_ago'] as String? ?? '',
        data: j['data'] is Map ? Map<String, dynamic>.from(j['data'] as Map) : const {},
      );
}
