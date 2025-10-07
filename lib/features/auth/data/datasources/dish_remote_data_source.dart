import 'package:restaurant_management/core/network/dio_client.dart';

import '../models/dish_model.dart';

abstract class DishRemoteDataSource {
  Future<List<DishModel>> getDishes();
}

class DishRemoteDataSourceImpl implements DishRemoteDataSource {
  final DioClient dioClient;

  DishRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<DishModel>> getDishes() async {
    try {
      final response = await dioClient.get(
        "/api/Dishes?skip=0&take=2147483647&statusFilter=0",
      );

      if (response.data['success'] == true) {
        final dishesJson = response.data['data'] as List;
        return dishesJson.map((e) => DishModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch dishes");
      }
    } catch (e) {
      print("❌ Error fetching dishes with DioClient: $e");
      rethrow;
    }
  }
}
