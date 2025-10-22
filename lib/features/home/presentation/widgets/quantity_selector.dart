import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final isDecrementEnabled = quantity > 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: isDecrementEnabled ? onDecrement : null,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Icon(
                Icons.remove,
                size: 20.sp,
                color:
                    isDecrementEnabled
                        ? AppColors.accent
                        : Colors.grey.shade400,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              '$quantity',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),

          InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Icon(Icons.add, size: 20.sp, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
