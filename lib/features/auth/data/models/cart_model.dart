import 'package:restaurant_management/features/auth/data/models/cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final double totalPrice;

  CartModel({required this.items, required this.totalPrice});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items:
          json['items'] != null
              ? List<CartItemModel>.from(
                (json['items'] as List).map((x) => CartItemModel.fromJson(x)),
              )
              : [],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  CartModel copyWith({List<CartItemModel>? items, double? totalPrice}) {
    return CartModel(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
