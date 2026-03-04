import '../models/menu_item_model.dart';
import '../services/database_service.dart';
import '../services/api_service.dart';

class MenuRepository {
  final DatabaseService _databaseService;
  final ApiService _apiService;

  MenuRepository({
    required DatabaseService databaseService,
    required ApiService apiService,
  })  : _databaseService = databaseService,
        _apiService = apiService;

  // Get all menu items
  Future<List<MenuItemModel>> getMenuItems() async {
    return await _databaseService.getMenuItems();
  }

  // Get menu items by category
  Future<List<MenuItemModel>> getMenuItemsByCategory(MenuCategory category) async {
    final allItems = await _databaseService.getMenuItems();
    if (category == MenuCategory.all) {
      return allItems;
    }
    return allItems.where((item) => item.category == category).toList();
  }

  // Get available items
  Future<List<MenuItemModel>> getAvailableItems() async {
    final allItems = await _databaseService.getMenuItems();
    return allItems.where((item) => item.isAvailable).toList();
  }

  // Get special items
  Future<List<MenuItemModel>> getSpecialItems() async {
    final allItems = await _databaseService.getMenuItems();
    return allItems.where((item) => item.isSpecial).toList();
  }

  // Search menu items
  Future<List<MenuItemModel>> searchMenuItems(String query) async {
    final allItems = await _databaseService.getMenuItems();
    if (query.isEmpty) return allItems;
    
    final lowerQuery = query.toLowerCase();
    return allItems.where((item) {
      return item.name.toLowerCase().contains(lowerQuery) ||
          item.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get menu item by ID
  Future<MenuItemModel?> getMenuItemById(String id) async {
    final allItems = await _databaseService.getMenuItems();
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}