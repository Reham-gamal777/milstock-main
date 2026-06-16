import '../../domain/entities/notification_item.dart';

class NotificationModel extends NotificationItem {
  const NotificationModel({
    required super.id,
    required super.message,
    required super.time,
    required super.type,
    required super.category,
    required super.titleKey,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? 'info',
      category: json['category'] ?? 'system',
      titleKey: json['titleKey'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'time': time,
      'type': type,
      'category': category,
      'titleKey': titleKey,
      'isRead': isRead,
    };
  }
}
