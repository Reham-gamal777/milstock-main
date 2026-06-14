import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await localDataSource.login(email, password);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }
}
