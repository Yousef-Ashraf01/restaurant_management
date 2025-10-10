class OrderModel {
  final String id;
  final String userId;
  final String fullAddress;
  final String buildingName;
  final String street;
  final String city;
  final int floor;
  final int apartmentNo;
  final String additionalDirections;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.fullAddress,
    required this.buildingName,
    required this.street,
    required this.city,
    required this.floor,
    required this.apartmentNo,
    required this.additionalDirections,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    String dateStr = json["date"]?.toString() ?? "";

    if (dateStr.contains(".")) {
      int dotIndex = dateStr.indexOf(".");
      int endIndex =
          (dotIndex + 7 < dateStr.length) ? dotIndex + 7 : dateStr.length;
      dateStr = dateStr.substring(0, endIndex);
    }

    return OrderModel(
      id: (json["id"] ?? "").toString(),
      userId: json["userId"]?.toString() ?? "",
      fullAddress: json["fullAddress"]?.toString() ?? "",
      buildingName: json["buildingName"]?.toString() ?? "",
      street: json["street"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      floor: int.tryParse(json["floor"]?.toString() ?? "0") ?? 0,
      apartmentNo: int.tryParse(json["apartmentNo"]?.toString() ?? "0") ?? 0,
      additionalDirections: json["additionalDirections"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "pending",
      createdAt: DateTime.tryParse(dateStr) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "fullAddress": fullAddress,
      "buildingName": buildingName,
      "street": street,
      "city": city,
      "floor": floor,
      "apartmentNo": apartmentNo,
      "additionalDirections": additionalDirections,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
