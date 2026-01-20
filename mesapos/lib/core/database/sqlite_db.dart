import 'local_db.dart';
import 'app_database.dart';
import '../models/user_model.dart';

class SqliteDatabase implements AppDatabase {
  @override
  Future<void> init() async {
    await LocalDB.database;
  }

  @override
  Future<UserModel?> getUser(String username) {
    return LocalDB.getUser(username);
  }

  @override
  Future<List<UserModel>> unsyncedUsers() {
    return LocalDB.unsyncedUsers();
  }

  @override
  Future<void> markSynced(int id) {
    return LocalDB.markSynced(id);
  }
}
