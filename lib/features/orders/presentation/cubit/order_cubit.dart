import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/orders/data/models/order_details_model.dart';
import 'package:restaurant_management/features/orders/data/models/order_model.dart';
import 'package:restaurant_management/features/orders/data/repositories/order_repository.dart';
import 'package:restaurant_management/features/orders/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository orderRepository;

  bool _ordersLoaded = false;
  List<OrderModel>? _cachedOrders;
  final Map<String, OrderDetailsModel> _cachedOrderDetails = {};

  OrderCubit(this.orderRepository) : super(OrderInitial());

  Future<bool> createOrder({
    required int apartmentNo,
    required String buildingName,
    required String city,
    required int floor,
    required String fullAddress,
    required String street,
    required String userId,
    String additionalDirections = "",
    String notes = "",
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
        notes: notes,
      );

      _ordersLoaded = false;
      _cachedOrders = null;

      emit(OrderCreated(response["message"] ?? "Order created successfully"));
      return true;
    } catch (e) {
      emit(OrderFailure(e.toString()));
      return false;
    }
  }

  Future<void> getUserOrders(String userId, {bool forceRefresh = false}) async {
    if (_ordersLoaded && _cachedOrders != null && !forceRefresh) {
      emit(OrderListSuccess(_cachedOrders!));
      return;
    }

    emit(OrderLoading());
    try {
      final orders = await orderRepository.getUserOrders(userId);
      _cachedOrders = orders;
      _ordersLoaded = true;
      emit(OrderListSuccess(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> getOrderDetails(
    String orderId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedOrderDetails.containsKey(orderId)) {
      emit(OrderDetailsSuccess(_cachedOrderDetails[orderId]!));
      return;
    }

    emit(OrderDetailsLoading());
    try {
      final order = await orderRepository.getOrderDetails(orderId);
      _cachedOrderDetails[orderId] = order;
      emit(OrderDetailsSuccess(order));
    } catch (e) {
      emit(OrderDetailsFailure(e.toString()));
    }
  }
}
