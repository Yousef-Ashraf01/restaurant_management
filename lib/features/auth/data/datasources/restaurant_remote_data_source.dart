import 'package:dio/dio.dart';
import 'package:restaurant_management/features/auth/data/models/restaurantInfoResponse.dart';

abstract class RestaurantRemoteDataSource {
  Future<RestaurantData> getRestaurantInfo();
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio client;
  RestaurantRemoteDataSourceImpl(this.client);

  @override
  Future<RestaurantData> getRestaurantInfo() async {
    final response = await client.get("/api/RestaurantInfo");

    if (response.data['success'] == true) {
      return RestaurantData.fromJson(response.data['data']);
    } else {
      throw Exception(
        response.data['message'] ?? "Failed to fetch restaurant info",
      );
    }
  }
}
