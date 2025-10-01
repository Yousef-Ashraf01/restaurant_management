import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/core/widgets/auth_header.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';
import 'package:restaurant_management/features/auth/widgets/sign_up_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ import localization


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  Future<Map<String, dynamic>> _initRepositories() async {
    debugPrint("⏳ Initializing repositories...");

    final prefs = await SharedPreferences.getInstance();
    debugPrint("✅ SharedPreferences initialized");

    final dio = Dio(
      BaseOptions(
        baseUrl: "https://restaurantmanagementsystem.runasp.net",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    )..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );

    final authRemote = AuthRemoteDataSourceImpl(dio);
    final profileRemote = ProfileRemoteDataSourceImpl(dio);

    final tokenStorage = TokenStorage(prefs);

    final authRepository = AuthRepositoryImpl(
      remote: authRemote,
      tokenStorage: tokenStorage,
    );

    final profileRepository = ProfileRepository(profileRemote);

    debugPrint("✅ Repositories ready");

    return {
      "authRepository": authRepository,
      "profileRepository": profileRepository,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initRepositories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Repositories not initialized")),
          );
        }

        final authRepository = snapshot.data!["authRepository"] as AuthRepositoryImpl;
        final profileRepository = snapshot.data!["profileRepository"] as ProfileRepository;

        return BlocProvider(
          create: (_) => AuthCubit(authRepository, profileRepository),
          child: AppUnfocusWrapper(
            child: Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AuthHeader(title: AppLocalizations.of(context)!.signUp),
                    SizedBox(height: 30.h),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthRegisterSuccess) {
                          Navigator.pushNamed(context, AppRoutes.loginRoute);
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            const SignUpFormWidget(),
                            SizedBox(height: 20.h),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
