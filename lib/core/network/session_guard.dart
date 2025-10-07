import 'auth_manager.dart';
import 'token_storage.dart';

class SessionGuard {
  final TokenStorage tokenStorage;
  final AuthManager authManager;

  SessionGuard({required this.tokenStorage, required this.authManager});

  /// يتحقق من صلاحية التوكنات ويرجع true لو كل شيء تمام
  Future<bool> ensureValidSession() async {
    final now = DateTime.now().toUtc();
    final accessExpiry = await tokenStorage.getAccessExpiry();
    final refreshExpiry = await tokenStorage.getRefreshExpiry();

    // ✅ لو الـ access token لسه صالح
    if (accessExpiry != null && accessExpiry.isAfter(now)) {
      return true;
    }

    // ⚠️ لو انتهى نحاول نعمل refresh
    if (refreshExpiry != null && refreshExpiry.isAfter(now)) {
      final ok = await authManager.checkSession();
      return ok;
    }

    // 🚫 كله انتهى
    await tokenStorage.clear();
    return false;
  }
}
