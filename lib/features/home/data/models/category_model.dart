class CategoryModel {
  final int id;
  final String arbName;
  final String engName;
  final bool? inActive;
  final String icon;

  CategoryModel({
    required this.id,
    required this.arbName,
    required this.engName,
    this.inActive,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      arbName: json['arbName'] ?? '',
      engName: json['engName'] ?? '',
      inActive: json['inActive'] ?? false,
      icon: json['icon'] ?? '',
    );
  }
}
