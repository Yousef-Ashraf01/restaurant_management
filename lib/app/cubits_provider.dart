import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_cubit.dart';
import 'package:restaurant_management/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:restaurant_management/features/confirm_email/presentation/cubit/email_confirmation_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/category_cubit.dart';
import 'package:restaurant_management/features/home/presentation/cubit/dish_cubit.dart';
import 'package:restaurant_management/features/language/presentation/cubit/local_cubit.dart';
import 'package:restaurant_management/features/orders/presentation/cubit/order_cubit.dart';
import 'package:restaurant_management/features/profile/data/datasources/address_remote_data_source.dart';
import 'package:restaurant_management/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/profile/data/repositories/address_repository.dart';
import 'package:restaurant_management/features/profile/data/repositories/profile_repository.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_cubit.dart';
import 'package:restaurant_management/features/restaurant_info/presentation/cubit/restaurant_cubit.dart';

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
          create:
              (_) => ProfileRepository(ProfileRemoteDataSourceImpl(dioClient)),
        ),
        RepositoryProvider<AddressRepository>(
          create:
              (_) =>
                  AddressRepositoryImpl(AddressRemoteDataSourceImpl(dioClient)),
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
