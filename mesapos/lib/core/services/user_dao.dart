import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../database/app_database.dart';
import '../models/user_model.dart';

class UserDao {
  static String hashPassword(String value) =>
      sha256.convert(utf8.encode(value)).toString();

  Future<List<UserModel>> getStaff() async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'users',
      where: "role != 'admin'",
      orderBy: 'id DESC',
    );
    return res.map(UserModel.fromMap).toList();
  }

  Future<bool> usernameExists(String username) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<void> insert(UserModel user) async {
    final db = await AppDatabase.instance.database;
    await db.insert('users', user.toMap());
  }

  Future<void> update(UserModel user) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> toggleActive(int id, int active) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'users',
      {'is_active': active, 'synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
