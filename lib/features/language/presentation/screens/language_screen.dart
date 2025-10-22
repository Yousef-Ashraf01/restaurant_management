import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/features/language/presentation/cubit/local_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleCubit>().state.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chooseLanguage),
        centerTitle: true,
      ),
      body: BlocBuilder<ConnectivityCubit, bool>(
        builder: (context, isConnected) {
          if (!isConnected) {
            return Center(
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
            );
          }

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLanguageOption(
                  context,
                  title: "العربية",
                  langCode: "ar",
                  isSelected: currentLocale == "ar",
                  flagAsset: 'assets/svg/flagSaudiArabia.svg',
                ),
                SizedBox(height: 20.h),
                _buildLanguageOption(
                  context,
                  title: "English",
                  langCode: "en",
                  isSelected: currentLocale == "en",
                  flagAsset: 'assets/svg/flagUsSvgRepo.svg',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String langCode,
    required bool isSelected,
    required String flagAsset,
  }) {
    return InkWell(
      onTap: () async {
        final isConnected = context.read<ConnectivityCubit>().state;
        if (isConnected) {
          await context.read<LocaleCubit>().changeLocale(langCode);

          showAppSnackBar(
            context,
            message: AppLocalizations.of(context)!.languageChangedSuccessfully,
            type: SnackBarType.success,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.noInternetConnection),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: SvgPicture.asset(
                flagAsset,
                width: 50.w,
                height: 50.h,
                fit: BoxFit.cover,
                semanticsLabel: title,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
