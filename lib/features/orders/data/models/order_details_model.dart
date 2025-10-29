import 'package:restaurant_management/features/home/data/models/dish_model.dart';

class OrderDetailsModel {
  final int id;
  final String orderNo;
  final String userId;
  final double totalPrice;
  final double orderTotal;
  final int status;
  final DateTime date;
  final String buildingName;
  final int floor;
  final String street;
  final String city;
  final String fullAddress;
  final String additionalDirections;
  final int apartmentNo;
  final String displayAddress;
  final UserModel? user;
  final List<OrderItemModel> items;
  final String? notes;
  final double deliveryFees;

  OrderDetailsModel({
    required this.id,
    required this.orderNo,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.date,
    required this.buildingName,
    required this.floor,
    required this.street,
    required this.city,
    required this.fullAddress,
    required this.additionalDirections,
    required this.apartmentNo,
    required this.displayAddress,
    required this.user,
    required this.items,
    required this.orderTotal,
    this.notes,
    required this.deliveryFees,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json["id"] ?? 0,
      orderNo: json["orderNo"]?.toString() ?? "",
      userId: json["userId"]?.toString() ?? "",
      totalPrice: (json["totalPrice"] ?? 0).toDouble(),
      orderTotal: (json["orderTotal"] ?? 0).toDouble(),
      deliveryFees: (json["deliveryFees"] ?? 0).toDouble(),
      status: json["status"] ?? 0,
      date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
      buildingName: json["buildingName"]?.toString() ?? "",
      floor: json["floor"] ?? 0,
      street: json["street"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      fullAddress: json["fullAddress"]?.toString() ?? "",
      additionalDirections: json["additionalDirections"]?.toString() ?? "",
      apartmentNo: json["apartmentNo"] ?? 0,
      displayAddress: json["displayAddress"]?.toString() ?? "",
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      items:
          (json["items"] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
      notes: json["notes"]?.toString(),
    );
  }
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int dishId;
  final double dishBasePrice;
  final int quantity;
  final double totalPrice;
  final DishModel? dish;
  final List<SelectedOption>? selectedOptions;
  final String? notes;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.dishId,
    required this.dishBasePrice,
    required this.quantity,
    required this.totalPrice,
    required this.dish,
    this.selectedOptions,
    this.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json["id"] ?? 0,
      orderId: json["orderId"] ?? 0,
      dishId: json["dishId"] ?? 0,
      dishBasePrice: (json["dishBasePrice"] ?? 0).toDouble(),
      quantity: json["quantity"] ?? 0,
      totalPrice: (json["totalPrice"] ?? 0).toDouble(),
      dish: json["dish"] != null ? DishModel.fromJson(json["dish"]) : null,
      notes: json["notes"]?.toString(),
      selectedOptions:
          (json['selectedOptions'] as List?)
              ?.map((e) => SelectedOption.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UserModel {
  final String id;
  final String userName;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phoneNumber;
  final bool isActive;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phoneNumber,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"]?.toString() ?? "",
      userName: json["userName"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      firstName: json["firstName"]?.toString() ?? "",
      lastName: json["lastName"]?.toString() ?? "",
      fullName: json["fullName"]?.toString() ?? "",
      phoneNumber: json["phoneNumber"]?.toString() ?? "",
      isActive: json["isActive"] ?? false,
    );
  }
}

class SelectedOption {
  final int id;
  final int orderItemId;
  final int dishOptionId;
  final double optionPrice;
  final DishOption dishOption;

  SelectedOption({
    required this.id,
    required this.orderItemId,
    required this.dishOptionId,
    required this.optionPrice,
    required this.dishOption,
  });

  factory SelectedOption.fromJson(Map<String, dynamic> json) {
    return SelectedOption(
      id: json['id'],
      orderItemId: json['orderItemId'],
      dishOptionId: json['dishOptionId'],
      optionPrice: (json['optionPrice'] ?? 0).toDouble(),
      dishOption: DishOption.fromJson(json['dishOption']),
    );
  }
}

class DishOption {
  final int id;
  final String arbName;
  final String engName;
  final double price;

  DishOption({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.price,
  });

  factory DishOption.fromJson(Map<String, dynamic> json) {
    return DishOption(
      id: json['id'],
      arbName: json['arbName'] ?? '',
      engName: json['engName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
