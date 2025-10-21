import 'package:restaurant_management/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/profile/data/models/profile_response_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepository(this.remote);

  Future<ProfileResponseModel> getUserProfile(String userId) async {
    return await remote.getUserProfile(userId);
  }

  Future<ProfileResponseModel> updateUserProfile(ProfileData data) async {
    return await remote.updateUserProfile(data);
  }
}
