import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';

class UpdateButton extends StatelessWidget {
  final bool isUpdating;
  final VoidCallback onPressed;

  const UpdateButton({
    super.key,
    required this.isUpdating,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isUpdating ? null : onPressed,
        child:
            isUpdating
                ? SizedBox(
                  height: 22.h,
                  width: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                )
                : Text(AppLocalizations.of(context)!.updateProfile),
      ),
    );
  }
}
