class ProfileResponseModel {
  final bool success;
  final int statusCode;
  final String? message;
  final ProfileData? data;

  ProfileResponseModel({
    required this.success,
    required this.statusCode,
    this.message,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final String id;
  final String userName;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phoneNumber;
  final List<String> roles;
  final bool? isActive;
  final List<dynamic>? addresses;
  final dynamic primaryAddress;
  final int? addressCount;

  ProfileData({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phoneNumber,
    required this.roles,
    this.isActive,
    this.addresses,
    this.primaryAddress,
    this.addressCount,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      roles: List<String>.from(json['roles'] ?? []),
      isActive: json['isActive'],
      addresses: json['addresses'],
      primaryAddress: json['primaryAddress'],
      addressCount: json['addressCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
    };
  }
}
