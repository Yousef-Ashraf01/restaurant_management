import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: 50.h,
      child: Text(
        AppLocalizations.of(context)!.profile,
        style: TextStyle(fontSize: 22.sp),
      ),
    );
  }
}
