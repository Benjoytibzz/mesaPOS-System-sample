import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../security/crypto_util.dart';

class LocalDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    try {
      _db = await _initDB();
      log('✅ SQLite DB initialized');
      return _db!;
    } catch (e, s) {
      log('❌ SQLite init failed', error: e, stackTrace: s);
      rethrow;
    }
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pos_app.db');

    log('📂 DB Path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        try {
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT UNIQUE NOT NULL,
              password_hash TEXT NOT NULL,
              role TEXT NOT NULL,
              synced INTEGER NOT NULL DEFAULT 0
            )
          ''');

          // Seed users
          await db.insert('users', {
            'username': 'admin',
            'password_hash': CryptoUtil.hashPassword('1234'),
            'role': 'admin',
            'synced': 1,
          });

          await db.insert('users', {
            'username': 'staff',
            'password_hash': CryptoUtil.hashPassword('0000'),
            'role': 'staff',
            'synced': 1,
          });

          log('✅ Users table created & seeded');
        } catch (e, s) {
          log('❌ onCreate failed', error: e, stackTrace: s);
          rethrow;
        }
      },
      onOpen: (_) => log('📦 SQLite DB opened'),
    );
  }

  static Future<UserModel?> getUser(String username) async {
    try {
      final db = await database;
      final res = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      return res.isNotEmpty ? UserModel.fromMap(res.first) : null;
    } catch (e, s) {
      log('❌ getUser failed', error: e, stackTrace: s);
      return null;
    }
  }

  static Future<void> markSynced(int id) async {
    try {
      final db = await database;
      await db.update(
        'users',
        {'synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, s) {
      log('❌ markSynced failed', error: e, stackTrace: s);
    }
  }

  static Future<List<UserModel>> unsyncedUsers() async {
    try {
      final db = await database;
      final res = await db.query(
        'users',
        where: 'synced = ?',
        whereArgs: [0],
      );

      return res.map((e) => UserModel.fromMap(e)).toList();
    } catch (e, s) {
      log('❌ unsyncedUsers failed', error: e, stackTrace: s);
      return [];
    }
  }

}

  
