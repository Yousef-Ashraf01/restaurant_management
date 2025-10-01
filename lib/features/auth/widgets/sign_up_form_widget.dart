import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:restaurant_management/features/auth/data/models/register_response_model.dart';
import 'package:restaurant_management/features/auth/state/auth_cubit.dart';
import 'package:restaurant_management/features/auth/state/auth_state.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_formKey.currentState!.validate()) {
      final body = RegisterRequestModel(
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        userName: _usernameController.text.trim(),
      );

      context.read<AuthCubit>().register(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextFormField(
                label: AppLocalizations.of(context)!.firstName,
                hint: AppLocalizations.of(context)!.enterFirstName,
                keyboardType: TextInputType.text,
                controller: _firstNameController,
                validator:
                    (value) => Validators.requiredField(
                      context,
                      value,
                      AppLocalizations.of(context)!.firstName,
                    ),
              ),
              SizedBox(height: 20.h),

              AppTextFormField(
                label: AppLocalizations.of(context)!.lastName,
                hint: AppLocalizations.of(context)!.enterLastName,
                keyboardType: TextInputType.text,
                controller: _lastNameController,
                validator:
                    (value) => Validators.requiredField(
                      context,
                      value,
                      AppLocalizations.of(context)!.lastName,
                    ),
              ),
              SizedBox(height: 20.h),

              AppTextFormField(
                label: AppLocalizations.of(context)!.userName,
                hint: AppLocalizations.of(context)!.enterUserName,
                keyboardType: TextInputType.text,
                controller: _usernameController,
                validator: (value) => Validators.username(context, value),
              ),
              SizedBox(height: 20.h),

              AppTextFormField(
                label: AppLocalizations.of(context)!.email,
                hint: AppLocalizations.of(context)!.enterEmail,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) => Validators.email(context, value),
              ),
              SizedBox(height: 20.h),

              AppTextFormField(
                label: AppLocalizations.of(context)!.phoneNumber,
                hint: AppLocalizations.of(context)!.enterPhoneNumber,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                validator: (value) => Validators.phone(context, value),
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
              SizedBox(height: 20.h),

              AppTextFormField(
                label: AppLocalizations.of(context)!.confirmPassword,
                hint: AppLocalizations.of(context)!.reEnterPassword,
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
              SizedBox(height: 30.h),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(
                    text: AppLocalizations.of(context)!.createAccount,
                    onPressed: _onCreateAccount,
                  ),

              SizedBox(height: 12.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.haveAccount,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13.sp,
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 5.w)),
                    TextSpan(
                      text: AppLocalizations.of(context)!.loginn,
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
                                AppRoutes.loginRoute,
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
