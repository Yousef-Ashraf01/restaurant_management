import 'package:restaurant_management/features/home/data/models/dish_model.dart';

class CartItemModel {
  final int id;
  final int dishId;
  final int quantity;
  final double totalPrice;
  final int cartId;
  final DishModel dish;
  final List<SelectedOptionModel> selectedOptions;
  final String? notes;

  CartItemModel({
    required this.id,
    required this.dishId,
    required this.quantity,
    required this.totalPrice,
    required this.cartId,
    required this.dish,
    required this.selectedOptions,
    this.notes,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['id'] ?? 0,
    dishId: json['dishId'] ?? 0,
    quantity: json['quantity'] ?? 0,
    totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    cartId: json['cartId'] ?? 0,
    dish: DishModel.fromJson(json['dish']),
    selectedOptions:
        json['selectedOptions'] != null
            ? List<SelectedOptionModel>.from(
              (json['selectedOptions'] as List).map(
                (x) => SelectedOptionModel.fromJson(x),
              ),
            )
            : [],
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'dishId': dishId,
    'quantity': quantity,
    'totalPrice': totalPrice,
    'cartId': cartId,
    'dish': dish.toJson(),
    'selectedOptions': List<dynamic>.from(
      selectedOptions.map((x) => x.toJson()),
    ),
    'notes': notes,
  };

  CartItemModel copyWith({
    int? id,
    int? dishId,
    int? quantity,
    double? totalPrice,
    int? cartId,
    DishModel? dish,
    List<SelectedOptionModel>? selectedOptions,
    String? notes,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      cartId: cartId ?? this.cartId,
      dish: dish ?? this.dish,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      notes: notes ?? this.notes,
    );
  }
}

class SelectedOptionModel {
  final int id;
  final int cartItemId;
  final int dishOptionId;
  final DishOptionModel dishOption;

  SelectedOptionModel({
    required this.id,
    required this.cartItemId,
    required this.dishOptionId,
    required this.dishOption,
  });

  factory SelectedOptionModel.fromJson(Map<String, dynamic> json) =>
      SelectedOptionModel(
        id: json['id'] ?? 0,
        cartItemId: json['cartItemId'] ?? 0,
        dishOptionId: json['dishOptionId'] ?? 0,
        dishOption: DishOptionModel.fromJson(json['dishOption']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cartItemId': cartItemId,
    'dishOptionId': dishOptionId,
    'dishOption': dishOption.toJson(),
  };
}

class DishOptionModel {
  final int id;
  final String arbName;
  final String engName;
  final double price;

  DishOptionModel({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.price,
  });

  factory DishOptionModel.fromJson(Map<String, dynamic> json) =>
      DishOptionModel(
        id: json['id'] ?? 0,
        arbName: json['arbName'] ?? '',
        engName: json['engName'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arbName': arbName,
    'engName': engName,
    'price': price,
  };
}
