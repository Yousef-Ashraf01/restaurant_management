import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';

part 'email_confirmation_state.dart';

class EmailConfirmationCubit extends Cubit<EmailConfirmationState> {
  final AuthRepositoryImpl authRepository;

  EmailConfirmationCubit(this.authRepository) : super(EmailConfirmationInitial());

  Future<void> sendCode(String userId) async {
    emit(EmailConfirmationLoading());
    try {
      final code = await authRepository.sendEmailConfirmationToken(userId);
      if (code != null) {
        emit(EmailConfirmationCodeSent(code));
      } else {
        emit(EmailConfirmationError("Failed to send confirmation code"));
      }
    } catch (e) {
      emit(EmailConfirmationError(e.toString()));
    }
  }

  Future<void> verifyCode(String userId, String token) async {
    emit(EmailConfirmationLoading());
    try {
      final success = await authRepository.confirmEmail(userId, token);
      if (success) {
        emit(EmailConfirmationVerified());
      } else {
        emit(EmailConfirmationError("Invalid confirmation code"));
      }
    } catch (e) {
      emit(EmailConfirmationError(e.toString()));
    }
  }
}
