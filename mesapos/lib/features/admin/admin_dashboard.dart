import 'package:flutter/material.dart';
import '../../core/platform/routes.dart';
import '../widgets/admin_layout.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      activeRoute: AppRoutes.adminDashboard,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Admin overview, stats, and system status'),
          ],
        ),
      ),
    );
  }
}
