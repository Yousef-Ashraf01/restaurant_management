import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/profile_response_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepository(this.remote);

  Future<ProfileResponseModel> getUserProfile(
    String userId,
    String token,
  ) async {
    return await remote.getUserProfile(userId, token);
  }
}
