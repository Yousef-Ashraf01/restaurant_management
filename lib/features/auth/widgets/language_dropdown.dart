import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final langCode = locale.languageCode.startsWith('ar') ? 'ar' : 'en';
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: langCode,
            dropdownColor: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            icon: Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(Icons.language, color: Colors.grey[700]),
            ),
            items: [
              DropdownMenuItem(
                value: 'ar',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/flagSaudiArabia.svg',
                      width: 24.w,
                      height: 16.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'العربية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/flagUsSvgRepo.svg',
                      width: 24.w,
                      height: 16.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'English',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<LocaleCubit>().changeLocale(value);
              }
            },
            selectedItemBuilder: (ctx) {
              return ['ar', 'en'].map((code) {
                if (code == 'ar') {
                  return Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/flagSaudiArabia.svg',
                        width: 24.w,
                        height: 16.h,
                      ),
                      SizedBox(width: 8.w),
                      Text(' العربية', style: TextStyle(fontSize: 14.sp)),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/flagUsSvgRepo.svg',
                        width: 24.w,
                        height: 16.h,
                      ),
                      SizedBox(width: 8.w),
                      Text('English', style: TextStyle(fontSize: 14.sp)),
                    ],
                  );
                }
              }).toList();
            },
          ),
        );
      },
    );
  }
}
