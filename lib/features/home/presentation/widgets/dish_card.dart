import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';
import 'package:restaurant_management/features/home/presentation/widgets/dish_image.dart';

class DishCard extends StatelessWidget {
  final DishModel dish;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const DishCard({
    super.key,
    required this.dish,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // مهم جداً عشان الصورة تبقى داخل البوردر
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 الصورة بدون Padding
            AspectRatio(
              key: ValueKey(dish.id),
              aspectRatio: 4 / 3, // تحافظ على شكل متناسق
              child: DishImage(
                image: dish.image,
                dishId: dish.id,
                key: ValueKey(dish.id),
              ),
            ),

            // 🧾 النصوص والمعلومات
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Localizations.localeOf(context).languageCode == 'en'
                        ? dish.engName
                        : dish.arbName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${dish.basePrice.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      InkWell(
                        onTap: onAdd,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
