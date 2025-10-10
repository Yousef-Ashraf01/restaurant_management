import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendOtp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      try {
        await context.read<AuthCubit>().sendPasswordResetToken(email);
      } catch (e) {
        showAppSnackBar(
          context,
          message: e.toString(),
          type: SnackBarType.error,
        );
      }
    }
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

        return AppUnfocusWrapper(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthPasswordResetOTPSuccess) {
                showAppSnackBar(
                  context,
                  message: "A code has been sent to your email",
                  type: SnackBarType.success,
                );
                Navigator.pushNamed(
                  context,
                  AppRoutes.newPasswordRoute,
                  arguments: _emailController.text.trim(),
                );
              } else if (state is AuthError) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.error,
                );
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "Enter your email address\n",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                WidgetSpan(child: SizedBox(height: 26.h)),
                                TextSpan(
                                  text:
                                      "and you will receive a confirmation message",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.email,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.text,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(
                                          context,
                                        )!.enterEmail,
                                    hintStyle: TextStyle(color: AppColors.text),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                    suffixIcon: const Icon(Icons.email_rounded),
                                  ),
                                  validator:
                                      (value) =>
                                          Validators.email(context, value),
                                ),
                                SizedBox(height: 35.h),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state is AuthLoading;
                                    return isLoading
                                        ? SizedBox(
                                          height: 50.h,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                        : AppButton(
                                          text: "Next",
                                          onPressed: () => _sendOtp(context),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
