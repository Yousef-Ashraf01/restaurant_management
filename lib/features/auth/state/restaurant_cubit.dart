import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/domain/repositories/restaurant_repository.dart';
import 'package:restaurant_management/features/auth/state/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final RestaurantRepository repository;
  RestaurantCubit(this.repository) : super(RestaurantInitial());

  Future<void> getRestaurantInfo() async {
    emit(RestaurantLoading());
    try {
      final restaurant = await repository.fetchRestaurantInfo();
      print("🏪 Restaurant fetched: ${restaurant.arbName}");
      emit(RestaurantLoaded(restaurant));
    } catch (e) {
      print("❌ Error fetching restaurant: $e");
      emit(RestaurantError(e.toString()));
    }
  }
}
