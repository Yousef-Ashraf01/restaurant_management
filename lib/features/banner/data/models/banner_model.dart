class BannerModel {
  final int id;
  final String name;
  final bool inActive;
  final String image; // Base64
  final int? linkId;
  final String? linkType;

  BannerModel({
    required this.id,
    required this.name,
    required this.inActive,
    required this.image,
    this.linkId,
    this.linkType,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      name: json['name'],
      inActive: json['inActive'],
      image: json['image'],
      linkId: json['linkId'],
      linkType: json['linkType'],
    );
  }
}
