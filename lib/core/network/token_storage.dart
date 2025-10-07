import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  final SharedPreferences prefs;

  TokenStorage(this.prefs);

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _accessExpiryKey = "access_expiry";
  static const _refreshExpiryKey = "refresh_expiry";
  static const _userIdKey = "user_id";
  static const _passwordKey = "user_password";

  // Save
  Future<void> saveAccessToken(String token) async =>
      await prefs.setString(_accessKey, token);

  Future<void> saveRefreshToken(String token) async =>
      await prefs.setString(_refreshKey, token);

  Future<void> saveAccessExpiry(DateTime expiry) async => await prefs.setInt(
    _accessExpiryKey,
    expiry.toUtc().millisecondsSinceEpoch,
  );

  Future<void> saveRefreshExpiry(DateTime expiry) async => await prefs.setInt(
    _refreshExpiryKey,
    expiry.toUtc().millisecondsSinceEpoch,
  );

  Future<void> saveUserId(String userId) async =>
      await prefs.setString(_userIdKey, userId);

  Future<void> savePassword(String password) async =>
      await prefs.setString(_passwordKey, password);

  // Get
  String? getAccessToken() => prefs.getString(_accessKey);

  String? getRefreshToken() => prefs.getString(_refreshKey);

  DateTime? getAccessExpiry() {
    final v = prefs.getInt(_accessExpiryKey);
    return v != null
        ? DateTime.fromMillisecondsSinceEpoch(v, isUtc: true)
        : null;
  }

  DateTime? getRefreshExpiry() {
    final v = prefs.getInt(_refreshExpiryKey);
    return v != null
        ? DateTime.fromMillisecondsSinceEpoch(v, isUtc: true)
        : null;
  }

  String? getUserId() => prefs.getString(_userIdKey);

  String? getPassword() => prefs.getString(_passwordKey);

  // Clear all
  Future<void> clear() async {
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_accessExpiryKey);
    await prefs.remove(_refreshExpiryKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_passwordKey);
  }
}
