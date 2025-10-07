import 'package:restaurant_management/features/auth/data/datasources/order_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/order_model.dart';

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
    );
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    return await remoteDataSource.getUserOrders(userId);
  }
}
