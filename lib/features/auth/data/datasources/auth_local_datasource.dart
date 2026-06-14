import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final cleanEmail = email.trim().toLowerCase();
    
    if (cleanEmail == 'admin@milstock.mil') {
      return const UserModel(
        email: 'admin@milstock.mil',
        name: 'Command General',
        role: 'admin',
      );
    } else if (cleanEmail == 'unit@milstock.mil') {
      return const UserModel(
        email: 'unit@milstock.mil',
        name: 'Unit Logistics Officer',
        role: 'user',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }
}
