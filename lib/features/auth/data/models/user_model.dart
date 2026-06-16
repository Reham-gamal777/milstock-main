import '../../domain/entities/user.dart';

class UserModel extends User {
  final String? id;
  final String? status;
  final String? assignedWarehouse;

  const UserModel({
    this.id,
    required super.email,
    required super.name,
    required super.role,
    this.status,
    this.assignedWarehouse,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'user',
      status: json['status'],
      assignedWarehouse: json['assigned_warehouse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'status': status,
      'assigned_warehouse': assignedWarehouse,
    };
  }
}
