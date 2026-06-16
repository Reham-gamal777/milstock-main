import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<User> login(String email, String password) async {
    return await localDataSource.login(email, password);
  }

  @override
  Future<User?> getSavedUser() async {
    return await localDataSource.getSavedUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}
