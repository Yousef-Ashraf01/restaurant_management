import 'package:restaurant_management/core/network/dio_client.dart';
import 'package:restaurant_management/features/auth/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses(String userId);
  Future<AddressModel> addAddress(AddressModel address);
  Future<void> deleteAddress(String addressId, String userId);
  Future<AddressModel> updateAddress(AddressModel address, String userId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final DioClient dioClient;

  AddressRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<AddressModel>> getAddresses(String userId) async {
    final response = await dioClient.get('/api/Users/addresses/$userId');
    print("🔍 Response status: ${response.statusCode}");
    print("🔍 Response data: ${response.data}");

    if (response.data['success'] == true) {
      final addressesJson = response.data['data'] as List;
      return addressesJson.map((e) => AddressModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? "Failed to fetch addresses");
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    final response = await dioClient.post(
      "/api/Users/addresses",
      data: address.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddressModel.fromJson(response.data['data']);
    } else {
      throw Exception("Failed to add address");
    }
  }

  @override
  Future<void> deleteAddress(String addressId, String userId) async {
    final response = await dioClient.delete(
      "/api/Users/addresses",
      data: {"addressId": addressId, "userId": userId},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(response.data['message'] ?? "Failed to delete address");
    }
  }

  @override
  Future<AddressModel> updateAddress(
    AddressModel address,
    String userId,
  ) async {
    try {
      final response = await dioClient.put(
        "/api/Users/addresses/UpdateAddress/${address.id}",
        data: address.toJson(),
      );

      print("🔵 Update response raw: ${response.data}");

      if (response.data['success'] == true) {
        print("🟢 Updated address from server: ${response.data['data']}");
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? "Failed to update address");
      }
    } catch (e) {
      print("🔴 Error updating address: $e");
      rethrow;
    }
  }
}
