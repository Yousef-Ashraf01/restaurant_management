import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/features/profile/data/models/address_model.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_cubit.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_state.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/text_field_bottom.dart';

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

    final labelFocus = FocusNode();
    final streetFocus = FocusNode();
    final cityFocus = FocusNode();
    final buildingFocus = FocusNode();
    final floorFocus = FocusNode();
    final aptFocus = FocusNode();
    final additionalFocus = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
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
            labelFocus: labelFocus,
            streetFocus: streetFocus,
            cityFocus: cityFocus,
            buildingFocus: buildingFocus,
            floorFocus: floorFocus,
            aptFocus: aptFocus,
            additionalFocus: additionalFocus,
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

  final FocusNode labelFocus;
  final FocusNode streetFocus;
  final FocusNode cityFocus;
  final FocusNode buildingFocus;
  final FocusNode floorFocus;
  final FocusNode aptFocus;
  final FocusNode additionalFocus;

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
    required this.labelFocus,
    required this.streetFocus,
    required this.cityFocus,
    required this.buildingFocus,
    required this.floorFocus,
    required this.aptFocus,
    required this.additionalFocus,
  });

  @override
  State<_AnimatedBottomSheetContent> createState() =>
      _AnimatedBottomSheetContentState();
}

class _AnimatedBottomSheetContentState
    extends State<_AnimatedBottomSheetContent> {
  void _submit(AddressCubit cubit, BuildContext context, bool isLoading) {
    if (isLoading) return;
    if (widget.formKey.currentState!.validate()) {
      final newAddress = AddressModel(
        id: widget.address?.id,
        addressLabel: widget.labelCtrl.text,
        street: widget.streetCtrl.text,
        city: widget.cityCtrl.text,
        apartmentNo: int.tryParse(widget.aptCtrl.text) ?? 0,
        floor: int.tryParse(widget.floorCtrl.text) ?? 0,
        fullAddress: "${widget.streetCtrl.text}, ${widget.cityCtrl.text}",
        userId: widget.userId,
        isPrimary: true,
        latitude: 30.06263,
        longitude: 31.24967,
        isActive: true,
        buildingName: widget.buildingNameCtrl.text,
        additionalDirections: widget.additionalCtrl.text,
      );

      if (widget.address == null) {
        cubit.addAddress(newAddress);
      } else {
        cubit.updateAddress(newAddress, widget.userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddressCubit>();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
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
                  SizedBox(height: 20.h),

                  TextFieldBottom(
                    controller: widget.labelCtrl,
                    focusNode: widget.labelFocus,
                    nextFocus: widget.streetFocus,
                    label: AppLocalizations.of(context)!.address_label,
                  ),
                  SizedBox(height: 10.h),
                  TextFieldBottom(
                    controller: widget.streetCtrl,
                    focusNode: widget.streetFocus,
                    nextFocus: widget.cityFocus,
                    label: AppLocalizations.of(context)!.street,
                  ),
                  SizedBox(height: 10.h),
                  TextFieldBottom(
                    controller: widget.cityCtrl,
                    focusNode: widget.cityFocus,
                    nextFocus: widget.buildingFocus,
                    label: AppLocalizations.of(context)!.city,
                  ),
                  SizedBox(height: 10.h),
                  TextFieldBottom(
                    controller: widget.buildingNameCtrl,
                    focusNode: widget.buildingFocus,
                    nextFocus: widget.floorFocus,
                    label: AppLocalizations.of(context)!.building_name,
                  ),
                  SizedBox(height: 10.h),
                  TextFieldBottom(
                    controller: widget.floorCtrl,
                    focusNode: widget.floorFocus,
                    nextFocus: widget.aptFocus,
                    label: AppLocalizations.of(context)!.floor,
                    isNumber: true,
                  ),
                  SizedBox(height: 10.h),
                  TextFieldBottom(
                    controller: widget.aptCtrl,
                    focusNode: widget.aptFocus,
                    nextFocus: widget.additionalFocus,
                    label: AppLocalizations.of(context)!.apartment_no,
                    isNumber: true,
                  ),
                  SizedBox(height: 10.h),

                  TextFieldBottom(
                    controller: widget.additionalCtrl,
                    focusNode: widget.additionalFocus,
                    label: AppLocalizations.of(context)!.additionalDirections,
                    requiredField: false,
                    textInputAction: TextInputAction.done,
                    onDone: () => _submit(cubit, context, isLoading),
                  ),

                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () => _submit(cubit, context, isLoading),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isLoading
                              ? Colors.grey[400]
                              : Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child:
                        isLoading
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18.w,
                                  height: 18.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  AppLocalizations.of(context)!.loading,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              widget.address == null
                                  ? AppLocalizations.of(context)!.add_address
                                  : AppLocalizations.of(
                                    context,
                                  )!.update_address,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
