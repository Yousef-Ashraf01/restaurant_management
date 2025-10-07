import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/features/auth/state/cart_cubit.dart';
import 'package:restaurant_management/features/auth/data/models/cart_item_model.dart';

import 'package:restaurant_management/core/utils/image_utils.dart';

class CartWidgets {
  // 🔴 Delete Button
  static Widget deleteButton(BuildContext context, CartItemModel item) {
    return IconButton(
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete Item'),
                content: const Text(
                  'Are you sure you want to remove this item from your cart?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
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
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
        );
      },
    );
  }

  // ➖➕ Quantity Controls
  static Widget quantityControls(
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

  // 🛒 Cart Footer
  static Widget cartFooter(BuildContext context, cart) {
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
            "Total: ${cart.totalPrice.toStringAsFixed(2)}",
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
              // هنا ممكن تحط كل اللوجيك بتاع الطلب
            },
            child: const Text(
              "Order",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Generic TextField Builder
  static Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool required = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator:
            required ? (v) => v == null || v.isEmpty ? "Required" : null : null,
      ),
    );
  }

  // 📦 Cart Item Widget
  static Widget cartItem(
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
                      margin: EdgeInsets.only(right: 20.w),
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
                    Text(
                      item.dish.engName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                deleteButton(context, item),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                quantityControls(context, item, isUpdating),
                Text(
                  "Price: ${item.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18.sp, color: Colors.black45),
                ),
              ],
            ),
            if (item.selectedOptions.isNotEmpty)
              Padding(
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
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                option.dishOption.engName,
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
              ),
          ],
        ),
      ),
    );
  }
}
