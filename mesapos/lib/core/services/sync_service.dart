import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../database/local_db.dart';

class SyncService {
  static const String apiUrl =
      'https://api.yourpos.com/sync/users';

  static Future<void> syncIfOnline() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    final users = await LocalDB.unsyncedUsers();

    for (final user in users) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toMap()),
      );

      if (response.statusCode == 200) {
        await LocalDB.markSynced(user.id!);
      }
    }
  }
}
