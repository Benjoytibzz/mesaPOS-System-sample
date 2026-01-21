import '../../../core/database/app_database.dart';
import '../models/menu_model.dart';

class MenuDao {
  Future<int> insert(MenuItemModel item) async {
    final db = await AppDatabase.instance.database;
    return db.insert('menu_items', item.toMap());
  }

  Future<List<MenuItemModel>> getAll() async {
    final db = await AppDatabase.instance.database;
    final res = await db.query('menu_items', orderBy: 'name');
    return res.map((e) => MenuItemModel.fromMap(e)).toList();
  }

  Future<int> update(MenuItemModel item) async {
    final db = await AppDatabase.instance.database;
    return db.update(
      'menu_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete(
      'menu_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
