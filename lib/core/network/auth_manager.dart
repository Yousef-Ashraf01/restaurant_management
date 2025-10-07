import 'package:dio/dio.dart';

import 'token_storage.dart';

class AuthManager {
  final TokenStorage tokenStorage;
  final Dio dio;
  bool _isRefreshing = false; // يمنع تنفيذ أكثر من refresh في نفس الوقت

  AuthManager({required this.tokenStorage, required this.dio});

  /// يتحقق من صلاحية الجلسة ويحدثها لو أمكن
  Future<bool> checkSession() async {
    final now = DateTime.now().toUtc();
    final accessExpiry = tokenStorage.getAccessExpiry();
    final refreshExpiry = tokenStorage.getRefreshExpiry();

    final accessToken = tokenStorage.getAccessToken();
    final refreshToken = tokenStorage.getRefreshToken();

    print("🔑 AccessToken: $accessToken");
    print("🕒 Access Expiry: $accessExpiry");
    print("🔄 RefreshToken: $refreshToken");
    print("🗓️ Refresh Expiry: $refreshExpiry");

    // ✅ لو الـ access token لسه صالح
    if (accessExpiry != null && accessExpiry.isAfter(now)) {
      return true;
    }

    // ⚠️ لو الـ access token انتهى لكن الـ refresh token لسه صالح
    if (refreshExpiry != null && refreshExpiry.isAfter(now)) {
      if (refreshToken == null || _isRefreshing) {
        print("⚠️ Refresh in progress or token missing");
        return false;
      }

      _isRefreshing = true;
      try {
        final tempDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

        final res = await tempDio.get(
          "/api/Auth/refreshToken",
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
        );

        final data = res.data['data'];

        final newAccess = data['accessToken'] as String?;
        final newRefresh = data['refreshToken'] as String?;
        final newAccessExpiryStr = data['expiresIn'] as String?;
        final newRefreshExpiryStr = data['refreshTokenExpiration'] as String?;

        if (newAccess != null) await tokenStorage.saveAccessToken(newAccess);
        if (newRefresh != null) await tokenStorage.saveRefreshToken(newRefresh);
        if (newAccessExpiryStr != null) {
          await tokenStorage.saveAccessExpiry(
            DateTime.parse(newAccessExpiryStr).toUtc(),
          );
        }
        if (newRefreshExpiryStr != null) {
          await tokenStorage.saveRefreshExpiry(
            DateTime.parse(newRefreshExpiryStr).toUtc(),
          );
        }

        print("✅ Session refreshed successfully");
        _isRefreshing = false;
        return true;
      } catch (e) {
        print("❌ Session refresh failed: $e");
        await tokenStorage.clear();
        _isRefreshing = false;
        return false;
      }
    }

    // ❌ لو كلا التوكن انتهى → Logout فوري
    await tokenStorage.clear();
    print("❌ Both tokens expired, user must login again");
    return false;
  }
}
