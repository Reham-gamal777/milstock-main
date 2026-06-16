class NotificationItem {
  final String id;
  final String message;
  final String time;
  final String type; // 'error', 'warning', 'info', 'success'
  final String category; // 'inventory', 'validity', 'requests', 'system'
  final String titleKey;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.message,
    required this.time,
    required this.type,
    required this.category,
    required this.titleKey,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? message,
    String? time,
    String? type,
    String? category,
    String? titleKey,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      category: category ?? this.category,
      titleKey: titleKey ?? this.titleKey,
      isRead: isRead ?? this.isRead,
    );
  }
}
