import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/datasources/address_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/banner_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/category_cubit.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_cubit.dart';
import 'package:restaurant_management/features/auth/state/email_confirmation_cubit.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/auth/state/restaurant_cubit.dart';

class CubitsProvider extends StatelessWidget {
  final Map<String, dynamic> repositories;
  final TokenStorage tokenStorage;
  final Widget child;

  const CubitsProvider({
    super.key,
    required this.repositories,
    required this.tokenStorage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient(tokenStorage);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepository(ProfileRemoteDataSourceImpl(dioClient)),
        ),
        RepositoryProvider<AddressRepository>(
          create: (_) => AddressRepositoryImpl(AddressRemoteDataSourceImpl(dioClient)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create:
                (_) => AuthCubit(repositories['auth'], repositories['profile']),
          ),
          BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()..loadLocale()),
          BlocProvider<RestaurantCubit>(
            create: (_) => RestaurantCubit(repositories['restaurant']),
          ),
          BlocProvider<BannerCubit>(
            create: (_) => BannerCubit(repositories['banner']),
          ),
          BlocProvider<DishCubit>(
            create: (_) => DishCubit(repositories['dish']),
          ),
          BlocProvider<CartCubit>(
            create: (_) => CartCubit(repositories['cart']),
          ),
          BlocProvider<AddressCubit>(
            create: (_) => AddressCubit(repositories['address'], tokenStorage),
          ),
          BlocProvider<OrderCubit>(
            create: (_) => OrderCubit(repositories['order']),
          ),
          BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit()),
          BlocProvider<EmailConfirmationCubit>(
            create: (_) => EmailConfirmationCubit(repositories['auth']),
          ),
          BlocProvider<CategoryCubit>(
            create: (_) => CategoryCubit(repositories['category']),
          ),
        ],
        child: child,
      ),
    );
  }
}
