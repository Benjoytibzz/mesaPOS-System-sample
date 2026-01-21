import '../../core/database/app_database.dart';
import '../models/user_model.dart';

class UserDao {
  Future<UserModel?> login(String username) async {
    final db = await AppDatabase.instance.database;
    final res = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return res.isNotEmpty ? UserModel.fromMap(res.first) : null;
  }

  Future<void> insert(UserModel user) async {
    final db = await AppDatabase.instance.database;
    await db.insert('users', user.toMap());
  }
}
