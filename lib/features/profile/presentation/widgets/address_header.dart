import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/add_address_bottom_sheet.dart';

class AddressesHeader extends StatelessWidget {
  final String userId;
  const AddressesHeader({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.addresses,
          style: TextStyle(fontSize: 22.sp, color: Colors.blue),
        ),
        CircleAvatar(
          backgroundColor: AppColors.accent,
          radius: 19.r,
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => AddAddressBottomSheet.show(context, userId),
          ),
        ),
      ],
    );
  }
}
