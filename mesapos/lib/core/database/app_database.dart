import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _db;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'pos_app.db');

    return openDatabase(
      path,
      version: 3, // ⬅️ VERSION BUMP (IMPORTANT)
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Existing table creation (from v1 → v2)
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS menu_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          price REAL,
          category TEXT,
          image_path TEXT,
          is_available INTEGER,
          synced INTEGER
        )
      ''');
    }

    // ✅ NEW: Prevent duplicate menu names (case-insensitive)
    if (oldVersion < 3) {
      await db.execute(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_menu_name '
        'ON menu_items(LOWER(name))',
      );
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password_hash TEXT,
        role TEXT,
        synced INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS menu_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price REAL,
        category TEXT,
        image_path TEXT,
        is_available INTEGER,
        synced INTEGER
      )
    ''');

    // ✅ Ensure uniqueness even on fresh install
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_menu_name '
      'ON menu_items(LOWER(name))',
    );
  }
}
