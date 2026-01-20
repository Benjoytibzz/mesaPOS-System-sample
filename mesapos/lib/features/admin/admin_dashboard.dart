import 'package:flutter/material.dart';
import '../../core/services/logout_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔒 disables back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                LogoutService.logout(context);
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('Admin Dashboard'),
        ),
      ),
    );
  }
}
