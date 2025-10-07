import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackBarType { success, error, info }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.info,
  Duration duration = const Duration(seconds: 2),
}) {
  Color backgroundColor;
  Icon? icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green.shade600;
      icon = Icon(Icons.check_circle, color: Colors.white, size: 20.sp);
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red.shade600;
      icon = Icon(Icons.error, color: Colors.white, size: 20.sp);
      break;
    case SnackBarType.info:
    default:
      backgroundColor = Colors.black87;
      icon = Icon(Icons.info, color: Colors.white, size: 20.sp);
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) icon,
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    ),
  );
}
