import 'package:restaurant_management/core/network/dio_client.dart';

import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient dioClient;

  CategoryRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dioClient.get(
        "/api/Categories?skip=0&take=2147483647&statusFilter=2",
      );
      print("Categories response: ${response.data}");

      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw Exception(
          response.data['message'] ?? "Failed to fetch categories",
        );
      }
    } catch (e) {
      print("Error fetching categories: $e");
      rethrow;
    }
  }
}
