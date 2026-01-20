import 'package:uuid/uuid.dart';
import '../models/menu_item_model.dart';

class MenuService {
  final _uuid = const Uuid();
  final List<MenuItemModel> _items = [];

  List<MenuItemModel> getAll() => List.unmodifiable(_items);

  void addItem(String name, double price) {
    _items.add(
      MenuItemModel(
        id: _uuid.v4(),
        name: name,
        price: price,
      ),
    );
  }

  void updateItem(MenuItemModel item) {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) _items[index] = item;
  }

  void deleteItem(String id) {
  _items.removeWhere((item) => item.id == id);
  }

  void toggleStatus(String id) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index != -1) {
      _items[index] =
          _items[index].copyWith(isActive: !_items[index].isActive);
    }
  }

}
