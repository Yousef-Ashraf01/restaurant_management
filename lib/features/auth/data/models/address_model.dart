class AddressModel {
  String? id;
  String? addressLabel;
  String? street;
  String? city;
  int? apartmentNo;
  int? floor;
  String? fullAddress;
  String? userId;
  bool? isPrimary;
  double? latitude;
  double? longitude;
  bool? isActive;
  String? additionalDirections;
  String? buildingName;

  AddressModel({
    this.id,
    this.addressLabel,
    this.street,
    this.city,
    this.apartmentNo,
    this.floor,
    this.fullAddress,
    required this.userId,
    this.isPrimary,
    this.latitude,
    this.longitude,
    this.isActive,
    this.additionalDirections,
    this.buildingName,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json['id'],
    addressLabel: json['addressLabel'],
    apartmentNo: json['apartmentNo'],
    buildingName: json['buildingName'],
    city: json['city'],
    floor: json['floor'],
    fullAddress: json['fullAddress'],
    isPrimary: json['isPrimary'],
    street: json['street'],
    userId: json['userId'],
    additionalDirections: json['additionalDirections'],
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    isActive: json['isActive'],
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "addressLabel": addressLabel,
      "street": street,
      "city": city,
      "apartmentNo": apartmentNo,
      "floor": floor,
      "fullAddress": fullAddress,
      "userId": userId,
      "isPrimary": isPrimary,
      "latitude": latitude,
      "longitude": longitude,
      "isActive": isActive,
      "additionalDirections": additionalDirections,
      "buildingName": buildingName,
    };
  }
}
