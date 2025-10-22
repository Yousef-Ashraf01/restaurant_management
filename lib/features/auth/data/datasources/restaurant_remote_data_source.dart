import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/restaurantInfoResponse.dart';

abstract class RestaurantRemoteDataSource {
  Future<RestaurantData> getRestaurantInfo();
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final DioClient client;
  RestaurantRemoteDataSourceImpl(this.client);

  @override
  Future<RestaurantData> getRestaurantInfo() async {
    final response = await client.get("/api/RestaurantInfo");
    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");

    if (response.data['success'] == true) {
      return RestaurantData.fromJson(response.data['data']);
    } else {
      throw Exception(
        response.data['message'] ?? "Failed to fetch restaurant info",
      );
    }
  }
}
