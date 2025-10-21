import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:restaurant_management/features/cart/data/models/cart_model.dart';

class CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  CartRepository(this.remoteDataSource, this.tokenStorage);

  Future<void> addToCart({required List<Map<String, dynamic>> items}) async {
    final userId = tokenStorage.getUserId();
    if (userId == null) throw Exception("User not logged in");

    final body = {"userId": userId, "items": items};
    await remoteDataSource.addToCart(body);
  }

  Future<CartModel> fetchCart() async {
    final userId = await tokenStorage.getUserId();
    if (userId == null) throw Exception("User not logged in");

    final cart = await remoteDataSource.getCart(userId);
    if (cart == null) throw Exception("Cart not found");

    return cart;
  }

  Future<void> updateCartItemQuantity({
    required int cartId,
    required int cartItemId,
    required int newQuantity,
  }) async {
    await remoteDataSource.updateCartItemQuantity(
      cartId: cartId,
      cartItemId: cartItemId,
      newQuantity: newQuantity,
    );
  }

  Future<void> deleteCartItem({
    required int cartId,
    required int cartItemId,
  }) async {
    await remoteDataSource.deleteCartItem(
      cartId: cartId,
      cartItemId: cartItemId,
    );
  }

  Future<void> updateCartItemNotes({
    required int cartId,
    required int cartItemId,
    required String notes,
  }) async {
    await remoteDataSource.updateCartItemNotes(
      cartId: cartId,
      cartItemId: cartItemId,
      notes: notes,
    );
  }
}
