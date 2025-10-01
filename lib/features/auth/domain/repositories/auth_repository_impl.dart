import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/auth_response_model.dart';
import 'package:restaurant_management/features/auth/data/models/change_password_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/login_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/register_response_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/network/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  @override
  Future<AuthResponseModel> register(RegisterRequestModel model) async {
    final resp = await remote.register(model);

    if (resp.data?.accessToken != null) {
      await tokenStorage.saveAccessToken(resp.data!.accessToken!);
    }
    if (resp.data?.refreshToken != null) {
      await tokenStorage.saveRefreshToken(resp.data!.refreshToken!);
    }

    return resp;
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel model) async {
    final resp = await remote.login(model);

    if (resp.data?.accessToken != null) {
      await tokenStorage.saveAccessToken(resp.data!.accessToken!);
    }
    if (resp.data?.refreshToken != null) {
      await tokenStorage.saveRefreshToken(resp.data!.refreshToken!);
    }

    return resp;
  }

  Future<bool> logout(String userId) async {
    try {
      final response = await remote.logout(userId); // هنعمل دالة في الـ remote
      if (response.data == true) {
        await tokenStorage.clear(); // امسح الـ tokens
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword(ChangePasswordRequestModel model) async {
    try {
      final resp = await remote.changePassword(model.toJson());
      return resp == true || resp["success"] == true; // حسب API
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
