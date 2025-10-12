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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: cubit,
          child: _AnimatedBottomSheetContent(
            formKey: formKey,
            userId: userId,
            address: address,
            labelCtrl: labelCtrl,
            streetCtrl: streetCtrl,
            cityCtrl: cityCtrl,
            aptCtrl: aptCtrl,
            floorCtrl: floorCtrl,
            buildingNameCtrl: buildingNameCtrl,
            additionalCtrl: additionalCtrl,
          ),
        );
      },
    );
  }
}

class _AnimatedBottomSheetContent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String userId;
  final AddressModel? address;
  final TextEditingController labelCtrl;
  final TextEditingController streetCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController aptCtrl;
  final TextEditingController floorCtrl;
  final TextEditingController buildingNameCtrl;
  final TextEditingController additionalCtrl;

  const _AnimatedBottomSheetContent({
    required this.formKey,
    required this.userId,
    required this.address,
    required this.labelCtrl,
    required this.streetCtrl,
    required this.cityCtrl,
    required this.aptCtrl,
    required this.floorCtrl,
    required this.buildingNameCtrl,
    required this.additionalCtrl,
  });

  @override
  State<_AnimatedBottomSheetContent> createState() =>
      _AnimatedBottomSheetContentState();
}

class _AnimatedBottomSheetContentState
    extends State<_AnimatedBottomSheetContent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddressCubit>();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        offset: const Offset(0, 0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 20.h,
              left: 25.w,
              right: 25.w,
              bottom: 25.h,
            ),
            child: Form(
              key: widget.formKey,
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
                          widget.address == null
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
                        widget.address == null
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
                        controller: widget.labelCtrl,
                        label: AppLocalizations.of(context)!.address_label,
                      ),
                      SizedBox(height: 10.h),
                      TextFieldBottom(
                        controller: widget.streetCtrl,
                        label: AppLocalizations.of(context)!.street,
                      ),
                      SizedBox(height: 10.h),
                      TextFieldBottom(
                        controller: widget.cityCtrl,
                        label: AppLocalizations.of(context)!.city,
                      ),
                      SizedBox(height: 10.h),
                      TextFieldBottom(
                        controller: widget.buildingNameCtrl,
                        label: AppLocalizations.of(context)!.building_name,
                      ),
                      SizedBox(height: 10.h),
                      TextFieldBottom(
                        controller: widget.floorCtrl,
                        label: AppLocalizations.of(context)!.floor,
                        isNumber: true,
                      ),
                      SizedBox(height: 10.h),
                      TextFieldBottom(
                        controller: widget.aptCtrl,
                        label: AppLocalizations.of(context)!.apartment_no,
                        isNumber: true,
                      ),
                      SizedBox(height: 10.h),
                      TextFieldBottom(
                        controller: widget.additionalCtrl,
                        label:
                            AppLocalizations.of(context)!.additionalDirections,
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (widget.formKey.currentState!.validate()) {
                                    final newAddress = AddressModel(
                                      id: widget.address?.id,
                                      addressLabel: widget.labelCtrl.text,
                                      street: widget.streetCtrl.text,
                                      city: widget.cityCtrl.text,
                                      apartmentNo:
                                          int.tryParse(widget.aptCtrl.text) ??
                                          0,
                                      floor:
                                          int.tryParse(widget.floorCtrl.text) ??
                                          0,
                                      fullAddress:
                                          "${widget.streetCtrl.text}, ${widget.cityCtrl.text}",
                                      userId: widget.userId,
                                      isPrimary: true,
                                      latitude: 30.06263,
                                      longitude: 31.24967,
                                      isActive: true,
                                      buildingName:
                                          widget.buildingNameCtrl.text,
                                      additionalDirections:
                                          widget.additionalCtrl.text,
                                    );

                                    if (widget.address == null) {
                                      cubit.addAddress(newAddress);
                                    } else {
                                      cubit.updateAddress(
                                        newAddress,
                                        widget.userId,
                                      );
                                    }
                                  }
                                },
                        child: Text(
                          isLoading
                              ? AppLocalizations.of(context)!.loading
                              : (widget.address == null
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
      ),
    );
  }
}
