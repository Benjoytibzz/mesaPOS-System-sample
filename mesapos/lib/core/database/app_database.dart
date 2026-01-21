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
      version: 5, // ⬅️ VERSION BUMP (add user image)
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /* --------------------------------------------------------
   * DATABASE CREATE (FRESH INSTALL)
   * ------------------------------------------------------ */
  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  /* --------------------------------------------------------
   * DATABASE UPGRADE (EXISTING INSTALLS)
   * ------------------------------------------------------ */
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // v1 → v2 : menu_items
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

    // v2 → v3 : unique menu name
    if (oldVersion < 3) {
      await db.execute(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_menu_name '
        'ON menu_items(LOWER(name))',
      );
    }

    // v3 → v4 : merge staff into users
    if (oldVersion < 4) {
      await db.execute(
        "ALTER TABLE users ADD COLUMN first_name TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE users ADD COLUMN last_name TEXT DEFAULT ''",
      );
      await db.execute(
        "ALTER TABLE users ADD COLUMN is_active INTEGER DEFAULT 1",
      );
    }

    // ✅ v4 → v5 : add staff image
    if (oldVersion < 5) {
      await db.execute(
        "ALTER TABLE users ADD COLUMN image_path TEXT",
      );
    }
  }

  /* --------------------------------------------------------
   * TABLE DEFINITIONS (FRESH INSTALL)
   * ------------------------------------------------------ */
  Future<void> _createTables(Database db) async {
    // USERS = STAFF + AUTH
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password_hash TEXT,
        role TEXT,
        first_name TEXT,
        last_name TEXT,
        image_path TEXT,
        is_active INTEGER DEFAULT 1,
        synced INTEGER
      )
    ''');

    // MENU ITEMS
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

    // UNIQUE MENU NAME (CASE-INSENSITIVE)
    await db.execute(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_menu_name '
      'ON menu_items(LOWER(name))',
    );
  }
}
