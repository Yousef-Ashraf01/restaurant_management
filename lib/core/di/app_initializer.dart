import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/datasources/address_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/banner_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/cart_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/dish_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/restaurant_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:restaurant_management/features/auth/domain/repositories/banner_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/cart_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/dish_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/order_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/restaurant_repository.dart';

class AppInitializer {
  static late TokenStorage tokenStorage;
  static late String initialRoute;

  static late AuthRepositoryImpl authRepository;
  static late ProfileRepository profileRepository;
  static late AddressRepository addressRepository;
  static late RestaurantRepository restaurantRepository;
  static late BannerRepository bannerRepository;
  static late DishRepository dishRepository;
  static late CartRepository cartRepository;
  static late OrderRepository orderRepository;

  static Future<void> initialize() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();

    final dioClient = DioClient(tokenStorage);

    // Remote data sources
    final authRemote = AuthRemoteDataSourceImpl(dioClient);
    final profileRemote = ProfileRemoteDataSourceImpl(dioClient);
    final addressRemote = AddressRemoteDataSourceImpl(dioClient);
    final restaurantRemote = RestaurantRemoteDataSourceImpl(dioClient);
    final bannerRemote = BannerRemoteDataSourceImpl(dioClient);
    final dishRemote = DishRemoteDataSourceImpl(dioClient);
    final cartRemote = CartRemoteDataSource(dioClient);
    final orderRemote = OrderRemoteDataSource(dioClient);

    // Repositories
    authRepository = AuthRepositoryImpl(
      remote: authRemote,
      tokenStorage: tokenStorage,
    );
    profileRepository = ProfileRepository(profileRemote);
    addressRepository = AddressRepositoryImpl(addressRemote);
    restaurantRepository = RestaurantRepositoryImpl(restaurantRemote);
    bannerRepository = BannerRepositoryImpl(bannerRemote);
    dishRepository = DishRepositoryImpl(dishRemote);
    cartRepository = CartRepository(cartRemote, tokenStorage);
    orderRepository = OrderRepository(orderRemote);

    // // Auth Manager
    // final authManager = AuthManager(
    //     tokenStorage: tokenStorage, dio: dioClient.dio);
    // final hasSession = await authManager.checkSession();

    // initialRoute = hasSession ? AppRoutes.mainRoute : AppRoutes.loginRoute;
  }
}
