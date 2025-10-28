import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:restaurant_management/features/orders/presentation/cubit/order_cubit.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_cubit.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_state.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final CartCubit cartCubit;
  final OrderCubit orderCubit;

  const DeliveryDetailsScreen({
    super.key,
    required this.cartCubit,
    required this.orderCubit,
  });

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final apartmentController = TextEditingController();
  final buildingController = TextEditingController();
  final cityController = TextEditingController();
  final floorController = TextEditingController();
  final streetController = TextEditingController();
  final addressController = TextEditingController();
  final additionalController = TextEditingController();
  final notesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    final tokenStorage = RepositoryProvider.of<TokenStorage>(context);
    final userId = tokenStorage.getUserId();
    if (userId != null) {
      context.read<AddressCubit>().getUserAddresses(userId);
    }

    final addressCubit = context.read<AddressCubit>();
    if (addressCubit.selectedAddress != null) {
      final selected = addressCubit.selectedAddress!;
      selectedAddressId = selected.id ?? "";
      apartmentController.text = selected.apartmentNo?.toString() ?? "";
      floorController.text = selected.floor?.toString() ?? "";
      buildingController.text = selected.buildingName ?? "";
      streetController.text = selected.street ?? "";
      cityController.text = selected.city ?? "";
      addressController.text = selected.fullAddress ?? "";
      additionalController.text = selected.additionalDirections ?? "";
    }

    cityController.addListener(_updateFullAddress);
    streetController.addListener(_updateFullAddress);
  }

  void _updateFullAddress() {
    final city = cityController.text.trim();
    final street = streetController.text.trim();

    if (city.isNotEmpty && street.isNotEmpty) {
      addressController.text = "$street, $city";
    } else if (city.isNotEmpty) {
      addressController.text = city;
    } else if (street.isNotEmpty) {
      addressController.text = street;
    } else {
      addressController.clear();
    }
  }

  @override
  void dispose() {
    cityController.removeListener(_updateFullAddress);
    streetController.removeListener(_updateFullAddress);

    apartmentController.dispose();
    buildingController.dispose();
    cityController.dispose();
    floorController.dispose();
    streetController.dispose();
    addressController.dispose();
    additionalController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AppUnfocusWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.accent,
          title: Text(
            loc.enterDeliveryDetails,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state is AddressLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final addresses = state is AddressLoaded ? state.addresses : [];

                return Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      if (addresses.isNotEmpty) ...[
                        Text(
                          loc.selectSavedAddress,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          value: selectedAddressId,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 14.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.accent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          dropdownColor: Colors.white,
                          items:
                              addresses
                                  .map(
                                    (a) => DropdownMenuItem<String>(
                                      value: a.id ?? "",
                                      child: Text(a.addressLabel ?? ""),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() => selectedAddressId = value);
                            final selected = addresses.firstWhere(
                              (a) => a.id == value,
                            );
                            context.read<AddressCubit>().selectAddress(
                              selected,
                            );

                            apartmentController.text =
                                selected.apartmentNo?.toString() ?? "";
                            floorController.text =
                                selected.floor?.toString() ?? "";
                            buildingController.text =
                                selected.buildingName ?? "";
                            streetController.text = selected.street ?? "";
                            cityController.text = selected.city ?? "";
                            addressController.text = selected.fullAddress ?? "";
                            additionalController.text =
                                selected.additionalDirections ?? "";
                          },
                        ),
                        SizedBox(height: 18.h),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        SizedBox(height: 18.h),
                      ],
                      Text(
                        loc.newAddress,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              loc.apartment_no,
                              apartmentController,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildTextField(
                              context,
                              loc.floor,
                              floorController,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              loc.building_name,
                              buildingController,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _buildTextField(
                              context,
                              loc.city,
                              cityController,
                            ),
                          ),
                        ],
                      ),

                      _buildTextField(context, loc.street, streetController),
                      _buildTextField(
                        context,
                        loc.fullAddress,
                        addressController,
                      ),
                      _buildTextField(
                        context,
                        loc.additionalDirections,
                        additionalController,
                        required: false,
                      ),

                      SizedBox(height: 16.h),
                      Text(
                        loc.notes,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        cursorColor: AppColors.accent,
                        controller: notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: loc.addedNotesHere,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.accent,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(14.w),
                        ),
                      ),

                      SizedBox(height: 28.h),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final tokenStorage =
                              RepositoryProvider.of<TokenStorage>(context);
                          final userId = tokenStorage.getUserId();

                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${loc.noInternetConnection}"),
                              ),
                            );
                            return;
                          }

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          );

                          final orderResult = await widget.orderCubit
                              .createOrder(
                                apartmentNo:
                                    int.tryParse(apartmentController.text) ?? 0,
                                buildingName: buildingController.text,
                                city: cityController.text,
                                floor: int.tryParse(floorController.text) ?? 0,
                                fullAddress: addressController.text,
                                street: streetController.text,
                                userId: userId,
                                additionalDirections: additionalController.text,
                                notes: notesController.text,
                              );

                          if (orderResult) {
                            await widget.cartCubit.clearCartLocally();
                          }

                          await widget.cartCubit.getCart(showLoading: false);

                          if (mounted) Navigator.pop(context);

                          if (!mounted) return;

                          await showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 60,
                                  ),
                                  content: Text(
                                    "${loc.orderPlacedSuccessfully} 🎉",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        loc.ok,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: AppColors.accent.withOpacity(0.3),
                        ),
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        label: Text(
                          loc.confirmOrder,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool required = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: TextFormField(
        cursorColor: AppColors.accent,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children:
                  required
                      ? const [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ]
                      : [],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.accent, width: 1.6),
          ),
        ),
        validator:
            required
                ? (v) =>
                    v == null || v.isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null
                : null,
      ),
    );
  }
}
