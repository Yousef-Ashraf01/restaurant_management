import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/order_model.dart';

class OrderRemoteDataSource {
  final DioClient dioClient;

  OrderRemoteDataSource(this.dioClient);

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
    final body = {
      "apartmentNo": apartmentNo,
      "buildingName": buildingName,
      "city": city,
      "floor": floor,
      "fullAddress": fullAddress,
      "street": street,
      "userId": userId,
      "additionalDirections": additionalDirections,
    };

    try {
      final response = await dioClient.post("/api/Orders", data: body);
      return response.data ?? {};
    } catch (e) {
      print("❌ createOrder DioClient error: $e");
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await dioClient.get("/api/Orders/User/$userId");
      if (response.data["success"] == true) {
        final List data = response.data["data"] ?? [];
        print(
          "📡 Order Status Debug: ${data.map((e) => e["status"]).toList()}",
        );
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data["message"] ?? "Failed to load orders");
      }
    } catch (e) {
      print("❌ getUserOrders DioClient error: $e");
      rethrow;
    }
  }
}
