import '../data/models/profile_response_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileResponseModel profile;

  ProfileSuccess(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
