import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';
import 'package:restaurant_management/features/home/data/repositories/dish_repository.dart';

import 'dish_state.dart';

class DishCubit extends Cubit<DishState> {
  final DishRepository repository;

  DishCubit(this.repository) : super(DishInitial());

  Future<void> getDishes() async {
    emit(DishLoading());
    try {
      final dishes = await repository.fetchDishes();
      print("Loaded ${dishes.length} dishes");
      emit(DishLoaded(dishes));
    } catch (e) {
      print("Failed to load dishes: $e");
      emit(DishError(e.toString()));
    }
  }

  Future<void> getDishesByCategory(String categoryId) async {
    emit(DishLoading());
    try {
      final dishes = await repository.fetchDishesByCategory(categoryId);
      print("Loaded ${dishes.length} dishes for category $categoryId");
      emit(DishLoaded(dishes));
    } catch (e) {
      print("Failed to load category dishes: $e");
      emit(DishError(e.toString()));
    }
  }

  DishModel? getDishById(int id) {
    if (state is DishLoaded) {
      return (state as DishLoaded).dishes.firstWhere(
        (dish) => dish.id == id,
        orElse: () => throw Exception("Dish not found"),
      );
    }
    return null;
  }
}
