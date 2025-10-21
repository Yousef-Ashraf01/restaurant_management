import 'package:restaurant_management/features/restaurant_info/data/datasources/restaurant_remote_data_source.dart';
import 'package:restaurant_management/features/restaurant_info/data/models/restaurantInfoResponse.dart';

abstract class RestaurantRepository {
  Future<RestaurantData> fetchRestaurantInfo();
}

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remote;
  RestaurantRepositoryImpl(this.remote);

  @override
  Future<RestaurantData> fetchRestaurantInfo() {
    return remote.getRestaurantInfo();
  }
}
