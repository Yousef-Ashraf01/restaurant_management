import 'package:restaurant_management/core/network/dio_client.dart';

import '../models/dish_model.dart';

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
      print("🔍 Response status: ${response.statusCode}");
      print("🔍 Response data: ${response.data}");

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

  @override
  Future<List<DishModel>> getDishesByCategory(String categoryId) async {
    try {
      final response = await dioClient.get('/api/Dishes/category/$categoryId');

      print("🧾 Response: ${response.data}");

      // نتأكد إن الرد مش null
      final data = response.data;

      // الحالة 1️⃣: لو السيرفر رجّع success = false أو statusCode != 200
      if (data is Map<String, dynamic>) {
        final success = data['success'] ?? false;
        final message = data['message'] ?? 'Unknown error';

        // لو السيرفر قال مفيش أطباق
        if (success == false && data['data'] == null) {
          print("⚠️ $message");
          return []; // نرجّع ليست فاضية بدل ما نرمي Exception
        }

        // الحالة 2️⃣: لو فيه بيانات في data
        if (data['data'] is List) {
          return (data['data'] as List)
              .map((e) => DishModel.fromJson(e))
              .toList();
        }
      }

      // fallback لو البيانات كانت مباشرة List
      if (data is List) {
        return data.map((e) => DishModel.fromJson(e)).toList();
      }

      // في أي حالة غير متوقعة
      return [];
    } catch (e) {
      print("❌ Error while fetching category dishes: $e");
      return []; // نرجّع ليست فاضية بدل ما نعمل crash
    }
  }
}
