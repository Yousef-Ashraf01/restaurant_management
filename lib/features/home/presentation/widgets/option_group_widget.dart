import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/language/presentation/cubit/local_cubit.dart';

class OptionGroupWidget extends StatelessWidget {
  final dynamic group;
  final bool Function(dynamic) isSelected;
  final Function(dynamic) onOptionSelected;

  const OptionGroupWidget({
    required this.group,
    required this.isSelected,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    locale.languageCode == 'en' ? group.engName : group.arbName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (group.isRequired ?? false)
                    const Text(
                      " *",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                ],
              ),
              SizedBox(height: 5.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      group.options.map<Widget>((option) {
                        final selected = isSelected(option);
                        return GestureDetector(
                          onTap: () => onOptionSelected(option),
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Card(
                              color:
                                  selected ? AppColors.primary : Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color:
                                      selected
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 10.h,
                                ),
                                child: Text(
                                  "${locale.languageCode == 'en' ? option.engName : option.arbName} (${option.price.toStringAsFixed(2)})",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        selected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
