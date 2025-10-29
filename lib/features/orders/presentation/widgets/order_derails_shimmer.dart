import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsShimmer extends StatelessWidget {
  const OrderDetailsShimmer({super.key});

  Widget _shimmerBox({double? height, double? width, double radius = 8}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      period: const Duration(milliseconds: 1300),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ الحالة
            _shimmerBox(height: 80.h, width: double.infinity, radius: 16),
            SizedBox(height: 20.h),

            // ✅ العنوان
            _shimmerBox(height: 18.h, width: 120.w),
            SizedBox(height: 10.h),
            _shimmerBox(height: 140.h, width: double.infinity, radius: 16),

            SizedBox(height: 25.h),

            // ✅ العناصر
            _shimmerBox(height: 18.h, width: 100.w),
            SizedBox(height: 10.h),
            Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _shimmerBox(
                    height: 90.h,
                    width: double.infinity,
                    radius: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // ✅ المجموع
            _shimmerBox(height: 18.h, width: 120.w),
            SizedBox(height: 10.h),
            _shimmerBox(height: 100.h, width: double.infinity, radius: 16),
          ],
        ),
      ),
    );
  }
}
