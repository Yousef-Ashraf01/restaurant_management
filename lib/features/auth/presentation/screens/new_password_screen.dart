import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:restaurant_management/features/auth/presentation/cubit/auth_state.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  OtpFieldController otpController = OtpFieldController();
  String otpCode = "";

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpController.setFocus(0);
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (otpCode.length != 6) {
        showAppSnackBar(
          context,
          message: "OTP is invalid, please try again",
          type: SnackBarType.error,
        );
        otpController.clear();
        return;
      }

      context.read<AuthCubit>().resetPassword(
        email: _emailController.text.trim(),
        newPassword: _passwordController.text.trim(),
        otp: otpCode,
      );
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
              if (state is AuthResetPasswordSuccess) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.success,
                );
                Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
              } else if (state is AuthError) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.error,
                );
                otpController.clear();
                _emailController.clear();
                _passwordController.clear();
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.mailConfirmed +
                                      "\n",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                TextSpan(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.chooseNewPassword,
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
                                OTPTextField(
                                  keyboardType: TextInputType.number,
                                  controller: otpController,
                                  length: 6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceAround,
                                  fieldWidth: 45,
                                  fieldStyle: FieldStyle.box,
                                  outlineBorderRadius: 15,
                                  style: const TextStyle(fontSize: 17),
                                  onCompleted: (pin) => otpCode = pin,
                                ),
                                SizedBox(height: 20.h),
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
                                    suffixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator:
                                      (value) =>
                                          Validators.email(context, value),
                                ),
                                SizedBox(height: 20.h),
                                AppTextFormField(
                                  label: "New Password",
                                  hint: "Enter your new password",
                                  isPassword: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: _passwordController,
                                  validator:
                                      (value) =>
                                          Validators.password(context, value),
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
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.confirm,
                                          onPressed:
                                              () => _resetPassword(context),
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
