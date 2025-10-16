import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/config/routes/app_routes.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/data/models/cart_item_model.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/state/cart_state.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/local_cubit.dart';
import 'package:restaurant_management/features/auth/state/order_cubit.dart';
import 'package:restaurant_management/features/cart/screens/delivery_details_screen.dart';

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
                          return BlocBuilder<CartCubit, CartState>(
                            buildWhen: (previous, current) {
                              // بس يعيد بناء العنصر اللي بيتحدث
                              if (current is CartUpdatingItem) {
                                return current.itemId == item.id;
                              }
                              if (current is CartLoaded) return true;
                              return false;
                            },
                            builder: (context, state) {
                              final isUpdating =
                                  state is CartUpdatingItem &&
                                  state.itemId == item.id;
                              return _buildCartItem(
                                context,
                                item,
                                isUpdating,
                                key: ValueKey(item.id),
                              );
                            },
                          );
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
    bool isUpdating, {
    Key? key,
  }) {
    return Card(
      key: key,
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 الصف العلوي (الصورة + الاسم)
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      margin:
                          Localizations.localeOf(context).languageCode == 'en'
                              ? EdgeInsets.only(right: 20.w)
                              : EdgeInsets.only(left: 20.w),
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
                                  key: ValueKey(item.dish.image),
                                  convertBase64ToImage(item.dish.image),
                                  width: 60.w,
                                  height: 60.h,
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                )
                                : Image.asset(
                                  "assets/images/logo1.jpg",
                                  width: 60.w,
                                  height: 60.h,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<LocaleCubit, Locale>(
                        builder: (context, locale) {
                          return Text(
                            locale.languageCode == 'en'
                                ? item.dish.engName
                                : item.dish.arbName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // 🔹 الكمية + السعر
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

                // 🔹 الخيارات
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
                                        option.dishOption.price.toStringAsFixed(
                                          2,
                                        ),
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

          // 🔹 زرار الـ Delete في الركن اليمين فوق
          Positioned(
            top: 4,
            right:
                Localizations.localeOf(context).languageCode == 'ar' ? null : 4,
            left:
                Localizations.localeOf(context).languageCode == 'ar' ? 4 : null,
            child: IconButton(
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!.deleteItem),
                        content: Text(
                          AppLocalizations.of(context)!.confirmDeleteItem,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: const TextStyle(color: Colors.grey),
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
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDeleteButton(BuildContext context, CartItemModel item) {
  //   return IconButton(
  //     icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
  //     onPressed: () {
  //       showDialog(
  //         context: context,
  //         builder:
  //             (context) => AlertDialog(
  //               title: Text(AppLocalizations.of(context)!.deleteItem),
  //               content: Text(AppLocalizations.of(context)!.confirmDeleteItem),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: Text(
  //                     AppLocalizations.of(context)!.cancel,
  //                     style: TextStyle(color: Colors.grey),
  //                   ),
  //                 ),
  //                 TextButton(
  //                   onPressed: () {
  //                     final cartCubit = context.read<CartCubit>();
  //                     Navigator.pop(context);
  //                     cartCubit.deleteItem(
  //                       cartId: item.cartId,
  //                       cartItemId: item.id,
  //                     );
  //                   },
  //                   child: Text(
  //                     AppLocalizations.of(context)!.delete,
  //                     style: TextStyle(color: Colors.redAccent),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //       );
  //     },
  //   );
  // }

  Widget _buildQuantityControls(
    BuildContext context,
    CartItemModel item,
    bool isUpdating,
  ) {
    if (isUpdating) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.accent,
        ),
      );
    }

    final isRemoveMode = item.quantity == 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (isRemoveMode) {
                context.read<CartCubit>().deleteItem(
                  cartId: item.cartId,
                  cartItemId: item.id,
                );
              } else {
                context.read<CartCubit>().updateQuantity(
                  cartId: item.cartId,
                  cartItemId: item.id,
                  newQuantity: item.quantity - 1,
                );
              }
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Icon(
                isRemoveMode ? Icons.delete_forever : Icons.remove,
                size: 20.sp,
                color: isRemoveMode ? AppColors.accent : AppColors.accent,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              '${item.quantity}',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<CartCubit>().updateQuantity(
                cartId: item.cartId,
                cartItemId: item.id,
                newQuantity: item.quantity + 1,
              );
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Icon(Icons.add, size: 20.sp, color: AppColors.accent),
            ),
          ),
        ],
      ),
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
            onPressed: () {
              final cartCubit = context.read<CartCubit>();
              final orderCubit = context.read<OrderCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DeliveryDetailsScreen(
                        cartCubit: cartCubit,
                        orderCubit: orderCubit,
                      ),
                ),
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
