import 'package:restaurant_management/features/auth/data/models/address_model.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  AddressLoaded(this.addresses);
}

class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}

class AddAddressInitial extends AddressState {}

class AddAddressLoading extends AddressState {}

class AddAddressSuccess extends AddressState {
  final AddressModel address;
  AddAddressSuccess(this.address);
}

class AddAddressError extends AddressState {
  final String message;
  AddAddressError(this.message);
}

class UpdateaddressLoading extends AddressState {}

class UpdateAddressSuccess extends AddressState {
  final AddressModel address;
  UpdateAddressSuccess(this.address);
}

class UpdateAddressError extends AddressState {
  final String message;
  UpdateAddressError(this.message);
}

class DeleteAddressLoading extends AddressState {}

class DeleteAddressSuccess extends AddressState {}

class DeleteAddressError extends AddressState {
  final String message;
  DeleteAddressError(this.message);
}
