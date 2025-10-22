import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image(
                image:
                    (dish.image.isNotEmpty && dish.image != "null")
                        ? MemoryImage(convertBase64ToImage(dish.image))
                        : const AssetImage("assets/images/logo1.jpg")
                            as ImageProvider,
                height: 130.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                Localizations.localeOf(context).languageCode == 'en'
                    ? dish.engName
                    : dish.arbName,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${dish.basePrice}",
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
                      child: Icon(Icons.add, color: Colors.white, size: 18.sp),
                    ),
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
