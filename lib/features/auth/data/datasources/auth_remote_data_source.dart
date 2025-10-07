import 'package:dio/dio.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/auth_response_model.dart';
import 'package:restaurant_management/features/auth/data/models/login_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(RegisterRequestModel model);
  Future<AuthResponseModel> login(LoginRequestModel model);
  Future<dynamic> logout(String userId);
  Future<dynamic> changePassword(Map<String, dynamic> body);
  Future<AuthResponseModel> refreshToken(String refreshToken);
  Future<dynamic> revokeToken(Map<String, dynamic> body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AuthResponseModel> register(RegisterRequestModel model) async {
    try {
      final response = await dioClient.post(
        '/api/Auth/Register',
        data: model.toJson(),
      );
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      print("❌ Register DioClient error: $e");
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel model) async {
    try {
      final response = await dioClient.post(
        '/api/Auth/GetToken',
        data: model.toJson(),
      );
      print(response.data);
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      print("❌ Login DioClient error: $e");
      rethrow;
    }
  }

  @override
  Future<dynamic> logout(String userId) async {
    try {
      final response = await dioClient.post(
        '/api/Auth/Logout',
        data: {"userId": userId},
      );
      return response.data;
    } catch (e) {
      print("❌ Logout DioClient error: $e");
      rethrow;
    }
  }

  @override
  Future<dynamic> changePassword(Map<String, dynamic> body) async {
    try {
      final response = await dioClient.post(
        '/api/Users/changePassword',
        data: body,
      );
      return response.data;
    } catch (e) {
      print("❌ ChangePassword DioClient error: $e");
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await dioClient.get(
        '/api/Auth/refreshToken',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      print("❌ RefreshToken DioClient error: $e");
      rethrow;
    }
  }

  @override
  Future<dynamic> revokeToken(Map<String, dynamic> body) async {
    try {
      final response = await dioClient.post(
        '/api/Auth/revokeToken',
        data: body,
      );
      return response.data;
    } catch (e) {
      print("❌ RevokeToken DioClient error: $e");
      rethrow;
    }
  }
}
