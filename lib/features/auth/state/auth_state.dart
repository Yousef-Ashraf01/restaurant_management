abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final String message;
  AuthRegisterSuccess(this.message);
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

class AuthChangePasswordSuccess extends AuthState {
  final String message;
  AuthChangePasswordSuccess(this.message);
}
