import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/models/login_request_model.dart';
import '../state/auth_cubit.dart';
import '../state/auth_state.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      final body = LoginRequestModel(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      context.read<AuthCubit>().login(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.mainRoute);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextFormField(
                label: AppLocalizations.of(context)!.email,
                hint: AppLocalizations.of(context)!.enterEmail,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) => Validators.email(context, value),
              ),
              SizedBox(height: 20.h),
              AppTextFormField(
                label: AppLocalizations.of(context)!.password,
                hint: AppLocalizations.of(context)!.enterPassword,
                isPassword: true,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                validator: (value) => Validators.password(context, value),
              ),
              SizedBox(height: 5.h),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.newPasswordRoute);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(text: AppLocalizations.of(context)!.login, onPressed: _onLogin),
              SizedBox(height: 12.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.noAccount,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13.sp,
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 5.w)),
                    TextSpan(
                      text: AppLocalizations.of(context)!.createNewAccount,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.signUpRoute,
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
