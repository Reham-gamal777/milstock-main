import '../../domain/entities/notification_item.dart';

class NotificationModel extends NotificationItem {
  const NotificationModel({
    required super.id,
    required super.message,
    required super.time,
    required super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? 'info',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'time': time,
      'type': type,
    };
  }
}
