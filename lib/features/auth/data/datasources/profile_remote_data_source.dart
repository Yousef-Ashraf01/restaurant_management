import 'package:dio/dio.dart';

import '../models/profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModel> getUserProfile(String userId, String token);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio client;

  ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<ProfileResponseModel> getUserProfile(
    String userId,
    String token,
  ) async {
    try {
      final response = await client.get(
        '/api/Users/profile/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return ProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to load profile");
    }
  }
}
