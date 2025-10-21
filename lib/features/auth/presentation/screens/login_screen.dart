import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/core/widgets/auth_header.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_management/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:restaurant_management/features/auth/presentation/cubit/auth_state.dart';
import 'package:restaurant_management/features/auth/presentation/widgets/language_dropdown.dart';
import 'package:restaurant_management/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:restaurant_management/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/profile/data/repositories/profile_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<Map<String, dynamic>> _initRepositories() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.init();
    final dioClient = DioClient(tokenStorage);

    final authRemote = AuthRemoteDataSourceImpl(dioClient);
    final profileRemote = ProfileRemoteDataSourceImpl(dioClient);

    final authRepository = AuthRepositoryImpl(
      remote: authRemote,
      tokenStorage: tokenStorage,
    );
    final profileRepository = ProfileRepository(profileRemote);

    return {
      "authRepository": authRepository,
      "profileRepository": profileRepository,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.asset(
                      'assets/animations/noInternetConnection.json',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No internet connection\nPlease connect to the internet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

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

            final authRepository =
                snapshot.data!["authRepository"] as AuthRepositoryImpl;
            final profileRepository =
                snapshot.data!["profileRepository"] as ProfileRepository;

            return BlocProvider(
              create: (_) => AuthCubit(authRepository, profileRepository),
              child: AppUnfocusWrapper(
                child: Scaffold(
                  body: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        const LanguageDropdown(),
                        AuthHeader(title: AppLocalizations.of(context)!.login),
                        SizedBox(height: 30.h),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthLoginSuccess) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.mainRoute,
                                (route) => false,
                              );
                            } else if (state is AuthError) {
                              showAppSnackBar(
                                context,
                                message: state.message,
                                type: SnackBarType.error,
                              );
                            }
                          },
                          builder: (context, state) {
                            return const LoginFormWidget();
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
      },
    );
  }
}
