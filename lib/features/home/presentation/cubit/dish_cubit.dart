import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/home/data/models/dish_model.dart';
import 'package:restaurant_management/features/home/data/repositories/dish_repository.dart';

import 'dish_state.dart';

class DishCubit extends Cubit<DishState> {
  final DishRepository repository;

  bool _allDishesLoaded = false;
  List<DishModel>? _cachedAllDishes;

  final Map<String, List<DishModel>> _cachedCategoryDishes = {}; // كاش للفئات

  DishCubit(this.repository) : super(DishInitial());

  // ✅ تحميل كل الأطباق مرة واحدة فقط
  Future<void> getDishes({bool forceRefresh = false}) async {
    if (_allDishesLoaded && _cachedAllDishes != null && !forceRefresh) {
      emit(DishLoaded(_cachedAllDishes!)); // استخدم الكاش
      return;
    }

    emit(DishLoading());
    try {
      final dishes = await repository.fetchDishes();
      _cachedAllDishes = dishes;
      _allDishesLoaded = true;
      print("Loaded ${dishes.length} dishes");
      emit(DishLoaded(dishes));
    } catch (e) {
      print("Failed to load dishes: $e");
      emit(DishError(e.toString()));
    }
  }

  // ✅ تحميل الأطباق حسب الفئة مرة واحدة فقط
  Future<void> getDishesByCategory(
    String categoryId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedCategoryDishes.containsKey(categoryId)) {
      emit(DishLoaded(_cachedCategoryDishes[categoryId]!)); // استخدم الكاش
      return;
    }

    emit(DishLoading());
    try {
      final dishes = await repository.fetchDishesByCategory(categoryId);
      _cachedCategoryDishes[categoryId] = dishes;
      print("Loaded ${dishes.length} dishes for category $categoryId");
      emit(DishLoaded(dishes));
    } catch (e) {
      print("Failed to load category dishes: $e");
      emit(DishError(e.toString()));
    }
  }

  // ✅ استرجاع طبق معين من الكاش
  DishModel? getDishById(int id) {
    if (_cachedAllDishes != null) {
      return _cachedAllDishes!.firstWhere(
        (dish) => dish.id == id,
        orElse: () => throw Exception("Dish not found"),
      );
    }
    return null;
  }
}
