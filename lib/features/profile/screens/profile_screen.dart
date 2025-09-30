import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/data/models/address_model.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';
import 'package:restaurant_management/features/auth/state/profile_cubit.dart';
import 'package:restaurant_management/features/auth/state/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final String token;

  const ProfileScreen({required this.userId, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => ProfileCubit(context.read())..fetchProfile(userId, token),
        ),
        BlocProvider(
          create: (_) => AddressCubit(context.read())..getUserAddresses(userId),
        ),
      ],
      child: AppUnfocusWrapper(
        child: Scaffold(
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else if (state is ProfileSuccess) {
                final profile = state.profile.data!;
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15.h),
                        _buildHeader(),
                        SizedBox(height: 25.h),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 50.r,
                          child: const Icon(Icons.person, size: 50),
                        ),
                        SizedBox(height: 20.h),
                        _buildLabel("Name"),
                        _buildReadOnlyField(
                          "${profile.firstName} ${profile.lastName}",
                        ),
                        SizedBox(height: 20.h),
                        _buildLabel("Email"),
                        _buildReadOnlyField(profile.email),
                        SizedBox(height: 30.h),
                        _buildAddressesHeader(context, userId),
                        SizedBox(height: 10.h),
                        _buildAddressesList(userId),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50.h,
      color: Colors.white,
      child: Text("Profile", style: TextStyle(fontSize: 22.sp)),
    );
  }

  Widget _buildAddressesHeader(BuildContext context, String userId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Addresses",
            style: TextStyle(fontSize: 22.sp, color: Colors.blue),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () => _showAddAddressBottomSheet(context, userId),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 22.sp, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildAddressesList(String userId) {
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
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showAddAddressBottomSheet(
                                context,
                                userId,
                                address: address,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Delete"),
                                    content: const Text(
                                      "Are you sure you want to delete this address?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldDelete == true) {
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

  Widget _buildReadOnlyField(String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          SizedBox(height: 5.h),
          TextFormField(
            readOnly: true,
            initialValue: value,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? label}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
    );
  }

  void _showAddAddressBottomSheet(
    BuildContext context,
    String userId, {
    AddressModel? address,
  }) {
    final addressCubit = context.read<AddressCubit>();

    final _formKey = GlobalKey<FormState>();
    final _addressLabelController = TextEditingController(
      text: address?.addressLabel ?? "",
    );
    final _streetController = TextEditingController(
      text: address?.street ?? "",
    );
    final _cityController = TextEditingController(text: address?.city ?? "");
    final _apartmentController = TextEditingController(
      text: address?.apartmentNo?.toString() ?? "",
    );
    final _floorController = TextEditingController(
      text: address?.floor?.toString() ?? "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: addressCubit,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20.h,
              top: 20.h,
              left: 25.w,
              right: 25.w,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: BlocConsumer<AddressCubit, AddressState>(
                  listener: (context, state) async {
                    if (state is AddressError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AddressLoaded) {
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (Navigator.of(context).canPop()) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AddressLoading;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          address == null ? "Add New Address" : "Edit Address",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        _buildBottomSheetTextField(
                          _addressLabelController,
                          "Address Label",
                        ),
                        SizedBox(height: 10.h),
                        _buildBottomSheetTextField(_streetController, "Street"),
                        SizedBox(height: 10.h),
                        _buildBottomSheetTextField(_cityController, "City"),
                        SizedBox(height: 10.h),
                        _buildBottomSheetTextField(
                          _apartmentController,
                          "Apartment No",
                          isNumber: true,
                        ),
                        SizedBox(height: 10.h),
                        _buildBottomSheetTextField(
                          _floorController,
                          "Floor",
                          isNumber: true,
                        ),
                        SizedBox(height: 20.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        final newAddress = AddressModel(
                                          id: address?.id,
                                          addressLabel:
                                              _addressLabelController.text,
                                          street: _streetController.text,
                                          city: _cityController.text,
                                          apartmentNo:
                                              int.tryParse(
                                                _apartmentController.text,
                                              ) ??
                                              0,
                                          floor:
                                              int.tryParse(
                                                _floorController.text,
                                              ) ??
                                              0,
                                          fullAddress:
                                              "${_streetController.text}, ${_cityController.text}",
                                          userId: userId,
                                          isPrimary: true,
                                          latitude: 30.06263,
                                          longitude: 31.24967,
                                          isActive: true,
                                          additionalDirections: "test",
                                          buildingName: "test",
                                        );

                                        if (address == null) {
                                          context
                                              .read<AddressCubit>()
                                              .addAddress(newAddress);
                                        } else {
                                          context
                                              .read<AddressCubit>()
                                              .updateAddress(
                                                newAddress,
                                                userId,
                                              );
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

  Widget _buildBottomSheetTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      ),
    );
  }
}
