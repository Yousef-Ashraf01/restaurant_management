import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';

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
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                print("Forgot Password");
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          AppButton(text: "Login", onPressed: _onLogin),
          SizedBox(height: 12.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Don't you have an account ?",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13.sp),
                ),
                WidgetSpan(child: SizedBox(width: 5.w)),
                TextSpan(
                  text: "Create a new account",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, AppRoutes.signUpRoute);
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
