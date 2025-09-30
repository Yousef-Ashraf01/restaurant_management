import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleCubit>().state.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.chooseLanguage,), centerTitle: true),
      body: Padding(
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
        await context.read<LocaleCubit>().changeLocale(langCode);
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
