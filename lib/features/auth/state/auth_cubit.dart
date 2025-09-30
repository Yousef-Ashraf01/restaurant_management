import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';

import '../data/models/login_request_model.dart';
import '../data/models/register_response_model.dart';
import '../domain/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl repository;
  final ProfileRepository profileRepository;

  AuthCubit(this.repository, this.profileRepository) : super(AuthInitial());

  Future<void> register(RegisterRequestModel req) async {
    emit(AuthLoading());
    try {
      final resp = await repository.register(req);
      if (resp.success && resp.statusCode == 201) {
        emit(AuthRegisterSuccess(resp.message ?? 'Registered successfully'));
      } else {
        emit(AuthError(resp.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(LoginRequestModel body) async {
    emit(AuthLoading());
    try {
      final response = await repository.login(body);

      if (response.data?.id != null && response.data?.accessToken != null) {
        // حفظ token و userId
        await repository.tokenStorage.saveAccessToken(
          response.data!.accessToken!,
        );
        await repository.tokenStorage.saveUserId(response.data!.id!);

        // جلب البروفايل بدون الانتظار (Background)
        profileRepository.getUserProfile(
          response.data!.id!,
          response.data!.accessToken!,
        );

        emit(
          AuthLoginSuccess(
            response.message ?? "Login successfully",
            token: response.data!.accessToken!,
          ),
        );
      } else {
        emit(AuthError("Login failed: Missing token or userId"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout(String userId) async {
    emit(AuthLoading());
    final success = await repository.logout(userId);
    if (success) {
      emit(AuthLoggedOut());
    } else {
      emit(AuthError("Logout failed"));
    }
  }
}
