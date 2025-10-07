import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
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
                                text: AppLocalizations.of(context)!.mailConfirmed + "\n",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.chooseNewPassword,
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
                              AppTextFormField(
                                label: AppLocalizations.of(context)!.password,
                                hint: AppLocalizations.of(context)!.enterPassword,
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passwordController,
                                validator: (value) =>
                                    Validators.password(context, value),
                              ),
                              SizedBox(height: 20.h),
                              AppTextFormField(
                                label: AppLocalizations.of(context)!.confirmPassword,
                                hint: AppLocalizations.of(context)!.reEnterPassword,
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _confirmPasswordController,
                                validator: (value) => Validators.confirmPassword(
                                  context,
                                  value,
                                  _passwordController.text,
                                ),
                              ),
                              SizedBox(height: 35.h),
                              AppButton(
                                text: AppLocalizations.of(context)!.confirm,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // هنا هتضيف الكود الخاص بإرسال الباسورد الجديد
                                  }
                                },
                              ),
                              SizedBox(height: 17.h),
                              AppButton(
                                text: AppLocalizations.of(context)!.cancel,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[500],
                                ),
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
        );
      },
    );
  }
}
