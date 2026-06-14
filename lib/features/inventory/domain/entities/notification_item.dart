class NotificationItem {
  final String id;
  final String message;
  final String time;
  final String type; // 'error' (urgent), 'warning' (low stock/expiry), 'info' (approved/delivered)

  const NotificationItem({
    required this.id,
    required this.message,
    required this.time,
    required this.type,
  });
}
