import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initSqliteForDesktop() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
