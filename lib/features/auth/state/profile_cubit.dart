import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> fetchProfile(String userId, String token) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getUserProfile(userId, token);
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
