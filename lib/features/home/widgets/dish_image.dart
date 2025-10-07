import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';

class DishImage extends StatelessWidget {
  final String image;
  const DishImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image(
            width: 200.w,
            height: 150.h,
            fit: BoxFit.cover,
            image:
                (image.isNotEmpty && image != "null")
                    ? MemoryImage(convertBase64ToImage(image))
                    : const AssetImage("assets/images/logo1.jpg")
                        as ImageProvider,
          ),
        ),
      ),
    );
  }
}
