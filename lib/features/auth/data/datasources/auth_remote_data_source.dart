import 'package:dio/dio.dart';
import 'package:restaurant_management/features/auth/data/models/login_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/register_response_model.dart';

import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(RegisterRequestModel model);
  Future<AuthResponseModel> login(LoginRequestModel model);
  Future<dynamic> logout(String userId);
  Future<dynamic> changePassword(Map<String, dynamic> body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<AuthResponseModel> register(RegisterRequestModel model) async {
    try {
      final response = await client.post(
        '/api/Auth/Register',
        data: model.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // اطبع التفاصيل عشان تعرف المشكلة
      print("❌ Dio error: ${e.response?.statusCode} -> ${e.response?.data}");
      throw Exception(
        e.response?.data["message"] ?? "Unexpected error occurred",
      );
    }
  }

  Future<AuthResponseModel> login(LoginRequestModel model) async {
    try {
      final response = await client.post(
        '/api/Auth/GetToken',
        data: model.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // اطبع التفاصيل عشان تعرف المشكلة
      print("❌ Dio error: ${e.response?.statusCode} -> ${e.response?.data}");
      throw Exception(
        e.response?.data["message"] ?? "Unexpected error occurred",
      );
    }
  }

  Future<dynamic> logout(String userId) async {
    final response = await client.post(
      "/Auth/Logout",
      data: {"userId": userId},
    );
    return response.data;
  }

  @override
  Future<dynamic> changePassword(Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        '/api/Users/changePassword',
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data;
    } on DioException catch (e) {
      print(
        "❌ ChangePassword Dio error: ${e.response?.statusCode} -> ${e.response?.data}",
      );
      throw Exception(
        e.response?.data["message"] ?? "Unexpected error occurred",
      );
    }
  }
}
