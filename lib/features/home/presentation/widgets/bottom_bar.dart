import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';

class BottomBar extends StatelessWidget {
  final double total;
  final bool isEnabled;
  final VoidCallback onAddToCart;

  const BottomBar({
    required this.total,
    required this.isEnabled,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${AppLocalizations.of(context)!.total}: ${total.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: isEnabled ? onAddToCart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
            ),
            child: Text(
              AppLocalizations.of(context)!.addToCart,
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
