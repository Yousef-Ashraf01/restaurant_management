import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/core/widgets/auth_header.dart';
import 'package:restaurant_management/features/auth/widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppUnfocusWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  AuthHeader(title: "Login"),
                  SizedBox(height: 30.h),
                  const LoginFormWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
