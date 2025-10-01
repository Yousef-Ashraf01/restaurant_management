import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            return Text(
              "No addresses found",
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            );
          }
          return Column(
            children:
                state.addresses.map((address) {
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 25.w,
                    ),
                    child: ListTile(
                      title: Text("${address.street}, ${address.city}"),
                      subtitle: Text(
                        "Label: ${address.addressLabel} - Floor: ${address.floor}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue[800]),
                            onPressed:
                                () => AddAddressBottomSheet.show(
                                  context,
                                  userId,
                                  address: address,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                        "Are you sure you want to delete this address?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: Text(
                                            "Yes",
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
