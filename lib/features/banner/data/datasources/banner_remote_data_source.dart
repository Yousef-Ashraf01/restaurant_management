import 'package:dio/dio.dart';
import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/banner/data/models/banner_model.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final DioClient client;

  BannerRemoteDataSourceImpl(this.client);
  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await client.get(
        "/api/Banners?skip=0&take=2147483647&statusFilter=1",
      );
      if (response.data['success'] == true) {
        final bannersJson = response.data['data'] as List;
        return bannersJson.map((e) => BannerModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch banners");
      }
    } on DioException catch (e) {
      print("DioException type: ${e.type}, message: ${e.message}");
      throw Exception("Network error: ${e.message}");
    }
  }
}
