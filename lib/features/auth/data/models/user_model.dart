import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.email,
    required super.name,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'role': role,
    };
  }
}
