import 'package:restaurant_management/features/auth/data/models/auth_response_model.dart';
import 'package:restaurant_management/features/auth/data/models/login_request_model.dart';
import 'package:restaurant_management/features/auth/data/models/register_request_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> register(RegisterRequestModel model);
  Future<AuthResponseModel> login(LoginRequestModel model);
}
