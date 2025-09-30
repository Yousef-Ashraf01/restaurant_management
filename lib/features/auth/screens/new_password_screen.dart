import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/validators.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_text_form_field.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppUnfocusWrapper(
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
                            text: "Mail ownership has been confirmed\n",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          TextSpan(text: "choose a new password"),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                (value) => Validators.confirmPassword(
                                  value,
                                  _passwordController.text,
                                ),
                          ),
                          SizedBox(height: 35.h),
                          AppButton(text: "Confirm", onPressed: () {}),
                          SizedBox(height: 17.h),
                          AppButton(
                            text: "Cancel",
                            onPressed: () {},
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
  }
}
