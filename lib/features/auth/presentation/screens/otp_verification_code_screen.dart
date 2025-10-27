import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/widgets/app_button.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/confirm_email/presentation/cubit/email_confirmation_cubit.dart';
import 'package:restaurant_management/features/confirm_email/presentation/cubit/email_confirmation_state.dart';

class OtpVerificationCodeScreen extends StatefulWidget {
  final String userId;
  const OtpVerificationCodeScreen({super.key, required this.userId});

  @override
  State<OtpVerificationCodeScreen> createState() =>
      _OtpVerificationCodeScreenState();
}

class _OtpVerificationCodeScreenState extends State<OtpVerificationCodeScreen> {
  OtpFieldController otpController = OtpFieldController();
  String otpCode = "";
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpController.setFocus(0);
      if (!_codeSent) {
        context.read<EmailConfirmationCubit>().sendCode(widget.userId);
        _codeSent = true;
        print("📨 sendCode CALLED ✅");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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

        return BlocConsumer<EmailConfirmationCubit, EmailConfirmationState>(
          // داخل listener
          listener: (context, state) {
            if (state is EmailConfirmationVerified) {
              showAppSnackBar(
                context,
                message: "Email confirmed successfully",
                type: SnackBarType.success,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.mainRoute,
                (r) => false,
              );
            } else if (state is EmailConfirmationError) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
              otpController.clear();
              otpController.setFocus(0);
              setState(() {
                otpCode = "";
              });
            }
          },
          builder: (context, state) {
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "The account has been created!",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Enter the confirmation code sent to your email",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30.h),

                            OTPTextField(
                              keyboardType: TextInputType.number,
                              controller: otpController,
                              length: 6,
                              width: MediaQuery.of(context).size.width * 0.9,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 45,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 15,
                              style: const TextStyle(fontSize: 17),
                              onChanged: (pin) => otpCode = pin,
                              onCompleted: (pin) => otpCode = pin,
                            ),
                            SizedBox(height: 30.h),

                            state is EmailConfirmationLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : AppButton(
                                  text: "Confirm",
                                  onPressed: () {
                                    if (otpCode.isNotEmpty) {
                                      context
                                          .read<EmailConfirmationCubit>()
                                          .verifyCode(widget.userId, otpCode);
                                    } else {
                                      showAppSnackBar(
                                        context,
                                        message: "Please enter the code",
                                      );
                                    }
                                  },
                                ),
                            SizedBox(height: 17.h),
                            const Text(
                              "You did not receive the confirmation code?",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Re-send",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
      },
    );
  }
}
