import 'package:sqflite/sqflite.dart';
import '../models/settings_model.dart';
import '../database/app_database.dart';

class SettingsDao {
  final AppDatabase _db = AppDatabase.instance;

  /// Get single settings row (id = 1)
  Future<SettingsModel?> getSettings() async {
    final Database database = await _db.database;

    final result = await database.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return SettingsModel.fromMap(result.first);
    }
    return null;
  }

  /// Save or replace full settings row
  Future<void> saveSettings(SettingsModel settings) async {
    final Database database = await _db.database;

    await database.insert(
      'settings',
      {
        ...settings.toMap(),
        'id': 1, // enforce single-row design
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update only selected fields (SAFE for partial updates)
  Future<void> updateSettings(Map<String, dynamic> values) async {
    final Database database = await _db.database;

    await database.update(
      'settings',
      {
        ...values,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
