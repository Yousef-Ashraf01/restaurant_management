import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${AppLocalizations.of(context)!.noOrdersYet} 🍔",
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
