import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';

abstract class DishRemoteDataSource {
  Future<List<DishModel>> getDishes();
  Future<List<DishModel>> getDishesByCategory(String categoryId);
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
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.data['success'] == true) {
        final dishesJson = response.data['data'] as List;
        return dishesJson.map((e) => DishModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch dishes");
      }
    } catch (e) {
      print("Error fetching dishes with DioClient: $e");
      rethrow;
    }
  }

  @override
  Future<List<DishModel>> getDishesByCategory(String categoryId) async {
    try {
      final response = await dioClient.get('/api/Dishes/category/$categoryId');

      print("Response: ${response.data}");

      final data = response.data;

      if (data is Map<String, dynamic>) {
        final success = data['success'] ?? false;
        final message = data['message'] ?? 'Unknown error';

        if (success == false && data['data'] == null) {
          print("$message");
          return [];
        }

        if (data['data'] is List) {
          return (data['data'] as List)
              .map((e) => DishModel.fromJson(e))
              .toList();
        }
      }

      if (data is List) {
        return data.map((e) => DishModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("Error while fetching category dishes: $e");
      return [];
    }
  }
}
