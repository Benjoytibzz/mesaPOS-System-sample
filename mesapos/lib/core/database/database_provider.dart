import 'dart:io';
import 'package:flutter/foundation.dart';

import 'app_database.dart';
import 'sqlite_db.dart';
import 'hive_db.dart';
import '../platform/ffi_init.dart';

late final AppDatabase db;

Future<void> initDatabase() async {
  if (kIsWeb) {
    db = HiveDatabase();
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    initSqliteForDesktop();
    db = SqliteDatabase();
  } else {
    db = SqliteDatabase();
  }

  await db.init();
}
