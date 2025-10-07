// dish_details_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/data/models/dish_model.dart';
import 'package:restaurant_management/features/auth/state/dish_details_state.dart';

class DishDetailsCubit extends Cubit<DishDetailsState> {
  final DishModel dish;

  DishDetailsCubit(this.dish)
    : super(
        DishDetailsState(
          selectedOptions: {},
          totalPrice: dish.basePrice, // 👈 السعر الأساسي
          isSizeSelected:
              dish.optionGroups.where((g) => g.isRequired == true).isEmpty,
          quantity: 1, // 👈 ابدأ بواحد
        ),
      );

  void selectOption(int groupId, dynamic option, {bool allowMultiple = false}) {
    final newOptions = Map<int, dynamic>.from(state.selectedOptions);

    if (allowMultiple) {
      final current = List.from(newOptions[groupId] ?? []);
      if (current.contains(option)) {
        current.remove(option);
      } else {
        current.add(option);
      }
      newOptions[groupId] = current;
    } else {
      newOptions[groupId] = option;
    }

    final newTotal = _calculateTotal(newOptions, state.quantity);
    final newIsSizeSelected = _checkRequired(newOptions);

    emit(
      state.copyWith(
        selectedOptions: newOptions,
        totalPrice: newTotal,
        isSizeSelected: newIsSizeSelected,
      ),
    );
  }

  // 👇 دوال التحكم في الكمية
  void incrementQuantity() {
    final newQuantity = state.quantity + 1;
    emit(
      state.copyWith(
        quantity: newQuantity,
        totalPrice: _calculateTotal(state.selectedOptions, newQuantity),
      ),
    );
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      final newQuantity = state.quantity - 1;
      emit(
        state.copyWith(
          quantity: newQuantity,
          totalPrice: _calculateTotal(state.selectedOptions, newQuantity),
        ),
      );
    }
  }

  double _calculateTotal(Map<int, dynamic> options, int quantity) {
    double total = dish.basePrice; // 👈 نبدأ بسعر الطبق الأساسي
    options.forEach((key, value) {
      if (value is List) {
        total += value.fold(0, (sum, o) => sum + o.price);
      } else if (value != null) {
        total += value.price;
      }
    });
    return total * quantity; // 👈 ضرب في الكمية
  }

  bool _checkRequired(Map<int, dynamic> options) {
    final requiredGroups =
        dish.optionGroups.where((g) => g.isRequired).toList();
    if (requiredGroups.isEmpty) return true;
    return options[requiredGroups.first.id] != null;
  }
}
