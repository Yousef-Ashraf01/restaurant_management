import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ import localization
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/routes_generator.dart';
import 'package:restaurant_management/core/constants/app_theme.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/datasources/address_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final tokenStorage = TokenStorage(prefs);
  final apiClient = DioClient(tokenStorage).dio;

  // Remote data sources
  final authRemote = AuthRemoteDataSourceImpl(apiClient);
  final profileRemote = ProfileRemoteDataSourceImpl(apiClient);
  final addressRemote = AddressRemoteDataSourceImpl(apiClient);

  // Repositories
  final authRepository = AuthRepositoryImpl(
    remote: authRemote,
    tokenStorage: tokenStorage,
  );
  final profileRepository = ProfileRepository(profileRemote);
  final addressRepository = AddressRepositoryImpl(addressRemote);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
        RepositoryProvider<ProfileRepository>.value(value: profileRepository),
        RepositoryProvider<AddressRepository>.value(value: addressRepository),
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
          BlocProvider<LocaleCubit>(
            create:
                (_) =>
                    LocaleCubit()
                      ..loadLocale(), // 👈 يجيب اللغة من SharedPreferences
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute: AppRoutes.loginRoute,

              // ✅ Localization settings
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale, // 👈 دلوقتي Dynamic من Cubit

              builder: (context, widget) {
                ScreenUtil.ensureScreenSize();
                return widget!;
              },
            );
          },
        );
      },
    );
  }
}
