import 'package:restaurant_management/features/home/data/datasources/category_remote_data_source.dart';
import 'package:restaurant_management/features/home/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> fetchCategories();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remote;

  CategoryRepositoryImpl(this.remote);

  @override
  Future<List<CategoryModel>> fetchCategories() {
    return remote.getCategories();
  }
}
