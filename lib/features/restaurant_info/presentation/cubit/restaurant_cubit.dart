import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/restaurant_info/data/models/restaurantInfoResponse.dart';
import 'package:restaurant_management/features/restaurant_info/data/repositories/restaurant_repository.dart';
import 'package:restaurant_management/features/restaurant_info/presentation/cubit/restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final RestaurantRepository repository;
  bool _hasLoaded = false;
  RestaurantData? _cachedRestaurant;

  RestaurantCubit(this.repository) : super(RestaurantInitial());

  Future<void> getRestaurantInfo({bool forceRefresh = false}) async {
    if (_hasLoaded && _cachedRestaurant != null && !forceRefresh) {
      emit(RestaurantLoaded(_cachedRestaurant!));
      return;
    }

    emit(RestaurantLoading());
    try {
      final isConnected = await Connectivity().checkConnectivity();
      if (isConnected == ConnectivityResult.none) {
        throw Exception("No internet connection");
      }

      final restaurantData = await repository.fetchRestaurantInfo();

      _cachedRestaurant = restaurantData;
      _hasLoaded = true;

      print("Restaurant fetched: ${restaurantData.arbName}");
      emit(RestaurantLoaded(restaurantData));
    } catch (e) {
      print("Error fetching restaurant: $e");
      emit(RestaurantError(e.toString()));
    }
  }
}
