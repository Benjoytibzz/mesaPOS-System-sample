import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/sync_service.dart';
import '../admin/admin_dashboard.dart';
import '../staff/staff_dashboard.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<void> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    final user = await _authService.login(username, password);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
      return;
    }

    await SyncService.syncIfOnline();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            user.role == 'admin'
                ? const AdminDashboard()
                : const StaffDashboard(),
      ),
      (route) => false, // 🔒 clears back stack
    );
  }
}
