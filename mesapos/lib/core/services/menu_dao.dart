
import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../models/menu_model.dart';

class MenuDao {
  Future<List<MenuItemModel>> getAll() async {
    final db = await AppDatabase.instance.database;
    final res = await db.query('menu_items', orderBy: 'name');
    return res.map(MenuItemModel.fromMap).toList();
  }

  Future<bool> nameExists(String name, {int? excludeId}) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      'menu_items',
      where: excludeId == null
          ? 'LOWER(name) = ?'
          : 'LOWER(name) = ? AND id != ?',
      whereArgs: excludeId == null
          ? [name.toLowerCase()]
          : [name.toLowerCase(), excludeId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<void> insert(MenuItemModel item) async {
    final db = await AppDatabase.instance.database;
    try {
      await db.insert('menu_items', item.toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('Menu name already exists');
      }
      rethrow;
    }
  }

  Future<void> update(MenuItemModel item) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'menu_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(
      'menu_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}