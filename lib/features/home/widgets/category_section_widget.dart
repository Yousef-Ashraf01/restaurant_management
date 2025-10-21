import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:restaurant_management/features/auth/state/dish_cubit.dart';
import 'package:restaurant_management/features/home/widgets/catgeory_section.dart';


class CategorySectionWidget extends StatelessWidget {
  final ValueNotifier<int> selectedCategoryNotifier;

  const CategorySectionWidget({
    super.key,
    required this.selectedCategoryNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          top: 10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.categories,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 120.h,
              child: ValueListenableBuilder<int>(
                valueListenable: selectedCategoryNotifier,
                builder: (context, selectedIndex, _) {
                  return CategorySection(
                    selectedCategoryIndex: selectedIndex,
                    onCategorySelected: (index, categoryId) {
                      selectedCategoryNotifier.value = index;

                      if (categoryId == 0) {
                        context.read<DishCubit>().getDishes();
                      } else {
                        context
                            .read<DishCubit>()
                            .getDishesByCategory(categoryId.toString());
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
