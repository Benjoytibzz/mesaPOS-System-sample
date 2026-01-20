import '../models/user_model.dart';

abstract class AppDatabase {
  Future<void> init();
  Future<UserModel?> getUser(String username);
  Future<List<UserModel>> unsyncedUsers();
  Future<void> markSynced(int id);
}
