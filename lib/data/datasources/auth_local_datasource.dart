import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'cached_user';
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonStr = prefs.getString(_userKey);
    if (jsonStr == null) return null;
    try {
      return UserModel.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(_userKey);
  }
}
