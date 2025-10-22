import 'package:restaurant_management/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_management/features/orders/data/models/order_details_model.dart';
import 'package:restaurant_management/features/orders/data/models/order_model.dart';

class OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepository(this.remoteDataSource);

  Future<Map<String, dynamic>> createOrder({
    required int apartmentNo,
    required String buildingName,
    required String city,
    required int floor,
    required String fullAddress,
    required String street,
    required String userId,
    String additionalDirections = "",
    String notes = "",
  }) async {
    return await remoteDataSource.createOrder(
      apartmentNo: apartmentNo,
      buildingName: buildingName,
      city: city,
      floor: floor,
      fullAddress: fullAddress,
      street: street,
      userId: userId,
      additionalDirections: additionalDirections,
      notes: notes,
    );
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    return await remoteDataSource.getUserOrders(userId);
  }

  Future<OrderDetailsModel> getOrderDetails(String orderId) async {
    return await remoteDataSource.getOrderDetails(orderId);
  }
}
