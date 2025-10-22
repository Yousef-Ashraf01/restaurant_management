import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/core/widgets/auth_header.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/widgets/language_dropdown.dart';
import 'package:restaurant_management/features/auth/widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>(); // جاهز من CubitsProvider
    final isConnected = context.watch<ConnectivityCubit>().state;

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

    return BlocProvider.value(
      value: authCubit,
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
  }
}
