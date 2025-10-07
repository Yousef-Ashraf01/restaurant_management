import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/domain/repositories/cart_repository.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repository;

  CartCubit(this.repository) : super(CartInitial());

  Future<void> addToCart({required List<Map<String, dynamic>> items}) async {
    emit(CartLoading());
    try {
      await repository.addToCart(items: items);
      emit(CartSuccess());
      await getCart(showLoading: false); // ← إضافة: حدّث الكارت فوراً
    } on DioException catch (dioError) {
      emit(CartFailure(dioError.message.toString()));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> addSingleItemToCart({
    required int cartId,
    required int dishId,
    required int quantity,
    required List<dynamic> selectedOptions,
  }) async {
    emit(CartLoading());
    try {
      await repository.addToCart(
        items: [
          {
            "cartId": cartId,
            "dishId": dishId,
            "quantity": quantity,
            "selectedOptions": selectedOptions,
          },
        ],
      );
      await getCart(showLoading: false);
    } on DioException catch (dioError) {
      emit(CartFailure(dioError.message.toString()));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> getCart({bool showLoading = true}) async {
    if (showLoading) emit(CartLoading());
    try {
      final cart = await repository.fetchCart();
      if (cart == null) {
        emit(CartEmpty()); // 🧺 يعني الكارت فاضي
      } else {
        emit(CartLoaded(cart));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateQuantity({
    required int cartId,
    required int cartItemId,
    required int newQuantity,
  }) async {
    if (newQuantity < 1) {
      await deleteItem(cartId: cartId, cartItemId: cartItemId);
      return;
    }

    if (state is! CartLoaded) return; // ← حماية

    emit(CartUpdatingItem(cartItemId, (state as CartLoaded).cart));
    try {
      await repository.updateCartItemQuantity(
        cartId: cartId,
        cartItemId: cartItemId,
        newQuantity: newQuantity,
      );
      await getCart(showLoading: false);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> deleteItem({
    required int cartId,
    required int cartItemId,
  }) async {
    if (state is! CartLoaded) return;

    final currentState = state as CartLoaded;
    final currentCart = currentState.cart;

    // 🟢 1. احذف العنصر محليًا
    final updatedItems = List.of(currentCart.items)
      ..removeWhere((item) => item.id == cartItemId);

    // 🧮 2. احسب totalPrice جديد فورًا
    final newTotal = updatedItems.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    // ✳️ 3. عمل نسخة جديدة بالكارت المحدّث
    final updatedCart = currentCart.copyWith(
      items: updatedItems,
      totalPrice: newTotal, // ← مهم جداً
    );

    // 🔹 4. Emit فورًا عشان الـ UI يتحدث
    emit(CartLoaded(updatedCart));

    try {
      // 🔹 5. بعدين امسح من السيرفر
      await repository.deleteCartItem(cartId: cartId, cartItemId: cartItemId);
    } catch (e) {
      // 🔴 لو فشل، رجع الحالة القديمة
      emit(CartLoaded(currentCart));
      emit(CartError("Failed to delete item: $e"));
    }
  }
}
