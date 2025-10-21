import 'package:dio/dio.dart';
import 'package:restaurant_management/core/network/dio_client.dart';

import '../models/profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponseModel> getUserProfile(String userId);
  Future<ProfileResponseModel> updateUserProfile(ProfileData data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ProfileResponseModel> getUserProfile(String userId) async {
    try {
      final response = await dioClient.get('/api/Users/profile/$userId');
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
      return ProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print("Error in getUserProfile: ${e.response?.statusCode}");
      throw Exception(e.response?.data['message'] ?? "Failed to load profile");
    }
  }

  @override
  Future<ProfileResponseModel> updateUserProfile(ProfileData data) async {
    try {
      final response = await dioClient.put(
        '/api/Users/profile',
        data: data.toJson(),
      );
      return ProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print("Error in updateUserProfile: ${e.response?.statusCode}");
      throw Exception(
        e.response?.data['message'] ?? "Failed to update profile",
      );
    }
  }
}
