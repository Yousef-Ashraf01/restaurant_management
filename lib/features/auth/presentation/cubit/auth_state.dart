abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final String message;
  final String token;
  AuthRegisterSuccess(this.message, {required this.token});
}

class AuthLoginSuccess extends AuthState {
  final String message;
  final String token;

  AuthLoginSuccess(this.message, {required this.token});
}

class AuthLoggedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthTokenRefreshed extends AuthState {
  final String message;
  AuthTokenRefreshed(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthChangePasswordSuccess extends AuthState {
  final String message;
  AuthChangePasswordSuccess(this.message);
}

class AuthPasswordResetOTPSuccess extends AuthState {
  final String otp;
  AuthPasswordResetOTPSuccess(this.otp);
}

class AuthResetPasswordSuccess extends AuthState {
  final String message;
  AuthResetPasswordSuccess(this.message);
}
