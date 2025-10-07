import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/auth_response_model.dart';
import 'package:restaurant_management/features/auth/data/models/change_password_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/login_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/register_request_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/network/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  @override
  Future<AuthResponseModel> register(RegisterRequestModel model) async {
    final resp = await remote.register(model);
    await _saveTokens(resp);
    return resp;
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel model) async {
    final resp = await remote.login(model);
    await _saveTokens(resp);
    return resp;
  }

  // ✅ Logout (server + clear local tokens)
  Future<bool> logout(String userId) async {
    try {
      final response = await remote.logout(userId);
      if (response["success"] == true) {
        await tokenStorage.clear();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ✅ Change Password
  // ✅ Change Password
  Future<bool> changePassword(ChangePasswordRequestModel model) async {
    try {
      final resp = await remote.changePassword(model.toJson());

      // الريسبونس دايمًا Map<String, dynamic>
      if (resp is Map<String, dynamic>) {
        final success = resp['success'] == true;
        final serverMessage = resp['errors']?['message'] ?? resp['message'];

        if (success) return true;

        // لو فشل نرمي Exception بالرسالة
        throw Exception(serverMessage ?? "Change password failed");
      }

      // fallback لأي نوع غير متوقع
      throw Exception("Unexpected response type");
    } catch (e) {
      throw Exception("Change password failed: $e");
    }
  }

  // ✅ Refresh Token
  Future<bool> refreshToken() async {
    try {
      final refresh = tokenStorage.getRefreshToken();
      if (refresh == null) return false;

      final resp = await remote.refreshToken(refresh);
      await _saveTokens(resp);
      return true;
    } catch (_) {
      await tokenStorage.clear();
      return false;
    }
  }

  // ✅ Revoke Token
  Future<bool> revokeToken() async {
    try {
      final refresh = tokenStorage.getRefreshToken();
      if (refresh == null) return false;

      final response = await remote.revokeToken({"refreshToken": refresh});
      if (response["success"] == true) {
        await tokenStorage.clear();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // 🔐 Helper: Save tokens in local storage
  Future<void> _saveTokens(AuthResponseModel resp) async {
    if (resp.data?.accessToken != null) {
      await tokenStorage.saveAccessToken(resp.data!.accessToken!);
    }
    if (resp.data?.refreshToken != null) {
      await tokenStorage.saveRefreshToken(resp.data!.refreshToken!);
    }
    if (resp.data?.id != null) {
      await tokenStorage.saveUserId(resp.data!.id!);
    }
    if (resp.data?.expiresIn != null) {
      await tokenStorage.saveAccessExpiry(resp.data!.expiresIn!);
    }
    if (resp.data?.refreshTokenExpiration != null) {
      await tokenStorage.saveRefreshExpiry(resp.data!.refreshTokenExpiration!);
    }
  }
}
