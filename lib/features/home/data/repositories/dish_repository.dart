import 'package:restaurant_management/features/home/data/datasources/dish_remote_data_source.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';

abstract class DishRepository {
  Future<List<DishModel>> fetchDishes();
  Future<List<DishModel>> fetchDishesByCategory(String categoryId);
}

class DishRepositoryImpl implements DishRepository {
  final DishRemoteDataSource remote;

  DishRepositoryImpl(this.remote);

  @override
  Future<List<DishModel>> fetchDishes() {
    return remote.getDishes();
  }

  @override
  Future<List<DishModel>> fetchDishesByCategory(String categoryId) async {
    final response = await remote.getDishesByCategory(categoryId);
    return response;
  }
}
