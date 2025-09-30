import 'package:dio/dio.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryFactory {
  static Future<AuthRepositoryImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    final dio = Dio(BaseOptions(baseUrl: "https://your-base-url.com"));

    final remote = AuthRemoteDataSourceImpl(dio);
    final storage = TokenStorage(prefs);

    return AuthRepositoryImpl(remote: remote, tokenStorage: storage);
  }
}
