/// A notification as returned by the real Front API (`/notifications`).
class ApiNotification {
  final int id;
  final String type;
  final String title;
  final String? body;
  final bool isRead;
  final String timeAgo;

  const ApiNotification({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    required this.isRead,
    required this.timeAgo,
  });

  factory ApiNotification.fromJson(Map<String, dynamic> j) => ApiNotification(
        id: j['id'] as int,
        type: j['type'] as String? ?? '',
        title: j['title'] as String? ?? '',
        body: j['body'] as String?,
        isRead: j['is_read'] as bool? ?? false,
        timeAgo: j['time_ago'] as String? ?? '',
      );
}
