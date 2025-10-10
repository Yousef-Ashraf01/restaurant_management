import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restaurant_management/features/auth/data/models/change_password_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/register_request_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';

import '../data/models/login_request_model.dart';
import '../domain/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl repository;
  final ProfileRepository profileRepository;

  AuthCubit(this.repository, this.profileRepository) : super(AuthInitial());

  String _mapErrorToMessage(dynamic error) {
    final rawMessage = error.toString().replaceFirst("Exception: ", "");

    if (rawMessage.contains("EmailAlreadyRegistered")) {
      return "This email is already registered";
    } else if (rawMessage.contains("UserNameAlreadyRegistered")) {
      return "This username is already registered";
    } else if (rawMessage.contains("EmailOrPassworIsIncorrect")) {
      return "Email or password is incorrect";
    } else if (rawMessage.contains("ValidationFailed")) {
      return "Invalid input, please check your data";
    } else if (rawMessage.contains("Unauthorized")) {
      return "Session expired, please login again";
    } else if (rawMessage.contains("Connection timed out")) {
      return "Connection timeout, please check your internet";
    } else if (rawMessage.contains("SocketException")) {
      return "No internet connection";
    }

    try {
      final errorMap = error as Map<String, dynamic>;
      final serverMessage = errorMap['errors']?['message'];
      if (serverMessage == "EmailAlreadyRegistered") {
        return "This email is already registered";
      }
      if (serverMessage != null && serverMessage.toString().isNotEmpty) {
        return serverMessage.toString();
      }
    } catch (_) {}

    return "Something went wrong, please try again";
  }

  Future<void> register(RegisterRequestModel req, BuildContext context) async {
    emit(AuthLoading());
    final appLocal = AppLocalizations.of(context)!;
    try {
      final resp = await repository.register(req);

      if (resp.success && resp.statusCode == 201) {
        emit(AuthRegisterSuccess("Registered successfully"));
      } else {
        final errorMessage = resp.errors?['message'];
        final fallbackMessage = resp.message;
        print("errorMessage $errorMessage");
        print("fallbackMessage $fallbackMessage");

        if (errorMessage != null && errorMessage.isNotEmpty) {
          if (errorMessage == "EmailAlreadyRegistered") {
            emit(AuthError(appLocal.emailAlreadyRegistered));
          } else if (errorMessage == "UserNameAlreadyRegistered") {
            emit(AuthError(appLocal.usernameAlreadyRegistered));
          } else {
            emit(AuthError(errorMessage));
          }
        } else if (fallbackMessage == "ValidationFailed") {
          emit(AuthError("Invalid input, please check your data"));
        } else {
          emit(AuthError(fallbackMessage ?? "Registration failed"));
        }
      }
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
    }
  }

  Future<void> login(LoginRequestModel body, BuildContext context) async {
    emit(AuthLoading());
    final appLocal = AppLocalizations.of(context)!;
    try {
      final response = await repository.login(body);

      if (response.success && response.data?.accessToken != null) {
        await repository.tokenStorage.savePassword(body.password);
        await repository.tokenStorage.saveUserId(response.data!.id!);
        await repository.tokenStorage.saveAccessToken(
          response.data!.accessToken!,
        );

        await profileRepository.getUserProfile(response.data!.id!);

        emit(
          AuthLoginSuccess(
            "Login successfully",
            token: response.data!.accessToken!,
          ),
        );
      } else {
        final serverMessage = response.errors?['message'] ?? response.message;

        switch (serverMessage) {
          case "EmailOrPassworIsIncorrect":
            emit(AuthError(appLocal.emailOrPasswordIncorrect));
            break;
          case "ValidationFailed":
            emit(AuthError("Invalid input, please check your data"));
            break;
          default:
            emit(AuthError(serverMessage ?? "Login failed"));
        }
      }
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await repository.revokeToken();
      await repository.tokenStorage.clear();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
    }
  }

  Future<void> changePassword(
    ChangePasswordRequestModel req,
    BuildContext context,
  ) async {
    emit(AuthLoading());
    final appLocal = AppLocalizations.of(context)!;
    try {
      final success = await repository.changePassword(req);

      if (success) {
        emit(AuthChangePasswordSuccess(appLocal.passwordChangedSuccessfully));
      } else {
        emit(AuthError("Change password failed"));
      }
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
    }
  }

  Future<void> revokeToken() async {
    emit(AuthLoading());
    try {
      final success = await repository.revokeToken();
      if (success) {
        await repository.tokenStorage.clear();
        emit(AuthLoggedOut());
      } else {
        emit(AuthError("Revoke token failed"));
      }
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
    }
  }

  Future<String?> sendPasswordResetToken(String email) async {
    emit(AuthLoading());
    try {
      final otp = await repository.sendPasswordResetToken(email);
      emit(AuthPasswordResetOTPSuccess(otp));
      return otp;
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
      return null;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      final success = await repository.resetPassword(
        email: email,
        newPassword: newPassword,
        token: otp,
      );
      if (success) {
        emit(AuthResetPasswordSuccess("Password changed successfully"));
      } else {
        emit(AuthError("Failed to reset password"));
      }
    } catch (e) {
      emit(AuthError(_mapErrorToMessage(e)));
    }
  }
}
