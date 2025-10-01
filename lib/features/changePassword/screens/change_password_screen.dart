import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/data/models/change_password_request_model.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppUnfocusWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text("Change Password"), centerTitle: true),
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthChangePasswordSuccess) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
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
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppTextFormField(
                                label: "Old Password",
                                hint: 'Enter the old password',
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _oldPasswordController,
                                validator:
                                    (value) =>
                                        Validators.password(context, value),
                              ),
                              SizedBox(height: 20.h),
                              AppTextFormField(
                                label: AppLocalizations.of(context)!.password,
                                hint:
                                    AppLocalizations.of(context)!.enterPassword,
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passwordController,
                                validator:
                                    (value) =>
                                        Validators.password(context, value),
                              ),
                              SizedBox(height: 20.h),
                              AppTextFormField(
                                label:
                                    AppLocalizations.of(
                                      context,
                                    )!.confirmPassword,
                                hint:
                                    AppLocalizations.of(
                                      context,
                                    )!.reEnterPassword,
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _confirmPasswordController,
                                validator:
                                    (value) => Validators.confirmPassword(
                                      context,
                                      value,
                                      _passwordController.text,
                                    ),
                              ),
                              SizedBox(height: 35.h),

                              state is AuthLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : AppButton(
                                    text: AppLocalizations.of(context)!.confirm,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final tokenStorage = TokenStorage(
                                          await SharedPreferences.getInstance(),
                                        );
                                        final userId = tokenStorage.getUserId();
                                        if (userId == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "User ID not found!",
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        context
                                            .read<AuthCubit>()
                                            .changePassword(
                                              ChangePasswordRequestModel(
                                                userId: userId,
                                                currentPassword:
                                                    _oldPasswordController.text
                                                        .trim(),
                                                newPassword:
                                                    _passwordController.text
                                                        .trim(),
                                                confirmPassword:
                                                    _confirmPasswordController
                                                        .text
                                                        .trim(),
                                              ),
                                            );
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
                              SizedBox(height: 60.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
