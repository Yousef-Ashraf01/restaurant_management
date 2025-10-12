import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DishInfo extends StatelessWidget {
  final String name;
  final String description;
  const DishInfo({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            description.isNotEmpty
                ? description
                : AppLocalizations.of(context)!.noDescriptionAvailable,
            style: TextStyle(fontSize: 16.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
