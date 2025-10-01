import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/features/auth/data/models/address_model.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';
import 'package:restaurant_management/features/profile/widgets/text_field_bottom.dart';

class AddAddressBottomSheet {
  static void show(
    BuildContext context,
    String userId, {
    AddressModel? address,
  }) {
    final cubit = context.read<AddressCubit>();
    final formKey = GlobalKey<FormState>();

    final labelCtrl = TextEditingController(text: address?.addressLabel ?? "");
    final streetCtrl = TextEditingController(text: address?.street ?? "");
    final cityCtrl = TextEditingController(text: address?.city ?? "");
    final aptCtrl = TextEditingController(
      text: address?.apartmentNo?.toString() ?? "",
    );
    final floorCtrl = TextEditingController(
      text: address?.floor?.toString() ?? "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              top: 20.h,
              left: 25.w,
              right: 25.w,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: BlocConsumer<AddressCubit, AddressState>(
                  listener: (context, state) {
                    if (state is AddressError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AddressLoaded) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AddressLoading;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          address == null ? "Add New Address" : "Edit Address",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.h),
                        TextFieldBottom(
                          controller: labelCtrl,
                          label: "Address Label",
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: streetCtrl,
                          label: "Street",
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(controller: cityCtrl, label: "City"),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: aptCtrl,
                          label: "Apartment No",
                          isNumber: true,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: floorCtrl,
                          label: "Floor",
                          isNumber: true,
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    if (formKey.currentState!.validate()) {
                                      final newAddress = AddressModel(
                                        id: address?.id,
                                        addressLabel: labelCtrl.text,
                                        street: streetCtrl.text,
                                        city: cityCtrl.text,
                                        apartmentNo:
                                            int.tryParse(aptCtrl.text) ?? 0,
                                        floor:
                                            int.tryParse(floorCtrl.text) ?? 0,
                                        fullAddress:
                                            "${streetCtrl.text}, ${cityCtrl.text}",
                                        userId: userId,
                                        isPrimary: true,
                                        latitude: 30.06263,
                                        longitude: 31.24967,
                                        isActive: true,
                                        additionalDirections: "test",
                                        buildingName: "test",
                                      );
                                      if (address == null) {
                                        context.read<AddressCubit>().addAddress(
                                          newAddress,
                                        );
                                      } else {
                                        context
                                            .read<AddressCubit>()
                                            .updateAddress(newAddress, userId);
                                      }
                                    }
                                  },
                          child: Text(
                            isLoading
                                ? "Loading..."
                                : (address == null
                                    ? "Add Address"
                                    : "Update Address"),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
