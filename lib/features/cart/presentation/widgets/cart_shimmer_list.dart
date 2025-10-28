import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CartShimmerList extends StatelessWidget {
  const CartShimmerList({super.key});

  Widget shimmerBox({
    double height = 16,
    double width = double.infinity,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: 5, // عدد العناصر الوهمية
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صف الصورة واسم الطبق
                  Row(
                    children: [
                      Container(
                        height: 60.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(child: shimmerBox(height: 18, width: 150.w)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  shimmerBox(height: 14, width: 100.w), // السعر
                  SizedBox(height: 10.h),
                  shimmerBox(height: 14, width: double.infinity), // الملاحظات
                  SizedBox(height: 10.h),
                  shimmerBox(height: 14, width: 200.w), // الخيارات
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
