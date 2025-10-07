import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
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
    final buildingNameCtrl = TextEditingController(
      text: address?.buildingName ?? "",
    );
    final additionalCtrl = TextEditingController(
      text: address?.additionalDirections ?? "",
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
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 20.h,
                left: 25.w,
                right: 25.w,
                bottom: 25.h,
              ),
              child: Form(
                key: formKey,
                child: BlocConsumer<AddressCubit, AddressState>(
                  listener: (context, state) {
                    if (state is AddressError) {
                      showAppSnackBar(
                        context,
                        message: state.message,
                        type: SnackBarType.error,
                      );
                    } else if (state is AddressLoaded) {
                      Navigator.pop(context);
                      showAppSnackBar(
                        context,
                        message:
                            address == null
                                ? AppLocalizations.of(
                                  context,
                                )!.addressAddedSuccessfully
                                : AppLocalizations.of(
                                  context,
                                )!.addressUpdatedSuccessfully,
                        type: SnackBarType.success,
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AddressLoading;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          address == null
                              ? AppLocalizations.of(context)!.add_address
                              : AppLocalizations.of(context)!.update_address,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15.h),
                        TextFieldBottom(
                          controller: labelCtrl,
                          label: AppLocalizations.of(context)!.address_label,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: streetCtrl,
                          label: AppLocalizations.of(context)!.street,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: cityCtrl,
                          label: AppLocalizations.of(context)!.city,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: buildingNameCtrl,
                          label: AppLocalizations.of(context)!.building_name,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: floorCtrl,
                          label: AppLocalizations.of(context)!.floor,
                          isNumber: true,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: aptCtrl,
                          label: AppLocalizations.of(context)!.apartment_no,
                          isNumber: true,
                        ),
                        SizedBox(height: 10.h),
                        TextFieldBottom(
                          controller: additionalCtrl,
                          label:
                              AppLocalizations.of(
                                context,
                              )!.additionalDirections,
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
                                        buildingName: buildingNameCtrl.text,
                                        additionalDirections:
                                            additionalCtrl.text,
                                      );

                                      if (address == null) {
                                        cubit.addAddress(newAddress);
                                      } else {
                                        cubit.updateAddress(newAddress, userId);
                                      }
                                    }
                                  },
                          child: Text(
                            isLoading
                                ? AppLocalizations.of(context)!.loading
                                : (address == null
                                    ? AppLocalizations.of(context)!.add_address
                                    : AppLocalizations.of(
                                      context,
                                    )!.update_address),
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
