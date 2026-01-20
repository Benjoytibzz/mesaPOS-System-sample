import 'package:flutter/material.dart';
import '../../core/platform/routes.dart';
import 'widgets/admin_layout.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      activeRoute: AppRoutes.staffManagement,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Staff Management',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Create, update, and manage staff'),
          ],
        ),
      ),
    );
  }
}
