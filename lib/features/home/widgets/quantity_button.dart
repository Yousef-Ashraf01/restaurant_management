import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';

class QuantityButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QuantityButton({required this.icon, required this.onTap});

  @override
  State<QuantityButton> createState() => QuantityButtonState();
}

class QuantityButtonState extends State<QuantityButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
          color: isPressed ? AppColors.accent : Colors.white,
        ),
        child: Icon(
          widget.icon,
          size: 20.sp,
          color: isPressed ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
