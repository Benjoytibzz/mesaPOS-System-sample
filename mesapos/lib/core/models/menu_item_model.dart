class MenuItemModel {
  final String id;
  String name;
  double price;
  bool isActive;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.isActive = true,
  });

  MenuItemModel copyWith({
    String? name,
    double? price,
    bool? isActive,
  }) {
    return MenuItemModel(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }
}
