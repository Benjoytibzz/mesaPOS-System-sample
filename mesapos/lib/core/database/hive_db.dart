import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_database.dart';
import '../models/user_model.dart';
import '../security/crypto_util.dart';

class HiveDatabase implements AppDatabase {
  static const String boxName = 'users';

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);

    final box = Hive.box(boxName);

    if (box.isEmpty) {
      box.put('admin', {
        'id': 1,
        'username': 'admin',
        'password_hash': CryptoUtil.hashPassword('1234'),
        'role': 'admin',
        'synced': 1,
      });

      box.put('staff', {
        'id': 2,
        'username': 'staff',
        'password_hash': CryptoUtil.hashPassword('0000'),
        'role': 'staff',
        'synced': 1,
      });
    }
  }

  @override
  Future<UserModel?> getUser(String username) async {
    final box = Hive.box(boxName);
    final data = box.get(username);

    if (data == null) return null;
    return UserModel.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<List<UserModel>> unsyncedUsers() async {
    final box = Hive.box(boxName);
    return box.values
        .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
        .where((u) => u.synced == 0)
        .toList();
  }

  @override
  Future<void> markSynced(int id) async {
    final box = Hive.box(boxName);
    for (final key in box.keys) {
      final u = box.get(key);
      if (u['id'] == id) {
        u['synced'] = 1;
        box.put(key, u);
      }
    }
  }
}
