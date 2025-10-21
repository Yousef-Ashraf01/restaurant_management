// dish_details_state.dart
class DishDetailsState {
  final Map<int, dynamic> selectedOptions;
  final double totalPrice;
  final bool isSizeSelected;
  final int quantity;

  DishDetailsState({
    required this.selectedOptions,
    required this.totalPrice,
    required this.isSizeSelected,
    this.quantity = 1,
  });

  DishDetailsState copyWith({
    Map<int, dynamic>? selectedOptions,
    double? totalPrice,
    bool? isSizeSelected,
    int? quantity,
  }) {
    return DishDetailsState(
      selectedOptions: selectedOptions ?? this.selectedOptions,
      totalPrice: totalPrice ?? this.totalPrice,
      isSizeSelected: isSizeSelected ?? this.isSizeSelected,
      quantity: quantity ?? this.quantity,
    );
  }
}
