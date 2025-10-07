class DishModel {
  final int id;
  final String arbName;
  final String engName;
  final String arbDescription;
  final String engDescription;
  final double basePrice;
  final String image;
  final bool inActive;
  final int categoryId;
  final Category category;
  final List<OptionGroup> optionGroups;
  final DateTime regDate;
  final String regUserId;
  final DateTime? editDate;
  final String? editUserId;

  DishModel({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.arbDescription,
    required this.engDescription,
    required this.basePrice,
    required this.image,
    required this.inActive,
    required this.categoryId,
    required this.category,
    required this.optionGroups,
    required this.regDate,
    required this.regUserId,
    this.editDate,
    this.editUserId,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) => DishModel(
    id: json['id'] ?? 0,
    arbName: json['arbName'] ?? '',
    engName: json['engName'] ?? '',
    arbDescription: json['arbDescription'] ?? '',
    engDescription: json['engDescription'] ?? '',
    basePrice: (json['basePrice'] ?? 0).toDouble(),
    image: json['image'] ?? '',
    inActive: json['inActive'] ?? false,
    categoryId: json['categoryId'] ?? 0,
    category:
        json['category'] != null
            ? Category.fromJson(json['category'])
            : Category.empty(),
    optionGroups:
        json['optionGroups'] != null
            ? List<OptionGroup>.from(
              (json['optionGroups'] as List).map(
                (x) => OptionGroup.fromJson(x),
              ),
            )
            : [],
    regDate:
        json['regDate'] != null
            ? DateTime.parse(json['regDate'])
            : DateTime.now(),
    regUserId: json['regUserId'] ?? '',
    editDate:
        json['editDate'] != null ? DateTime.tryParse(json['editDate']) : null,
    editUserId: json['editUserId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arbName': arbName,
    'engName': engName,
    'arbDescription': arbDescription,
    'engDescription': engDescription,
    'basePrice': basePrice,
    'image': image,
    'inActive': inActive,
    'categoryId': categoryId,
    'category': category.toJson(),
    'optionGroups': List<dynamic>.from(optionGroups.map((x) => x.toJson())),
    'regDate': regDate.toIso8601String(),
    'regUserId': regUserId,
    'editDate': editDate?.toIso8601String(),
    'editUserId': editUserId,
  };
}

class Category {
  final int id;
  final String arbName;
  final String engName;
  final bool inActive;
  final String icon;
  final DateTime regDate;
  final String regUserId;
  final DateTime? editDate;
  final String? editUserId;

  Category({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.inActive,
    required this.icon,
    required this.regDate,
    required this.regUserId,
    this.editDate,
    this.editUserId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] ?? 0,
    arbName: json['arbName'] ?? '',
    engName: json['engName'] ?? '',
    inActive: json['inActive'] ?? false,
    icon: json['icon'] ?? '',
    regDate:
        json['regDate'] != null
            ? DateTime.parse(json['regDate'])
            : DateTime.now(),
    regUserId: json['regUserId'] ?? '',
    editDate:
        json['editDate'] != null ? DateTime.tryParse(json['editDate']) : null,
    editUserId: json['editUserId'],
  );

  // Empty category in case null
  factory Category.empty() => Category(
    id: 0,
    arbName: '',
    engName: '',
    inActive: false,
    icon: '',
    regDate: DateTime.now(),
    regUserId: '',
    editDate: null,
    editUserId: null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arbName': arbName,
    'engName': engName,
    'inActive': inActive,
    'icon': icon,
    'regDate': regDate.toIso8601String(),
    'regUserId': regUserId,
    'editDate': editDate?.toIso8601String(),
    'editUserId': editUserId,
  };
}

class OptionGroup {
  final int id;
  final String arbName;
  final String engName;
  final bool isRequired;
  final bool allowMultiple;
  final int dishId;
  final List<Option> options;

  OptionGroup({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.isRequired,
    required this.allowMultiple,
    required this.dishId,
    required this.options,
  });

  factory OptionGroup.fromJson(Map<String, dynamic> json) => OptionGroup(
    id: json['id'] ?? 0,
    arbName: json['arbName'] ?? '',
    engName: json['engName'] ?? '',
    isRequired: json['isRequired'] ?? false,
    allowMultiple: json['allowMultiple'] ?? false,
    dishId: json['dishId'] ?? 0,
    options:
        json['options'] != null
            ? List<Option>.from(
              (json['options'] as List).map((x) => Option.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arbName': arbName,
    'engName': engName,
    'isRequired': isRequired,
    'allowMultiple': allowMultiple,
    'dishId': dishId,
    'options': List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  final int id;
  final String arbName;
  final String engName;
  final double price;

  Option({
    required this.id,
    required this.arbName,
    required this.engName,
    required this.price,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json['id'] ?? 0,
    arbName: json['arbName'] ?? '',
    engName: json['engName'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arbName': arbName,
    'engName': engName,
    'price': price,
  };
}
