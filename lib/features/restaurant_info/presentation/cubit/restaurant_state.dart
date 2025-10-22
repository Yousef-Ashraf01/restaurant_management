import 'package:restaurant_management/features/restaurant_info/data/models/restaurantInfoResponse.dart';

abstract class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final RestaurantData restaurant;
  RestaurantLoaded(this.restaurant);
}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}
