import 'package:restaurant_management/features/orders/data/models/order_details_model.dart';
import 'package:restaurant_management/features/orders/data/models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {}

class OrderFailure extends OrderState {
  final String message;
  OrderFailure(this.message);
}

class OrderListSuccess extends OrderState {
  final List<OrderModel> orders;
  OrderListSuccess(this.orders);
}

class OrderCreated extends OrderState {
  final String message;
  OrderCreated(this.message);
}

class OrderDetailsLoading extends OrderState {}

class OrderDetailsSuccess extends OrderState {
  final OrderDetailsModel order;
  OrderDetailsSuccess(this.order);
}

class OrderDetailsFailure extends OrderState {
  final String message;
  OrderDetailsFailure(this.message);
}
