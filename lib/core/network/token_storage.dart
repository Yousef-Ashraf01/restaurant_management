import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  late SharedPreferences _prefs;

  factory TokenStorage() => _instance;

  TokenStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint("✅ TokenStorage initialized with prefs: $_prefs");
  }

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _accessExpiryKey = "access_expiry";
  static const _refreshExpiryKey = "refresh_expiry";
  static const _userIdKey = "user_id";
  static const _passwordKey = "user_password";
  static const _selectedAddressKey = 'selected_address';

  // ---------------------- Save Methods ----------------------

  Future<void> saveSelectedAddress(String address) async =>
      await _prefs.setString(_selectedAddressKey, address);

  Future<void> saveAccessToken(String token) async =>
      await _prefs.setString(_accessKey, token);

  Future<void> saveRefreshToken(String token) async =>
      await _prefs.setString(_refreshKey, token);

  Future<void> saveAccessExpiry(DateTime? expiry) async {
    if (expiry != null) {
      final utcExpiry = expiry.toUtc();
      debugPrint("🕒 Saving Access Expiry (UTC): $utcExpiry");
      await _prefs.setString(_accessExpiryKey, utcExpiry.toIso8601String());
    }
  }

  Future<void> saveRefreshExpiry(DateTime? expiry) async {
    if (expiry != null) {
      final utcExpiry = expiry.toUtc();
      debugPrint("🕒 Saving Refresh Expiry (UTC): $utcExpiry");
      await _prefs.setString(_refreshExpiryKey, utcExpiry.toIso8601String());
    }
  }

  Future<void> saveUserId(String userId) async =>
      await _prefs.setString(_userIdKey, userId);

  Future<void> savePassword(String password) async =>
      await _prefs.setString(_passwordKey, password);

  // ---------------------- Get Methods ----------------------

  String? getSelectedAddress() => _prefs.getString(_selectedAddressKey);
  String? getAccessToken() => _prefs.getString(_accessKey);
  String? getRefreshToken() => _prefs.getString(_refreshKey);
  String? getUserId() => _prefs.getString(_userIdKey);
  String? getPassword() => _prefs.getString(_passwordKey);

  DateTime? getAccessExpiry() {
    final v = _prefs.getString(_accessExpiryKey);
    if (v == null) return null;
    final parsed = DateTime.tryParse(v);
    if (parsed == null) return null;
    final utc = parsed.toUtc();
    debugPrint("📆 Loaded Access Expiry (UTC): $utc");
    return utc;
  }

  DateTime? getRefreshExpiry() {
    final v = _prefs.getString(_refreshExpiryKey);
    if (v == null) return null;
    final parsed = DateTime.tryParse(v);
    if (parsed == null) return null;
    final utc = parsed.toUtc();
    debugPrint("📆 Loaded Refresh Expiry (UTC): $utc");
    return utc;
  }

  // ---------------------- Clear ----------------------

  Future<void> clear() async {
    await _prefs.remove(_accessKey);
    await _prefs.remove(_refreshKey);
    await _prefs.remove(_accessExpiryKey);
    await _prefs.remove(_refreshExpiryKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_passwordKey);
  }
}
