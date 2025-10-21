import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';

class HomeAddressSection extends StatelessWidget {
  const HomeAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: BlocBuilder<AddressCubit, AddressState>(
          builder: (context, state) {
            final addressCubit = context.read<AddressCubit>();
            Widget addressSection;

            if (state is AddressLoading) {
              addressSection = const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AddressLoaded &&
                state.addresses.isNotEmpty) {
              final addresses = state.addresses;
              final selectedId =
                  addressCubit.selectedAddress?.id ?? addresses.first.id;

              addressSection = Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE5B4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedId,
                          isExpanded: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                          items: addresses.map((address) {
                            final label = address.addressLabel ?? "No label";
                            final full = address.fullAddress ?? "No address";
                            return DropdownMenuItem<String>(
                              value: address.id,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    full,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newId) {
                            final selected = addresses.firstWhere(
                                  (a) => a.id == newId,
                            );
                            addressCubit.selectAddress(selected);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AddressError) {
              addressSection = Text(
                "Error loading address: ${state.message}",
                style: const TextStyle(color: Colors.red),
              );
            } else {
              addressSection = Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "No address found",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return addressSection;
          },
        ),
      ),
    );
  }
}
