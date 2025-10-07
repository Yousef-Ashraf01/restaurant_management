class BannerModel {
  final int id;
  final String name;
  final bool inActive;
  final String image; // Base64 String

  BannerModel({
    required this.id,
    required this.name,
    required this.inActive,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      name: json['name'],
      inActive: json['inActive'],
      image: json['image'],
    );
  }
}
