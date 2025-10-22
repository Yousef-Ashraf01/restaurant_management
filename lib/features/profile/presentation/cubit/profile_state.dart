import 'package:restaurant_management/features/profile/data/models/profile_response_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileResponseModel profile;

  ProfileSuccess(this.profile);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdating extends ProfileState {}
