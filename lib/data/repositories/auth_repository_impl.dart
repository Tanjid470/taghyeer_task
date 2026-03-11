import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String username, String password) async {
    final user = await remoteDataSource.login(username, password);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    return localDataSource.getCachedUser();
  }
}
