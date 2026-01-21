class MenuItemModel {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imagePath;
  final int isAvailable;

  MenuItemModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imagePath,
    this.isAvailable = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_path': imagePath,
      'is_available': isAvailable,
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      price: map['price'],
      category: map['category'],
      imagePath: map['image_path'],
      isAvailable: map['is_available'],
    );
  }
}
