import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/cart_model.dart';

class CartRemoteDataSource {
  final DioClient dioClient;

  CartRemoteDataSource(this.dioClient);

  Future<void> addToCart(Map<String, dynamic> body) async {
    await dioClient.post("/api/Carts", data: body);
  }

  Future<CartModel> getCart(String userId) async {
    try {
      final response = await dioClient.get("/api/Carts/user/$userId");

      // ✅ لو الكارت موجود
      if (response.data['success'] == true && response.data['data'] != null) {
        return CartModel.fromJson(response.data['data']);
      } else {
        print('🛒 No cart found for user $userId → returning empty cart');
        return CartModel(items: [], totalPrice: 0.0);
      }
    } catch (e) {
      print('❌ Error in getCart: $e');
      return CartModel(items: [], totalPrice: 0.0);
    }
  }

  Future<void> updateCartItemQuantity({
    required int cartId,
    required int cartItemId,
    required int newQuantity,
  }) async {
    final body = {"cartItemId": cartItemId, "newQuantity": newQuantity};
    await dioClient.put("/api/Carts/$cartId/items/quantity", data: body);
  }

  Future<void> deleteCartItem({
    required int cartId,
    required int cartItemId,
  }) async {
    final body = {"cartId": cartId, "cartItemId": cartItemId};
    final response = await dioClient.delete(
      "/api/Carts/$cartId/items",
      data: body,
    );
    print('🗑️ DELETE Response: ${response.data}');
  }
}
