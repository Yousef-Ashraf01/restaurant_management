import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantInfoShimmer extends StatelessWidget {
  const RestaurantInfoShimmer({super.key});

  Widget _shimmerBox({
    double height = 20,
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card for restaurant basic info
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo shimmer
                  _shimmerBox(height: 100, width: 100, radius: 12),
                  SizedBox(height: 16.h),

                  // Restaurant name shimmer
                  _shimmerBox(height: 22, width: 180),
                  SizedBox(height: 12.h),

                  // Phone shimmer
                  _shimmerBox(height: 18, width: 140),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Branches title shimmer
          _shimmerBox(height: 20, width: 120),
          SizedBox(height: 12.h),

          // Branches list shimmer
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(height: 18, width: 160),
                      SizedBox(height: 8.h),
                      _shimmerBox(height: 16, width: 220),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
