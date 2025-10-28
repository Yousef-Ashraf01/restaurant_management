import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;

  const ProfileAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.person, size: 50),
        ),
        SizedBox(height: 10.h),
        Text(
          name,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
