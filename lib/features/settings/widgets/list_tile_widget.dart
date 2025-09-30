import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.icon,
    required this.title,
    this.backgroundAvatar,
    this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color? backgroundAvatar;
  final Color? iconColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: backgroundAvatar ?? Colors.blue[50],
          child: Icon(icon, color: iconColor ?? Colors.blue[600]),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
        title: Text(
          title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
