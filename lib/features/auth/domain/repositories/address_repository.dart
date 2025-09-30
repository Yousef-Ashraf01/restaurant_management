import 'package:restaurant_management/features/auth/data/datasources/address_remote_data_source.dart';
import 'package:restaurant_management/features/auth/data/models/address_model.dart';

abstract class AddressRepository {
  Future<List<AddressModel>> fetchAddresses(String userId);
  Future<AddressModel> addAddress(AddressModel address);
  Future<void> deleteAddress(String addressId, String userId);
  Future<AddressModel> updateAddress(AddressModel address, String userId);
}

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remote;
  AddressRepositoryImpl(this.remote);

  @override
  Future<List<AddressModel>> fetchAddresses(String userId) {
    return remote.getAddresses(userId);
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) {
    return remote.addAddress(address);
  }

  @override
  Future<void> deleteAddress(String addressId, String userId) {
    return remote.deleteAddress(addressId, userId);
  }

  Future<AddressModel> updateAddress(AddressModel address, String userId) {
    return remote.updateAddress(address, userId);
  }
}
