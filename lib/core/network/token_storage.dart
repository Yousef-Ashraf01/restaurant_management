import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  late SharedPreferences _prefs;

  factory TokenStorage() => _instance;

  TokenStorage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint("🧩 TokenStorage initialized with prefs: $_prefs");
  }

  static const _accessKey = "access_token";
  static const _refreshKey = "refresh_token";
  static const _accessExpiryKey = "access_expiry";
  static const _refreshExpiryKey = "refresh_expiry";
  static const _userIdKey = "user_id";
  static const _passwordKey = "user_password";
  static const _selectedAddressKey = 'selected_address';

  Future<void> saveSelectedAddress(String address) async {
    await _prefs.setString(_selectedAddressKey, address);
  }

  String? getSelectedAddress() {
    return _prefs.getString(_selectedAddressKey);
  }

  Future<void> saveAccessToken(String token) async =>
      await _prefs.setString(_accessKey, token);

  Future<void> saveRefreshToken(String token) async =>
      await _prefs.setString(_refreshKey, token);

  Future<void> saveAccessExpiry(DateTime? expiry) async {
    if (expiry != null) {
      await _prefs.setString(_accessExpiryKey, expiry.toIso8601String());
    }
  }

  Future<void> saveRefreshExpiry(DateTime? expiry) async {
    if (expiry != null) {
      await _prefs.setString(_refreshExpiryKey, expiry.toIso8601String());
    }
  }

  Future<void> saveUserId(String userId) async =>
      await _prefs.setString(_userIdKey, userId);

  Future<void> savePassword(String password) async =>
      await _prefs.setString(_passwordKey, password);

  // Get methods
  String? getAccessToken() => _prefs.getString(_accessKey);
  String? getRefreshToken() => _prefs.getString(_refreshKey);

  DateTime? getAccessExpiry() {
    final v = _prefs.getString(_accessExpiryKey);
    return v != null ? DateTime.parse(v).toUtc() : null;
  }

  DateTime? getRefreshExpiry() {
    final v = _prefs.getString(_refreshExpiryKey);
    return v != null ? DateTime.parse(v).toUtc() : null;
  }

  String? getUserId() => _prefs.getString(_userIdKey);
  String? getPassword() => _prefs.getString(_passwordKey);

  Future<void> clear() async {
    await _prefs.remove(_accessKey);
    await _prefs.remove(_refreshKey);
    await _prefs.remove(_accessExpiryKey);
    await _prefs.remove(_refreshExpiryKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_passwordKey);
  }
}
