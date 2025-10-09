import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/di/app_initializer.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/banner_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_cubit.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/auth/state/restaurant_cubit.dart';

class AppProviders {
  static final repositories = [
    RepositoryProvider.value(value: AppInitializer.tokenStorage),
    RepositoryProvider.value(value: AppInitializer.authRepository),
    RepositoryProvider.value(value: AppInitializer.profileRepository),
    RepositoryProvider.value(value: AppInitializer.addressRepository),
    RepositoryProvider.value(value: AppInitializer.restaurantRepository),
    RepositoryProvider.value(value: AppInitializer.bannerRepository),
    RepositoryProvider.value(value: AppInitializer.cartRepository),
    RepositoryProvider.value(value: AppInitializer.orderRepository),
  ];

  static final blocs = [
    BlocProvider<AuthCubit>(
      create:
          (context) => AuthCubit(
            AppInitializer.authRepository,
            AppInitializer.profileRepository,
          ),
    ),
    BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()..loadLocale()),
    BlocProvider<RestaurantCubit>(
      create: (context) => RestaurantCubit(AppInitializer.restaurantRepository),
    ),
    BlocProvider<BannerCubit>(
      create:
          (context) =>
              BannerCubit(AppInitializer.bannerRepository)..getBanners(),
    ),
    BlocProvider<DishCubit>(
      create:
          (context) => DishCubit(AppInitializer.dishRepository)..getDishes(),
    ),
    BlocProvider<CartCubit>(
      create: (context) => CartCubit(AppInitializer.cartRepository)..getCart(),
    ),
    BlocProvider<AddressCubit>(
      create: (context) => AddressCubit(AppInitializer.addressRepository),
    ),
    BlocProvider<OrderCubit>(
      create: (context) => OrderCubit(AppInitializer.orderRepository),
    ),
    BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit()),
  ];
}
