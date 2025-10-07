import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/banner_model.dart';

class BannerService {
  late final DioClient dioClient;

  Future<List<BannerModel>> getBanners() async {
    final response = await dioClient.get(
      "https://restaurantmanagementsystem.runasp.net/api/Banners?skip=0&take=2147483647",
    );

    if (response.statusCode == 200 && response.data["success"]) {
      List data = response.data["data"];
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load banners");
    }
  }
}
