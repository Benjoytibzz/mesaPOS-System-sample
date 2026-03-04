enum MenuCategory { appetizers, mainCourses, desserts, drinks, all }

class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final MenuCategory category;
  final bool isAvailable;
  final String? imageUrl;
  final bool isSpecial;
  final int? maxQuantity;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.imageUrl,
    this.isSpecial = false,
    this.maxQuantity,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: _parseCategory(json['category']),
      isAvailable: json['isAvailable'] ?? true,
      imageUrl: json['imageUrl'],
      isSpecial: json['isSpecial'] ?? false,
      maxQuantity: json['maxQuantity'],
    );
  }

  static MenuCategory _parseCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'appetizers':
        return MenuCategory.appetizers;
      case 'maincourses':
      case 'main courses':
        return MenuCategory.mainCourses;
      case 'desserts':
        return MenuCategory.desserts;
      case 'drinks':
        return MenuCategory.drinks;
      default:
        return MenuCategory.all;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.toString().split('.').last,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
      'isSpecial': isSpecial,
      'maxQuantity': maxQuantity,
    };
  }

  String get categoryDisplay {
    switch (category) {
      case MenuCategory.appetizers:
        return 'Appetizers';
      case MenuCategory.mainCourses:
        return 'Main Courses';
      case MenuCategory.desserts:
        return 'Desserts';
      case MenuCategory.drinks:
        return 'Drinks';
      case MenuCategory.all:
        return 'All Items';
    }
  }

  String get formattedPrice => '₱ ${price.toStringAsFixed(2)}';
}