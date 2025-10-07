import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/core/widgets/auth_header.dart';
import 'package:restaurant_management/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/datasources/profile_remote_data_source.dart';
import 'package:restaurant_management/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/widgets/language_dropdown.dart';
import 'package:restaurant_management/features/auth/widgets/sign_up_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  Future<Map<String, dynamic>> _initRepositories() async {
    debugPrint("⏳ Initializing repositories...");

    // ✅ تهيئة SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final tokenStorage = TokenStorage(prefs);

    // ✅ إنشاء DioClient المخصص بتاعك
    final dioClient = DioClient(tokenStorage);

    // ✅ تمرير نفس الـ dioClient لكل RemoteDataSource
    final authRemote = AuthRemoteDataSourceImpl(dioClient);
    final profileRemote = ProfileRemoteDataSourceImpl(dioClient);

    // ✅ إنشاء الـ Repositories
    final authRepository = AuthRepositoryImpl(
      remote: authRemote,
      tokenStorage: tokenStorage,
    );
    final profileRepository = ProfileRepository(profileRemote);

    debugPrint("✅ Repositories ready with DioClient");

    return {
      "authRepository": authRepository,
      "profileRepository": profileRepository,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        // ✅ في حالة عدم وجود إنترنت
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

        // ✅ تحميل الـ repositories أول مرة
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

            // ✅ استرجاع الـ repositories بعد تهيئتها
            final authRepository =
            snapshot.data!["authRepository"] as AuthRepositoryImpl;
            final profileRepository =
            snapshot.data!["profileRepository"] as ProfileRepository;

            // ✅ BlocProvider يحقن الـ Cubit مع الـ repositories
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
                        AuthHeader(title: AppLocalizations.of(context)!.signUp),
                        SizedBox(height: 30.h),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthRegisterSuccess) {
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
      },
    );
  }
}