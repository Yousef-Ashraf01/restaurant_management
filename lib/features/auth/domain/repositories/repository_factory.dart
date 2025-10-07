// import 'package:restaurant_management/core/network/dio_client.dart';
// import 'package:restaurant_management/core/network/token_storage.dart';
// import 'package:restaurant_management/features/auth/data/datasources/address_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/banner_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/cart_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/dish_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/order_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/data/datasources/restaurant_remote_data_source.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/banner_repository.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/cart_repository.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/dish_repository.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/order_repository.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
// import 'package:restaurant_management/features/auth/domain/repositories/restaurant_repository.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class RepositoryFactory {
//   static Future<Map<String, dynamic>> createAll() async {
//     final prefs = await SharedPreferences.getInstance();
//     final tokenStorage = TokenStorage(prefs);
//
//     final dioClient = DioClient(tokenStorage);
//
//     // ✅ RemoteDataSources
//     final authRemote = AuthRemoteDataSourceImpl(dioClient);
//     final addressRemote = AddressRemoteDataSourceImpl(dioClient);
//     final bannerRemote = BannerRemoteDataSourceImpl(dioClient);
//     final cartRemote = CartRemoteDataSource(
//       dioClient,
//     ); // بعد تعديل CartRemoteDataSource
//     final dishRemote = DishRemoteDataSourceImpl(dioClient);
//     final orderRemote = OrderRemoteDataSource(dioClient);
//     final profileRemote = ProfileRemoteDataSourceImpl(dioClient);
//     final restaurantRemote = RestaurantRemoteDataSourceImpl(dioClient);
//
//     // ✅ Repositories
//     final authRepository = AuthRepositoryImpl(
//       remote: authRemote,
//       tokenStorage: tokenStorage,
//     );
//     final addressRepository = AddressRepositoryImpl(addressRemote);
//     final bannerRepository = BannerRepositoryImpl(bannerRemote);
//     final cartRepository = CartRepository(cartRemote, tokenStorage);
//     final dishRepository = DishRepositoryImpl(dishRemote);
//     final orderRepository = OrderRepository(orderRemote);
//     final profileRepository = ProfileRepository(profileRemote);
//     final restaurantRepository = RestaurantRepositoryImpl(restaurantRemote);
//
//     return {
//       "authRepository": authRepository,
//       "addressRepository": addressRepository,
//       "bannerRepository": bannerRepository,
//       "cartRepository": cartRepository,
//       "dishRepository": dishRepository,
//       "orderRepository": orderRepository,
//       "profileRepository": profileRepository,
//       "restaurantRepository": restaurantRepository,
//       "dioClient": dioClient,
//       "tokenStorage": tokenStorage,
//     };
//   }
// }
