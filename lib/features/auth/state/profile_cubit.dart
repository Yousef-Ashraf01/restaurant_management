import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/data/models/profile_response_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile(String userId, String token) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getUserProfile(userId);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(ProfileData updatedProfile, String token) async {
    emit(ProfileLoading());
    try {
      final response = await repository.updateUserProfile(updatedProfile);

      // mapping للرسالة
      final userMessage =
          response.message == "UpdatedMessage"
              ? "Profile updated successfully"
              : response.message ?? "Profile updated successfully";

      emit(ProfileUpdateSuccess(userMessage));

      // بعد التحديث، نجيب البيانات الجديدة عشان نحدث الـ UI
      final profile = await repository.getUserProfile(updatedProfile.id);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
