import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/domain/repositories/order_repository.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository orderRepository;

  OrderCubit(this.orderRepository) : super(OrderInitial());

  Future<void> createOrder({
    required int apartmentNo,
    required String buildingName,
    required String city,
    required int floor,
    required String fullAddress,
    required String street,
    required String userId,
    String additionalDirections = "",
    String notes = ""
  }) async {
    emit(OrderLoading());
    try {
      final response = await orderRepository.createOrder(
        apartmentNo: apartmentNo,
        buildingName: buildingName,
        city: city,
        floor: floor,
        fullAddress: fullAddress,
        street: street,
        userId: userId,
        additionalDirections: additionalDirections,
        notes: notes
      );

      emit(OrderCreated(response["message"] ?? "Order created successfully"));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> getUserOrders(String userId) async {
    emit(OrderLoading());
    try {
      final orders = await orderRepository.getUserOrders(userId);

      emit(OrderListSuccess(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> getOrderDetails(String orderId) async {
    emit(OrderDetailsLoading());
    try {
      final order = await orderRepository.getOrderDetails(orderId);
      emit(OrderDetailsSuccess(order));
    } catch (e) {
      emit(OrderDetailsFailure(e.toString()));
    }
  }
}
