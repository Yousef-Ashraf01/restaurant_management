import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  final SharedPreferences prefs;

  TokenStorage(this.prefs);

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _userIdKey = "user_id"; // ✨ اضفنا المفتاح هنا

  Future<void> saveAccessToken(String access) async {
    await prefs.setString(_accessKey, access);
  }

  Future<void> saveRefreshToken(String refresh) async {
    await prefs.setString(_refreshKey, refresh);
  }

  // ✨ Method جديدة لحفظ userId
  Future<void> saveUserId(String userId) async {
    await prefs.setString(_userIdKey, userId);
  }

  // ✨ Method جديدة لاسترجاع userId
  String? getUserId() => prefs.getString(_userIdKey);

  Future<void> clear() async {
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_userIdKey); // ✨ نحذف كمان
  }

  String? getAccessToken() => prefs.getString(_accessKey);
  String? getRefreshToken() => prefs.getString(_refreshKey);
}
