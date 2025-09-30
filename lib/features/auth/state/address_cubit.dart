import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/data/models/address_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository repository;
  AddressCubit(this.repository) : super(AddressInitial());

  void getUserAddresses(String userId) async {
    emit(AddressLoading());
    try {
      final addresses = await repository.fetchAddresses(userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      await repository.addAddress(address); // إضافة على الـ backend
      final updatedAddresses = await repository.fetchAddresses(
        address.userId.toString(),
      );
      emit(AddressLoaded(updatedAddresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> deleteAddress(String addressId, String userId) async {
    if (state is AddressLoaded) {
      final currentAddresses = List<AddressModel>.from(
        (state as AddressLoaded).addresses,
      );

      // شيل العنوان من الليست محليًا
      currentAddresses.removeWhere((address) => address.id == addressId);
      emit(AddressLoaded(currentAddresses));

      try {
        await repository.deleteAddress(addressId, userId);

        // بعد ما يتم الحذف من السيرفر نجيب نسخة حديثة
        final updatedAddresses = await repository.fetchAddresses(userId);
        emit(AddressLoaded(updatedAddresses));
      } catch (e) {
        // لو حصل error نرجع العناوين القديمة
        emit(AddressError("Failed to delete: ${e.toString()}"));
        emit(AddressLoaded((state as AddressLoaded).addresses));
      }
    }
  }

  Future<void> updateAddress(AddressModel address, String userId) async {
    emit(AddressLoading());
    try {
      final updatedAddress = await repository.updateAddress(address, userId);

      // هات اللي موجود دلوقتي
      final currentState = state;
      if (currentState is AddressLoaded) {
        final updatedList =
            currentState.addresses.map((a) {
              return a.id == updatedAddress.id ? updatedAddress : a;
            }).toList();

        emit(AddressLoaded(updatedList));
      } else {
        // fallback: لو مش في AddressLoaded رجع كل العناوين
        final updatedAddresses = await repository.fetchAddresses(userId);
        emit(AddressLoaded(updatedAddresses));
      }
    } catch (e) {
      emit(AddressError("Failed to update address: ${e.toString()}"));
    }
  }
}
