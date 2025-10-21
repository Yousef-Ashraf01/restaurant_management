import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/datasources/address_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/banner_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/cart_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/category_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/dish_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/restaurant_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:restaurant_management/features/auth/domain/repositories/banner_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/cart_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/category_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/dish_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/order_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/restaurant_repository.dart';

Future<Map<String, dynamic>> createRepositories(
  DioClient dioClient,
  TokenStorage tokenStorage,
) async {
  final authRemote = AuthRemoteDataSourceImpl(dioClient);
  final profileRemote = ProfileRemoteDataSourceImpl(dioClient);
  final addressRemote = AddressRemoteDataSourceImpl(dioClient);
  final restaurantRemote = RestaurantRemoteDataSourceImpl(dioClient);
  final bannerRemote = BannerRemoteDataSourceImpl(dioClient);
  final dishRemote = DishRemoteDataSourceImpl(dioClient);
  final categoryRemote = CategoryRemoteDataSourceImpl(dioClient);
  final cartRemote = CartRemoteDataSource(dioClient);
  final orderRemote = OrderRemoteDataSource(dioClient);

  return {
    'auth': AuthRepositoryImpl(remote: authRemote, tokenStorage: tokenStorage),
    'profile': ProfileRepository(profileRemote),
    'address': AddressRepositoryImpl(addressRemote),
    'restaurant': RestaurantRepositoryImpl(restaurantRemote),
    'banner': BannerRepositoryImpl(bannerRemote),
    'dish': DishRepositoryImpl(dishRemote),
    'category': CategoryRepositoryImpl(categoryRemote),
    'cart': CartRepository(cartRemote, tokenStorage),
    'order': OrderRepository(orderRemote),
  };
}

class RepositoriesProvider extends StatelessWidget {
  final Map<String, dynamic> repositories;
  final Widget child;

  const RepositoriesProvider({
    super.key,
    required this.repositories,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repositories['auth']),
        RepositoryProvider.value(value: repositories['profile']),
        RepositoryProvider.value(value: repositories['address']),
        RepositoryProvider.value(value: repositories['restaurant']),
        RepositoryProvider.value(value: repositories['banner']),
        RepositoryProvider.value(value: repositories['dish']),
        RepositoryProvider.value(value: repositories['category']),
        RepositoryProvider.value(value: repositories['cart']),
        RepositoryProvider.value(value: repositories['order']),
      ],
      child: child,
    );
  }
}
