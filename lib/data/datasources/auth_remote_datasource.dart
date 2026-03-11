import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await apiClient.post(ApiConstants.loginUrl, {
      'username': username,
      'password': password,
      'expiresInMins': 30,
    });
    return UserModel.fromJson(response);
  }
}
