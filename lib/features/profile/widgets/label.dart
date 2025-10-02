import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Label extends StatelessWidget {
  final String text;
  const Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Text(text, style: TextStyle(fontSize: 20.sp, color: Colors.blue)),
    );
  }
}
