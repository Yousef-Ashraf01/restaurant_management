import 'package:restaurant_management/features/auth/data/datasources/banner_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/banner_model.dart';

abstract class BannerRepository {
  Future<List<BannerModel>> getBanners();
}

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remote;

  BannerRepositoryImpl(this.remote);

  @override
  Future<List<BannerModel>> getBanners() {
    return remote.getBanners();
  }
}
