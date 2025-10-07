import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/dish_repository.dart';
import 'dish_state.dart';

class DishCubit extends Cubit<DishState> {
  final DishRepository repository;

  DishCubit(this.repository) : super(DishInitial());

  Future<void> getDishes() async {
    emit(DishLoading());
    try {
      final dishes = await repository.fetchDishes();
      print("🍽️ Loaded ${dishes.length} dishes");
      emit(DishLoaded(dishes));
    } catch (e) {
      print("❌ Failed to load dishes: $e");
      emit(DishError(e.toString()));
    }
  }
}
