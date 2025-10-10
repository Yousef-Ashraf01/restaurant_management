part of 'email_confirmation_cubit.dart';

@immutable
abstract class EmailConfirmationState {}

class EmailConfirmationInitial extends EmailConfirmationState {}
class EmailConfirmationLoading extends EmailConfirmationState {}
class EmailConfirmationCodeSent extends EmailConfirmationState {
  final String code;
  EmailConfirmationCodeSent(this.code);
}
class EmailConfirmationVerified extends EmailConfirmationState {}
class EmailConfirmationError extends EmailConfirmationState {
  final String message;
  EmailConfirmationError(this.message);
}
