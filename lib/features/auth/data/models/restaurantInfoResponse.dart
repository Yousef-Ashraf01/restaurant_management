class RestaurantInfoResponse {
  final bool success;
  final int statusCode;
  final String message;
  final RestaurantData? data;

  RestaurantInfoResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory RestaurantInfoResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantInfoResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? RestaurantData.fromJson(json['data']) : null,
    );
  }
}

class RestaurantData {
  final int id;
  final String arbName;
  final String engName;
  final String phoneNumber;
  final String logo;
  final List<Branch> branches;
  final double deliveryFees;

  RestaurantData({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.phoneNumber,
    required this.logo,
    required this.deliveryFees,
    required this.branches,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id: json['id'],
      arbName: json['arbName'] ?? '',
      engName: json['engName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      logo: json['logo'] ?? '',
      deliveryFees: (json['deliveryFees'] ?? 0).toDouble(),
      branches:
          (json['branches'] as List<dynamic>?)
              ?.map((e) => Branch.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Branch {
  final int id;
  final String arbName;
  final String engName;
  final String fullAddress;
  final String? phoneNumber;

  Branch({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.fullAddress,
    this.phoneNumber,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      arbName: json['arbName'] ?? '',
      engName: json['engName'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      phoneNumber: json['phoneNumber'],
    );
  }
}
