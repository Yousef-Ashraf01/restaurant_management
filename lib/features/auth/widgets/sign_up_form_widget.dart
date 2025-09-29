import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            label: "User Name",
            hint: "Enter your user name",
            keyboardType: TextInputType.text,
            controller: _usernameController,
            validator: (value) => Validators.username(value),
          ),
          SizedBox(height: 20.h),
          AppTextFormField(
            label: "Email",
            hint: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) => Validators.email(value),
          ),
          SizedBox(height: 20.h),
          AppTextFormField(
            label: "Password",
            hint: "Enter your password",
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            validator: (value) => Validators.password(value),
          ),
          SizedBox(height: 20.h),
          AppTextFormField(
            label: "Confirm Password",
            hint: "Re-enter your password",
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
            controller: _confirmPasswordController,
            validator:
                (value) =>
                    Validators.confirmPassword(value, _passwordController.text),
          ),
          SizedBox(height: 30.h),
          AppButton(text: "Create Account", onPressed: _onCreateAccount),
          SizedBox(height: 12.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Do you have an account ?",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13.sp),
                ),
                WidgetSpan(child: SizedBox(width: 5.w)),
                TextSpan(
                  text: "Log in",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.loginRoute);
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
