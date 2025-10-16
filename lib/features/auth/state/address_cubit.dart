import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/features/auth/data/models/address_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/state/address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository repository;
  final TokenStorage tokenStorage;

  AddressCubit(this.repository, this.tokenStorage) : super(AddressInitial()) {
    // ✅ تحميل العنوان المختار سابقًا (لو محفوظ)
    final savedAddressLabel = tokenStorage.getSelectedAddress();
    final userId = tokenStorage.getUserId();
    if (savedAddressLabel != null) {
      selectedAddress = AddressModel(
        fullAddress: savedAddressLabel,
        userId: userId,
      );
      emit(AddressSelected(savedAddressLabel));
    }
  }

  AddressModel? selectedAddress;

  void selectAddress(AddressModel address) {
    selectedAddress = address;
    if (state is AddressLoaded) {
      emit(AddressLoaded((state as AddressLoaded).addresses));
    }
  }

  Future<void> getUserAddresses(String userId) async {
    emit(AddressLoading());
    try {
      final addresses = await repository.fetchAddresses(userId);
      print("🏠 Fetched ${addresses.length} addresses for userId $userId");

      // ✅ لو عندي عنوان مختار قبل كده، رجّعه بنفسه بعد التحديث
      if (selectedAddress != null) {
        final stillExists = addresses.firstWhere(
          (a) => a.id == selectedAddress!.id,
          orElse:
              () => addresses.isNotEmpty ? addresses.first : selectedAddress!,
        );
        selectedAddress = stillExists;
      }

      emit(AddressLoaded(addresses));
    } catch (e) {
      print("❌ Error fetching addresses: $e");
      emit(AddressError(e.toString()));
    }
  }

  Future<void> addAddress(AddressModel address) async {
    if (address.userId == null || address.userId!.isEmpty) {
      emit(AddressError("Cannot add address: userId is null or empty"));
      return;
    }

    emit(AddressLoading());
    try {
      final newAddress = await repository.addAddress(address);
      print("✅ Added address: ${newAddress.id}");

      final updatedAddresses = await repository.fetchAddresses(address.userId!);
      emit(AddressLoaded(updatedAddresses));
    } catch (e) {
      print("❌ Failed to add address: $e");
      emit(AddressError(e.toString()));
    }
  }

  Future<void> deleteAddress(String addressId, String userId) async {
    if (state is AddressLoaded) {
      final currentAddresses = List<AddressModel>.from(
        (state as AddressLoaded).addresses,
      );

      currentAddresses.removeWhere((address) => address.id == addressId);
      emit(AddressLoaded(currentAddresses));

      try {
        await repository.deleteAddress(addressId, userId);
        final updatedAddresses = await repository.fetchAddresses(userId);
        emit(AddressLoaded(updatedAddresses));
      } catch (e) {
        print("❌ Failed to delete address: $e");
        emit(AddressError("Failed to delete: ${e.toString()}"));
        emit(AddressLoaded(currentAddresses)); // ارجع الليست القديمة
      }
    }
  }

  Future<void> updateAddress(AddressModel address, String userId) async {
    if (address.id == null || address.userId == null) {
      emit(AddressError("Cannot update address: id or userId is null"));
      return;
    }

    emit(AddressLoading());
    try {
      final updatedAddress = await repository.updateAddress(address, userId);
      print("✅ Updated address: ${updatedAddress.id}");

      if (state is AddressLoaded) {
        final updatedList =
            (state as AddressLoaded).addresses.map((a) {
              return a.id == updatedAddress.id ? updatedAddress : a;
            }).toList();
        emit(AddressLoaded(updatedList));
      } else {
        final updatedAddresses = await repository.fetchAddresses(userId);
        emit(AddressLoaded(updatedAddresses));
      }
    } catch (e) {
      print("❌ Failed to update address: $e");
      emit(AddressError("Failed to update address: ${e.toString()}"));
    }
  }
}
