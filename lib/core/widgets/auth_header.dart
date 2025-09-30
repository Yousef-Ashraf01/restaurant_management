import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String imagePath;
  final double imageWidth;

  const AuthHeader({
    super.key,
    required this.title,
    this.imagePath = 'assets/images/logo1_copy.png',
    this.imageWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 45.h),
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Theme.of(context).scaffoldBackgroundColor,
            BlendMode.dstOver,
          ),
          child: Image.asset(imagePath, width: imageWidth.w),
        ),
        SizedBox(height: 25.h),
        Text(
          title,
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
