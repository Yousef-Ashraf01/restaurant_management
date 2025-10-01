import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';
import 'package:restaurant_management/features/profile/widgets/add_address_bottom_sheet.dart';

class AddressList extends StatelessWidget {
  final String userId;

  const AddressList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AddressError) {
          return Text(
            state.message,
            style: TextStyle(color: Colors.red, fontSize: 16.sp),
          );
        } else if (state is AddressLoaded) {
          if (state.addresses.isEmpty) {
            return Center(
              child: Text(
                "No addresses found",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            );
          }
          return Column(
            children:
                state.addresses.map((address) {
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 20.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 👇 الأيقونة على الشمال
                          Icon(
                            Icons.location_on,
                            color: AppColors.accent,
                            size: 28.sp,
                          ),

                          SizedBox(width: 12.w),

                          // 👇 النصوص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Label
                                Text(
                                  address.addressLabel ?? "No Label",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(height: 4.h),

                                // Street + City
                                Text(
                                  "${address.street ?? '-'}, ${address.city ?? '-'}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.h),

                                // Floor + Apartment
                                Text(
                                  "Floor: ${address.floor ?? '-'}, Apartment: ${address.apartmentNo ?? '-'}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 👇 الأزرار
                          // 👇 الأزرار
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue[800],
                                  size: 22.sp,
                                ),
                                onPressed:
                                    () => AddAddressBottomSheet.show(
                                      context,
                                      userId,
                                      address: address,
                                    ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                  size: 22.sp,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.confirm_delete_title,
                                          ),
                                          content: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.confirm_delete_content,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.confirm_no,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.confirm_yes,
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                  if (confirm == true) {
                                    context.read<AddressCubit>().deleteAddress(
                                      address.id!,
                                      userId,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }
}
