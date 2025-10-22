import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/order_details_model.dart';
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
    String notes = "",
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
      "notes": notes
    };

    try {
      final response = await dioClient.post("/api/Orders", data: body);
      return response.data ?? {};
    } catch (e) {
      print("createOrder DioClient error: $e");
      rethrow;
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await dioClient.get("/api/Orders/User/$userId");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
      if (response.data["success"] == true) {
        final List data = response.data["data"] ?? [];
        print(
          "Order Status Debug: ${data.map((e) => e["status"]).toList()}",
        );
        return data.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data["message"] ?? "Failed to load orders");
      }
    } catch (e) {
      print("getUserOrders DioClient error: $e");
      rethrow;
    }
  }

  Future<OrderDetailsModel> getOrderDetails(String orderId) async {
    try {
      final response = await dioClient.get("/api/Orders/$orderId");
      print("🔍 getOrderDetails Response: ${response.data}");

      if (response.data["success"] == true) {
        final data = response.data["data"];
        return OrderDetailsModel.fromJson(data);
      } else {
        throw Exception(
          response.data["message"] ?? "Failed to load order details",
        );
      }
    } catch (e) {
      print("❌ getOrderDetails DioClient error: $e");
      rethrow;
    }
  }
}
