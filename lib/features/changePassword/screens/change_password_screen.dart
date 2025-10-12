import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/data/models/change_password_request_model.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';

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

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) => AppTextFormField(
    label: label,
    hint: hint,
    isPassword: true,
    keyboardType: TextInputType.visiblePassword,
    controller: controller,
    validator: validator,
  );

  Future<void> _handleChangePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final isConnected = context.read<ConnectivityCubit>().state;
    if (!isConnected) {
      showAppSnackBar(
        context,
        message: AppLocalizations.of(context)!.noInternetConnection,
        type: SnackBarType.error,
      );
      return;
    }

    final tokenStorage = TokenStorage();
    await tokenStorage.init();
    final userId = tokenStorage.getUserId();
    if (userId == null) {
      showAppSnackBar(
        context,
        message: AppLocalizations.of(context)!.userIdNotFound,
        type: SnackBarType.error,
      );
      return;
    }

    context.read<AuthCubit>().changePassword(
      ChangePasswordRequestModel(
        userId: userId,
        currentPassword: _oldPasswordController.text.trim(),
        newPassword: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return Scaffold(
            appBar: AppBar(title: Text(loc.changePassword), centerTitle: true),
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
                  Text(
                    AppLocalizations.of(context)!.noInternetConnection,
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
            appBar: AppBar(title: Text(loc.changePassword), centerTitle: true),
            body: SafeArea(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    showAppSnackBar(
                      context,
                      message: state.message,
                      type: SnackBarType.error,
                    );
                  } else if (state is AuthChangePasswordSuccess) {
                    showAppSnackBar(
                      context,
                      message: state.message,
                      type: SnackBarType.success,
                    );
                    Navigator.pop(context);
                  }
                },
                builder:
                    (context, state) => SingleChildScrollView(
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _buildPasswordField(
                                      label: loc.oldPassword,
                                      hint: loc.enterTheOldPassword,
                                      controller: _oldPasswordController,
                                      validator: (value) {
                                        final savedPassword =
                                            context
                                                .read<AuthCubit>()
                                                .repository
                                                .tokenStorage
                                                .getPassword();
                                        return Validators.oldPassword(
                                          context,
                                          value,
                                          savedPassword,
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildPasswordField(
                                      label: loc.password,
                                      hint: loc.enterPassword,
                                      controller: _passwordController,
                                      validator:
                                          (value) => Validators.password(
                                            context,
                                            value,
                                          ),
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildPasswordField(
                                      label: loc.confirmPassword,
                                      hint: loc.reEnterPassword,
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
                                          text: loc.confirm,
                                          onPressed:
                                              () => _handleChangePassword(
                                                context,
                                              ),
                                        ),
                                    SizedBox(height: 17.h),
                                    AppButton(
                                      text: loc.cancel,
                                      onPressed: () => Navigator.pop(context),
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
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
