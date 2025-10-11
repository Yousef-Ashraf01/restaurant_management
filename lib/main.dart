import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/routes_generator.dart';
import 'package:restaurant_management/core/constants/app_theme.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/widgets/network_listener.dart';
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
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/banner_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/dish_cubit.dart';
import 'package:restaurant_management/features/auth/state/email_confirmation_cubit.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/auth/state/restaurant_cubit.dart';

import 'config/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  await tokenStorage.init();

  final dioClient = DioClient(tokenStorage);

  final authRemote = AuthRemoteDataSourceImpl(dioClient);
  final profileRemote = ProfileRemoteDataSourceImpl(dioClient);
  final addressRemote = AddressRemoteDataSourceImpl(dioClient);
  final restaurantRemote = RestaurantRemoteDataSourceImpl(dioClient);
  final bannerRemote = BannerRemoteDataSourceImpl(dioClient);
  final dishRemote = DishRemoteDataSourceImpl(dioClient);
  final cartRemote = CartRemoteDataSource(dioClient);
  final orderRemote = OrderRemoteDataSource(dioClient);

  final authRepository = AuthRepositoryImpl(
    remote: authRemote,
    tokenStorage: tokenStorage,
  );
  final profileRepository = ProfileRepository(profileRemote);
  final addressRepository = AddressRepositoryImpl(addressRemote);
  final restaurantRepository = RestaurantRepositoryImpl(restaurantRemote);
  final bannerRepository = BannerRepositoryImpl(bannerRemote);
  final dishRepository = DishRepositoryImpl(dishRemote);
  final cartRepository = CartRepository(cartRemote, tokenStorage);
  final orderRepository = OrderRepository(orderRemote);

  final accessToken = tokenStorage.getAccessToken();
  final initialRoute =
      (accessToken != null) ? AppRoutes.mainRoute : AppRoutes.loginRoute;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenStorage>.value(value: tokenStorage),
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
        RepositoryProvider<ProfileRepository>.value(value: profileRepository),
        RepositoryProvider<AddressRepository>.value(value: addressRepository),
        RepositoryProvider<RestaurantRepository>.value(
          value: restaurantRepository,
        ),
        RepositoryProvider<BannerRepository>.value(value: bannerRepository),
        RepositoryProvider<CartRepository>.value(value: cartRepository),
        RepositoryProvider<OrderRepository>.value(value: orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create:
                (context) => AuthCubit(
                  context.read<AuthRepositoryImpl>(),
                  context.read<ProfileRepository>(),
                ),
          ),
          BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()..loadLocale()),
          BlocProvider<RestaurantCubit>(
            create:
                (context) =>
                    RestaurantCubit(context.read<RestaurantRepository>()),
          ),
          BlocProvider<BannerCubit>(
            create:
                (context) =>
                    BannerCubit(context.read<BannerRepository>())..getBanners(),
          ),
          BlocProvider<DishCubit>(
            create: (context) => DishCubit(dishRepository)..getDishes(),
          ),
          BlocProvider<CartCubit>(
            create: (context) => CartCubit(cartRepository)..getCart(),
          ),
          BlocProvider<AddressCubit>(
            create:
                (context) => AddressCubit(context.read<AddressRepository>()),
          ),
          BlocProvider<OrderCubit>(
            create: (context) => OrderCubit(context.read<OrderRepository>()),
          ),
          BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit()),
          BlocProvider<EmailConfirmationCubit>(
            create:
                (context) => EmailConfirmationCubit(
                  context
                      .read<
                        AuthRepositoryImpl
                      >(), // أو لو ليه Repository خاص، عدّله هنا
                ),
          ),
        ],
        child: MyApp(initialRoute: initialRoute),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return ScaffoldMessenger(
              child: NetworkListener(
                showLottieDialogIfOffline: true,
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  onGenerateRoute: RouteGenerator.getRoute,
                  initialRoute: initialRoute,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: locale,
                  builder: (context, widget) {
                    ScreenUtil.ensureScreenSize();
                    return widget!;
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
