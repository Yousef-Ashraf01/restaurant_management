import 'package:restaurant_management/features/auth/data/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {}

class CartFailure extends CartState {
  final String message;
  CartFailure(this.message);
}

class CartLoaded extends CartState {
  final CartModel cart;
  CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartEmpty extends CartState {}

class CartUpdatingItem extends CartState {
  final int itemId;
  final CartModel previousCart;

  CartUpdatingItem(this.itemId, this.previousCart);
}
