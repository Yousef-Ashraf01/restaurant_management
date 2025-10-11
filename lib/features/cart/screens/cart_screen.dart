import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/data/models/cart_item_model.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<CartCubit>().getCart(showLoading: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.asset(
                      'assets/animations/noInternetConnection.json',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.noInternetConnection,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartInitial || state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded || state is CartUpdatingItem) {
              final cart =
              (state is CartLoaded)
                  ? state.cart
                  : (state as CartUpdatingItem).previousCart;
              final updatingItemId =
              (state is CartUpdatingItem) ? state.itemId : null;

              if (cart.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cartRemovebgPreview.png',
                        width: 200.w,
                        height: 200.h,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        AppLocalizations.of(context)!.cartEmpty,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        AppLocalizations.of(context)!.readyToOrder,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.mainRoute);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: AppColors.accent),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.addItems,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return AppUnfocusWrapper(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          final isUpdating = item.id == updatingItemId;
                          return _buildCartItem(context, item, isUpdating);
                        },
                      ),
                    ),
                    _buildCartFooter(cart),
                  ],
                ),
              );
            } else if (state is CartError || state is CartFailure) {
              final message =
              (state is CartError)
                  ? state.message
                  : (state as CartFailure).message;
              return Center(
                child: Text(
                  "Error: $message",
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildCartItem(
      BuildContext context,
      CartItemModel item,
      bool isUpdating,
      ) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      margin: EdgeInsets.only(right: 20.w, left: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                        item.dish.image.isNotEmpty &&
                            item.dish.image != "null"
                            ? Image.memory(
                          convertBase64ToImage(item.dish.image),
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          "assets/images/logo1.jpg",
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    BlocBuilder<LocaleCubit, Locale>(
                      builder: (context, locale) {
                        return Text(
                          locale.languageCode == 'en'
                              ? item.dish.engName
                              : item.dish.arbName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _buildDeleteButton(context, item),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuantityControls(context, item, isUpdating),
                Text(
                  "${AppLocalizations.of(context)!.price}: ${item.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18.sp, color: Colors.black45),
                ),
              ],
            ),
            if (item.selectedOptions.isNotEmpty)
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                      item.selectedOptions.map((option) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.orange.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                locale.languageCode == 'en'
                                    ? option.dishOption.engName
                                    : option.dishOption.arbName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                option.dishOption.price.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, CartItemModel item) {
    return IconButton(
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteItem),
            content: Text(AppLocalizations.of(context)!.confirmDeleteItem),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  final cartCubit = context.read<CartCubit>();
                  Navigator.pop(context);
                  cartCubit.deleteItem(
                    cartId: item.cartId,
                    cartItemId: item.id,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityControls(
      BuildContext context,
      CartItemModel item,
      bool isUpdating,
      ) {
    if (isUpdating) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.redAccent,
          ),
          onPressed: () {
            context.read<CartCubit>().updateQuantity(
              cartId: item.cartId,
              cartItemId: item.id,
              newQuantity: item.quantity - 1,
            );
          },
        ),
        Text(
          "${item.quantity}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.green),
          onPressed: () {
            context.read<CartCubit>().updateQuantity(
              cartId: item.cartId,
              cartItemId: item.id,
              newQuantity: item.quantity + 1,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCartFooter(cart) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 15.w, right: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${AppLocalizations.of(context)!.total}: ${cart.totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              // 🧠 خزن نسخة آمنة من الـ localizations
              final loc = AppLocalizations.of(context)!;

              final orderCubit = context.read<OrderCubit>();
              final cartCubit = context.read<CartCubit>();
              final tokenStorage = RepositoryProvider.of<TokenStorage>(context);
              final userId = tokenStorage.getUserId();

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ ${loc.noInternetConnection}")),
                );
                return;
              }

              context.read<AddressCubit>().getUserAddresses(userId);

              final apartmentController = TextEditingController();
              final buildingController = TextEditingController();
              final cityController = TextEditingController();
              final floorController = TextEditingController();
              final streetController = TextEditingController();
              final addressController = TextEditingController();
              final additionalController = TextEditingController();
              final formKey = GlobalKey<FormState>();

              await showDialog(
                context: context,
                builder: (dialogContext) {
                  final dLoc =
                  AppLocalizations.of(
                    dialogContext,
                  )!; // 🔹 استخدم ده جوه الديالوج
                  String? selectedAddressId;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text(dLoc.enterDeliveryDetails),
                        content: SingleChildScrollView(
                          child: BlocBuilder<AddressCubit, AddressState>(
                            builder: (context, state) {
                              if (state is AddressLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final addresses =
                              state is AddressLoaded ? state.addresses : [];

                              return Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (addresses.isNotEmpty)
                                      DropdownButtonFormField<String>(
                                        value: selectedAddressId,
                                        decoration: InputDecoration(
                                          labelText: dLoc.selectSavedAddress,
                                          labelStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14.w,
                                            vertical: 14.h,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color:
                                              Theme.of(
                                                context,
                                              ).primaryColor,
                                              width: 1.6,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        dropdownColor: Colors.white,
                                        items:
                                        addresses
                                            .map(
                                              (a) =>
                                              DropdownMenuItem<String>(
                                                value: a.id ?? "",
                                                child: Text(
                                                  a.addressLabel ?? "",
                                                  style:
                                                  const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                        )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(
                                                () => selectedAddressId = value,
                                          );

                                          final selected = addresses.firstWhere(
                                                (a) => a.id == value,
                                          );

                                          apartmentController.text =
                                              selected.apartmentNo
                                                  ?.toString() ??
                                                  "";
                                          floorController.text =
                                              selected.floor?.toString() ?? "";
                                          buildingController.text =
                                              selected.buildingName ?? "";
                                          streetController.text =
                                              selected.street ?? "";
                                          cityController.text =
                                              selected.city ?? "";
                                          addressController.text =
                                              selected.fullAddress ?? "";
                                          additionalController.text =
                                              selected.additionalDirections ??
                                                  "";
                                        },
                                      ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField(
                                            context,
                                            dLoc.apartment_no,
                                            apartmentController,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: _buildTextField(
                                            context,
                                            dLoc.floor,
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
                                            dLoc.building_name,
                                            buildingController,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: _buildTextField(
                                            context,
                                            dLoc.street,
                                            streetController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField(
                                            context,
                                            dLoc.city,
                                            cityController,
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: _buildTextField(
                                            context,
                                            dLoc.fullAddress,
                                            addressController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _buildTextField(
                                      context,
                                      dLoc.additionalDirections,
                                      additionalController,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text(
                              dLoc.cancel,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;
                              Navigator.pop(dialogContext);

                              final navigator = Navigator.of(
                                context,
                                rootNavigator: true,
                              );

                              showDialog(
                                context: navigator.context,
                                barrierDismissible: false,
                                builder:
                                    (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              await orderCubit.createOrder(
                                apartmentNo:
                                int.tryParse(apartmentController.text) ?? 0,
                                buildingName: buildingController.text,
                                city: cityController.text,
                                floor: int.tryParse(floorController.text) ?? 0,
                                fullAddress: addressController.text,
                                street: streetController.text,
                                userId: userId,
                                additionalDirections: additionalController.text,
                              );

                              await cartCubit.getCart(showLoading: false);

                              if (!mounted) return;

                              if (navigator.canPop()) navigator.pop();

                              if (!mounted) return;

                              await showDialog(
                                context: navigator.context,
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
                                  actionsAlignment:
                                  MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                      onPressed: () => navigator.pop(),
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
                            child: Text(dLoc.confirmOrder),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              backgroundColor: AppColors.accent,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },

            child: Text(
              AppLocalizations.of(context)!.order,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black87),
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
          border: const OutlineInputBorder(),
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
