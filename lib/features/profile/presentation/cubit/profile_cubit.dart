import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/profile/data/models/profile_response_model.dart';
import 'package:restaurant_management/features/profile/data/repositories/profile_repository.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;
  bool _profileLoaded = false;
  ProfileResponseModel? _cachedProfile;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile(
    String userId,
    String token, {
    bool forceRefresh = false,
  }) async {
    // ✅ لو عندي كاش، اعرضه فورًا من غير Loading
    if (_profileLoaded && _cachedProfile != null && !forceRefresh) {
      emit(ProfileSuccess(_cachedProfile!));
      return;
    }

    // ✅ لو أول مرة، اعمل Loading فعلاً
    if (!_profileLoaded) emit(ProfileLoading());

    try {
      final profileResponse = await repository.getUserProfile(userId);
      _cachedProfile = profileResponse;
      _profileLoaded = true;
      emit(ProfileSuccess(profileResponse));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  ProfileResponseModel? get cachedProfile => _cachedProfile;

  Future<void> updateProfile(ProfileData updatedProfile, String token) async {
    emit(ProfileUpdating());
    try {
      final response = await repository.updateUserProfile(updatedProfile);
      final message = response.message ?? "Profile updated successfully";

      if (_cachedProfile != null) {
        _cachedProfile = ProfileResponseModel(
          success: true,
          statusCode: _cachedProfile!.statusCode,
          message: message,
          data: updatedProfile,
        );
      }

      emit(ProfileUpdateSuccess(message));
      emit(ProfileSuccess(_cachedProfile!)); // ✅ نعيد عرض الكاش بعد التحديث
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
