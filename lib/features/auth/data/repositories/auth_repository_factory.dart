import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/repositories/auth_repository_impl.dart';

class AuthRepositoryFactory {
  static Future<AuthRepositoryImpl> create() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();
    final dioClient = DioClient(tokenStorage);

    final remote = AuthRemoteDataSourceImpl(dioClient);

    return AuthRepositoryImpl(remote: remote, tokenStorage: tokenStorage);
  }
}
