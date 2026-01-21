import 'package:flutter/material.dart';
import '../../services/logout_service.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔒 disables back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Dashboard'),
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
          child: Text('Staff Dashboard'),
        ),
      ),
    );
  }
}
