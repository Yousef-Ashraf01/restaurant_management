import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final ButtonStyle? style;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          style ??
          ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight),
      ),
    );
  }
}
